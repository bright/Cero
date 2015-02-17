@protocol BIInflatedViewHelper;

@interface UIView (BIAttributes)
@property(nonatomic, strong) id <BIInflatedViewHelper> bi_cachedViewHelper;
@property(nonatomic) BOOL bi_isPartOfLayout;
@end