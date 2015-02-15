@protocol BIInflatedViewHelper;

@interface UIView (BIAttributes)
@property(nonatomic, strong) id <BIInflatedViewHelper> bi_cachedViewHelper;
@end