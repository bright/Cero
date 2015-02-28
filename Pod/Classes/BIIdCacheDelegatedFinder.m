#import <objc/runtime.h>
#import "BIIdCacheDelegatedFinder.h"

@implementation BIIdCacheDelegatedFinder {
    __weak NSMapTable *_cache;
}
- (instancetype)initWithCache:(NSMapTable *)viewsCache {
    self = [super init];
    if (self) {
        _cache = viewsCache;
    }

    return self;
}

+ (BOOL)resolveInstanceMethod:(SEL)aSelector {
    NSString *elementId = NSStringFromSelector(aSelector);
    IMP impl = imp_implementationWithBlock((UIView *) ^(BIIdCacheDelegatedFinder *self) {
        return [self findElementById:elementId];
    });
    NSString *methodType = [NSString stringWithFormat:@"%s%s%s", @encode(id), @encode(id), @encode(SEL)];
    class_addMethod([self class], aSelector, impl, [methodType cStringUsingEncoding:NSASCIIStringEncoding]);
    return true;
}

- (UIView *)findElementById:(NSString *)id {
    UIView *element = [_cache objectForKey:id];
    if (element == nil) {
        [self doesNotRecognizeSelector:NSSelectorFromString(id)];
    }
    return element;
}
@end
