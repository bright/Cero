#import "BIInflatedViewContainer.h"
#import "BILayoutElement.h"
#import "NSError+BIErrors.h"
#import "BISourceReference.h"

@interface BIInflatedViewContainer ()
@property(nonatomic, strong) UIView *root;
@end

@implementation BIInflatedViewContainer {
    NSMapTable *_viewsCache;
    NSMutableDictionary *_sourceCache;
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
    }
    return self;
}

- (UIView *)findViewById:(NSString *)viewId {
    UIView *view = [_viewsCache objectForKey:viewId];
    return view;
}

- (bool)tryAddingView:(UIView *)view withId:(NSString *)id fromSource:(BISourceReference *)source error:(NSError **)error {
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
@end