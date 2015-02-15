#import "BILayoutLoader.h"
#import "BIInflatedViewHelper.h"
#import "BILayoutInflater.h"
#import "BIInflatedViewContainer.h"
#import "BIBuildersCache.h"
#import "BIContentChangeObserver.h"
#import "BIEXTScope.h"
#import "UIView+BIAttributes.h"

@implementation BILayoutLoader {
    BILayoutInflater *_layoutInflater;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _layoutInflater = [BILayoutInflater defaultInflater];
    }

    return self;
}

- (void)fillViewOfController:(UIViewController *)controller layout:(NSString *)layoutName {
    [self fillViewOfController:controller layout:layoutName loaded:nil];
}

- (void)fillViewOfController:(UIViewController *)controller layout:(NSString *)layoutName loaded:(OnViewInflated)notify {
    [self fillView:controller.view layout:layoutName andCall:notify];
}

- (UITableViewCell *)fillTableCellContent:(UITableView *)tableView layout:(NSString *)layoutName loaded:(OnViewInflated)loaded {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:layoutName];
    if (cell == nil) {
        cell = UITableViewCell.new;
        NSString *path = [self layoutPathInMainBundle:layoutName];
        BIInflatedViewContainer *container = [self reloadSuperview:cell.contentView path:path notify:loaded];
        cell.bi_cachedViewHelper = container;
        BIContentChangeObserver *observer = [_layoutInflater.buildersCache contentChangedObserver:path];
        @weakify(tableView);
        [observer addHandler:^{
            @strongify(tableView);
            [tableView reloadData];
        }            boundTo:tableView];
    } else {
        loaded(cell.bi_cachedViewHelper);
    }

    return cell;
}

- (BIInflatedViewContainer *)fillView:(UIView *)superview layout:(NSString *)layoutName andCall:(OnViewInflated)notify {
    NSString *path = [self layoutPathInMainBundle:layoutName];
    BIInflatedViewContainer *newView = [self reloadSuperview:superview path:path notify:notify];
    BIContentChangeObserver *observer = [_layoutInflater.buildersCache contentChangedObserver:path];
    @weakify(self, superview);
    [observer addHandler:^{
        @strongify(self, superview);
        [self reloadSuperview:superview
                         path:path
                       notify:notify];
    }            boundTo:superview];
    return newView;
}

- (NSString *)layoutPathInMainBundle:(NSString *)layoutName {
    return [NSBundle.mainBundle pathForResource:layoutName ofType:@"xml"];
}

- (BIInflatedViewContainer *)reloadSuperview:(UIView *)superview path:(NSString *)path notify:(OnViewInflated)notify {
    for (UIView *view in superview.subviews) {
        //TODO: this is an awful hack - some of the subviews are not create by layout i.e. top layout guide
        //to fix this we need to either:
        // - remember all views created by layout
        // - mark them with some property (tag or associated object)
        if (![[NSStringFromClass(view.class) substringToIndex:1] isEqualToString:@"_"]) {
            [view removeFromSuperview];
        } else {
            NSLog(@"Subviews item is a private UIView %@", view);
        }
    }
    BIInflatedViewContainer *newView = [_layoutInflater inflateFilePath:path superview:superview];
    if (notify != nil) {
        notify(newView);
    }
    return newView;
}
@end