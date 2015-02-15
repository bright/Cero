@protocol BIInflatedViewHelper;

typedef void (^OnViewInflated)(id <BIInflatedViewHelper>);

@interface BILayoutLoader : NSObject
- (void)fillViewOfController:(UIViewController *)controller layout:(NSString *)layoutName;

- (void)fillViewOfController:(UIViewController *)controller layout:(NSString *)layoutName loaded:(OnViewInflated)notify;

- (UITableViewCell *)fillTableCellContent:(UITableView *)tableView layout:(NSString *)layoutName loaded:(OnViewInflated)loaded;
@end