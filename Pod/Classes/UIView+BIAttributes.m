#import <objc/runtime.h>
#import "UIView+BIAttributes.h"
#import "BIInflatedViewHelper.h"

@implementation UIView (BIAttributes)
@dynamic bi_cachedViewHelper;

- (id <BIInflatedViewHelper>)bi_cachedViewHelper {
    return objc_getAssociatedObject(self, @selector(bi_cachedViewHelper));
}

- (void)setBi_cachedViewHelper:(id <BIInflatedViewHelper>)bi_cachedViewHelper {
    objc_setAssociatedObject(self, @selector(bi_cachedViewHelper), bi_cachedViewHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end