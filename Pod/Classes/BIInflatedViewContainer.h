#import "BIInflatedViewHelper.h"

@interface BIInflatedViewContainer : NSObject<BIInflatedViewHelper>
@property (nonatomic, readonly) UIView *root;
+(instancetype)container:(UIView *)root;
- (instancetype)initWithRoot:(UIView *)view;
@end