#import <objc/runtime.h>
#import "UIView+BIAttributes.h"
#import "BIInflatedViewHelper.h"

@implementation UIView (BIAttributes)
@dynamic bi_cachedViewHelper;
@dynamic bi_isPartOfLayout;

- (id <BIInflatedViewHelper>)bi_cachedViewHelper {
    return objc_getAssociatedObject(self, @selector(bi_cachedViewHelper));
}

- (void)setBi_cachedViewHelper:(id <BIInflatedViewHelper>)bi_cachedViewHelper {
    objc_setAssociatedObject(self, @selector(bi_cachedViewHelper), bi_cachedViewHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)bi_isPartOfLayout {
    NSNumber *boolWrapped = objc_getAssociatedObject(self, @selector(bi_isPartOfLayout));
    return boolWrapped.boolValue;
}

- (void)setBi_isPartOfLayout:(BOOL)bi_isPartOfLayout {
    NSNumber *value = @(bi_isPartOfLayout);
    objc_setAssociatedObject(self, @selector(bi_cachedViewHelper), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end