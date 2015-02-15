@interface UIView (Finders)
- (UIViewController *)bi_firstViewController;

- (UIView *)bi_commonSuperviewForConstraint:(id)otherViewOrGuide;
@end