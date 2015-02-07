@protocol BIInflatedViewHelper <NSObject>
-(UIView *)root;
-(UIView *)findViewById:(NSString *)viewId;

- (id)findElementById:(NSString *)elementId;
@end