#import <Cero/BILayoutInflater.h>
#import "BILayoutLoader.h"
#import "BILayoutLoader+BIIncludeAssistance.h"
#import "BIInflatedViewHelper.h"
#import "BIInflatedViewContainer.h"
#import "BIBuildersCache.h"
#import "BIContentChangeObserver.h"
#import "BIEXTScope.h"
#import "UIView+BIAttributes.h"

@implementation BILayoutLoader {
    BILayoutInflater *_layoutInflater;
}

- (instancetype)init {
    return [self initWithInflater:[BILayoutInflater defaultInflater]];
}

- (instancetype)initWithInflater:(BILayoutInflater *)inflater {
    self = [super init];
    if (self) {
        _layoutInflater = inflater;
    }

    return self;
}

- (void)fillViewOfController:(UIViewController *)controller layout:(NSString *)layoutName {
    [self fillViewOfController:controller layout:layoutName loaded:nil];
}

- (void)fillViewOfController:(UIViewController *)controller layout:(NSString *)layoutName loaded:(OnViewInflated)notify {
    [self fillView:controller.view layout:layoutName loaded:notify];
}

- (UICollectionViewCell *)fillCollectionCellContent:(UICollectionView *)collectionView layout:(NSString *)layoutName indexPath:(NSIndexPath *)path loaded:(OnViewInflated)loaded {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:layoutName forIndexPath:path];
    if (cell == nil) {
        cell = UICollectionViewCell.new;
    }
    [self reloadLayout:layoutName loaded:loaded collectionView:collectionView cell:cell];
    return cell;
}

- (UITableViewCell *)fillTableCellContent:(UITableView *)tableView layout:(NSString *)layoutName loaded:(OnViewInflated)loaded {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:layoutName];
    if (cell == nil) {
        cell = UITableViewCell.new;
    }

    [self reloadLayout:layoutName loaded:loaded collectionView:tableView cell:cell];

    return cell;
}

- (void)reloadLayout:(NSString *)layoutName loaded:(OnViewInflated)loaded collectionView:(UIView *)collectionView cell:(id)cell {
    UIView *cellView = (UIView *) cell;
    if (cellView.bi_cachedViewHelper == nil) {
        NSString *layoutPath = [self layoutPath:layoutName];
        UIView *contentView = [cell contentView];
        BIInflatedViewContainer *container = [self reloadSuperview:contentView path:layoutPath notify:loaded];
        cellView.bi_cachedViewHelper = container;
        BIContentChangeObserver *observer = [self contentChangeObserveForPath:layoutPath];
        @weakify(collectionView);
        [observer addNeedsReloadHandler:^{
            @strongify(collectionView);
            [(id) collectionView reloadData];
        }                       boundTo:collectionView];
    } else {
        loaded(cellView.bi_cachedViewHelper);
    }
}

- (BIInflatedViewContainer *)fillView:(UIView *)superview layout:(NSString *)layoutName loaded:(OnViewInflated)notify {
    NSString *path = [self layoutPath:layoutName];
    BIInflatedViewContainer *newView = [self reloadSuperview:superview path:path notify:notify];
    BIContentChangeObserver *observer = [self contentChangeObserveForPath:path];
    @weakify(self, superview);
    [observer addNeedsReloadHandler:^{
        @strongify(self, superview);
        [self reloadSuperview:superview
                         path:path
                       notify:notify];
    }                       boundTo:superview];
    return newView;
}

- (BIContentChangeObserver *)contentChangeObserveForPath:(NSString *)path {
    return [_layoutInflater.buildersCache contentChangedObserver:path];
}

- (NSString *)layoutPath:(NSString *)layoutName {
    return [_layoutInflater layoutPath:layoutName];
}

- (BIInflatedViewContainer *)reloadSuperview:(UIView *)superview path:(NSString *)path notify:(OnViewInflated)notify {
    return [_layoutInflater reloadSuperview:superview path:path notify:notify];
}


@end