@protocol BIInflatedViewHelper;
@class BIInflatedViewContainer;
@class BILayoutInflater;
@class UIViewController;
@class UITableViewCell;
@class UITableView;

typedef void (^OnViewInflated)(id <BIInflatedViewHelper>);

@interface BILayoutLoader : NSObject
- (instancetype)initWithInflater:(BILayoutInflater *)inflater;

- (void)fillViewOfController:(UIViewController *)controller layout:(NSString *)layoutName;

- (void)fillViewOfController:(UIViewController *)controller layout:(NSString *)layoutName loaded:(OnViewInflated)notify;

- (UITableViewCell *)fillTableCellContent:(UITableView *)tableView layout:(NSString *)layoutName loaded:(OnViewInflated)loaded;

- (BIInflatedViewContainer *)fillView:(UIView *)superview layout:(NSString *)layoutName loaded:(OnViewInflated)notify;
@end