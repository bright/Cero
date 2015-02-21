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

- (UITableViewCell *)fillTableCellContent:(UITableView *)tableView layout:(NSString *)layoutName loaded:(OnViewInflated)loaded {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:layoutName];
    if (cell == nil) {
        cell = UITableViewCell.new;
        NSString *path = [self layoutPath:layoutName];
        BIInflatedViewContainer *container = [self reloadSuperview:cell.contentView path:path notify:loaded];
        cell.bi_cachedViewHelper = container;
        BIContentChangeObserver *observer = [self contentChangeObserveForPath:path];
        @weakify(tableView);
        [observer addNeedsReloadHandler:^{
            @strongify(tableView);
            [tableView reloadData];
        }                       boundTo:tableView];
    } else {
        loaded(cell.bi_cachedViewHelper);
    }

    return cell;
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