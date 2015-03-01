#import <objc/runtime.h>
#import <Cero/BIInflatedViewContainer.h>
#import "NSError+BIErrors.h"
#import "BISourceReference.h"
#import "UIView+BIAttributes.h"
#import "BILog.h"
#import "BIIdCacheDelegatedFinder.h"

#undef BILogDebug
#define BILogDebug(...)


@interface BIInflatedViewContainer ()
@property(nonatomic, strong) UIView *root;
@property(nonatomic, strong) NSMapTable *byIdsCache;
@property(nonatomic, strong) NSMutableDictionary *sourceCache;
@property(nonatomic, readonly) OnBuilderReady onReadySteps;
@end

@implementation BIInflatedViewContainer {
    BIIdCacheDelegatedFinder *_delegatedTarget;
    NSMutableArray *_builderReadySteps;
}
+ (instancetype)container:(UIView *)root {
    return [[self alloc] initWithRoot:root];
}

- (instancetype)initWithRoot:(UIView *)view {
    self = [super init];
    if (self) {
        self.root = view;
        NSArray *steps;
        steps = _builderReadySteps = NSMutableArray.new;
        _byIdsCache = [NSMapTable strongToWeakObjectsMapTable];
        _sourceCache = NSMutableDictionary.new;
        _delegatedTarget = [[BIIdCacheDelegatedFinder alloc] initWithCache:_byIdsCache];
        //retain steps but not the whole container
        _onReadySteps = ^(BIInflatedViewContainer *container) {
            for (OnBuilderReady step in steps) {
                if (step != nil) {
                    step(container);
                }
            }
        };
    }
    return self;
}

- (UIView *)findViewById:(NSString *)viewId {
    return [self findElementById:viewId];
}

- (id)findElementById:(NSString *)elementId {
    id element = [_byIdsCache objectForKey:elementId];
    return element;
}

- (BOOL)tryAddingElement:(id)element withId:(NSString *)id fromSource:(BISourceReference *)source error:(NSError **)error {
    NSObject *existing = [_byIdsCache objectForKey:id];
    if (existing == nil) {
        [_byIdsCache setObject:element forKey:id];
        _sourceCache[id] = source;
        BILogDebug(@"New cache entry for key %@ is %@", id, element);
        return true;
    } else {
        BISourceReference *existingElement = _sourceCache[id];
        NSError *duplicateIdError = [NSError bi_error:@"Duplicate id found"
                                               reason:[NSString stringWithFormat:@"An id '%@' is used at \n%@\n\nand at\n\n%@", id, existingElement.sourceDescription, source.sourceDescription]];
        BILogDebug(@"BILayoutError: %@", duplicateIdError);
        *error = duplicateIdError;
        return false;
    }
}

- (BOOL)addOnReadyStep:(OnBuilderReady)onReady {
    if (onReady != nil && ![_builderReadySteps containsObject:onReady]) {
        [_builderReadySteps addObject:onReady];
        return YES;
    }
    return NO;
}

- (void)runOnReadySteps {
    [self runOnReadySteps:self];
}

- (void)runOnReadySteps:(BIInflatedViewContainer *)container {
    for (OnBuilderReady onReady in _builderReadySteps) {
        if (onReady != nil) {
            onReady(container);
        }
    }
}

- (void)addOnReadyStepsFrom:(BIInflatedViewContainer *)container {
    OnBuilderReady ready = container.onReadySteps;
    if (![self addOnReadyStep:ready]) {
        BILogDebug(@"Did not add ready step");
    }
}


- (BOOL)tryAddingElementsFrom:(BIInflatedViewContainer *)container error:(NSError **)error {
    NSMapTable *otherIdsCache = container.byIdsCache;
    NSMutableDictionary *otherSourceCache = container.sourceCache;
    for (NSString *id in otherIdsCache.keyEnumerator) {
        NSObject *element = [otherIdsCache objectForKey:id];
        if (element != nil) {
            BISourceReference *sourceReference = otherSourceCache[id];
            if (![self tryAddingElement:element withId:id fromSource:sourceReference error:error]) {
                return NO;
            }
        }
    }
    return YES;
}


- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSString *propertyName = NSStringFromSelector(aSelector);
    UIView *view = [self findElementById:propertyName];
    if (view != nil) {
        return _delegatedTarget;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (void)setSuperviewAsCurrent {
    UIView *parent = self.current.superview;
    BILogDebug(@"Moving to %@ from %@", parent, self.current);
    self.current = parent;
}

- (void)setCurrentAsSubview:(UIView *)view {
    NSAssert(view != nil, @"Subview (view) must not be nil");
    if (self.root == nil) {
        self.root = view;
    }
    UIView *parent = self.current;
    BILogDebug(@"Adding %@ as child of %@", view, parent);
    [parent addSubview:view];
    view.bi_isPartOfLayout = YES;
    self.current = view;
}

- (void)clearRootToAvoidMemoryLeaks {
    self.root = nil;
}
@end

