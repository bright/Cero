#import <objc/runtime.h>
#import "BIInflatedViewContainer.h"
#import "NSError+BIErrors.h"
#import "BISourceReference.h"

@interface BIViewCacheDelegatedFinder : NSObject
- (instancetype)initWithViewsCache:(NSMapTable *)viewsCache;
@end

@implementation BIViewCacheDelegatedFinder : NSObject {
    __weak NSMapTable *_viewsCache;
}
- (instancetype)initWithViewsCache:(__weak NSMapTable *)viewsCache {
    self = [super init];
    if (self) {
        _viewsCache = viewsCache;
    }

    return self;
}

+ (BOOL)resolveInstanceMethod:(SEL)aSelector {
    NSString *viewId = NSStringFromSelector(aSelector);
    IMP impl = imp_implementationWithBlock((UIView *) ^(BIViewCacheDelegatedFinder *self) {
        return [self findViewById:viewId];
    });
    NSString *methodType = [NSString stringWithFormat:@"%s%s%s", @encode(UIView *), @encode(id), @encode(SEL)];
    class_addMethod([self class], aSelector, impl, [methodType cStringUsingEncoding:NSASCIIStringEncoding]);
    return true;
}

- (UIView *)findViewById:(NSString *)id {
    UIView *view = [_viewsCache objectForKey:id];
    if (view == nil) {
        [self doesNotRecognizeSelector:NSSelectorFromString(id)];
    }
    return view;
}
@end

@interface BIInflatedViewContainer ()
@property(nonatomic, strong) UIView *root;
@end

@implementation BIInflatedViewContainer {
    NSMapTable *_viewsCache;
    NSMutableDictionary *_sourceCache;
    BIViewCacheDelegatedFinder *_delegatedTarget;
}
+ (instancetype)container:(UIView *)root {
    return [[self alloc] initWithRoot:root];
}

- (instancetype)initWithRoot:(UIView *)view {
    self = [super init];
    if (self) {
        _viewsCache = [NSMapTable strongToWeakObjectsMapTable];
        _sourceCache = NSMutableDictionary.new;
        self.root = view;
        _delegatedTarget = [[BIViewCacheDelegatedFinder alloc] initWithViewsCache:_viewsCache];
    }
    return self;
}

- (UIView *)findViewById:(NSString *)viewId {
    UIView *view = [_viewsCache objectForKey:viewId];
    return view;
}

- (BOOL)tryAddingView:(UIView *)view withId:(NSString *)id fromSource:(BISourceReference *)source error:(NSError **)error {
    UIView *existing = [_viewsCache objectForKey:id];
    if (existing == nil) {
        [_viewsCache setObject:view forKey:id];
        _sourceCache[id] = source;
        return true;
    } else {
        BISourceReference *existingElement = _sourceCache[id];
        NSError *duplicateIdError = [NSError bi_error:@"Duplicate id found"
                                               reason:[NSString stringWithFormat:@"An id '%@' is used at \n%@\n\nand at\n\n%@", id, existingElement.sourceDescription, source.sourceDescription]];
        NSLog(@"BILayoutError: %@", duplicateIdError);
        *error = duplicateIdError;
        return false;
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSString *propertyName = NSStringFromSelector(aSelector);
    UIView *view = [self findViewById:propertyName];
    if (view != nil) {
        return _delegatedTarget;
    }
    return [super forwardingTargetForSelector:aSelector];
}


@end