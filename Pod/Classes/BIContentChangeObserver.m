#import "BIContentChangeObserver.h"
#import "BIEXTScope.h"
#import "BILog.h"

@interface BIContentChangeObserver ()
@property(nonatomic, strong) NSMutableArray *needsReloadObservable;
@end

@implementation BIContentChangeObserver {
    NSMapTable *_contentChangeHandlers;
    NSMapTable *_needReloadAfterChangeHandlers;
    id <BIContentChangeObservable> _contentChangedObservable;
}
+ (BIContentChangeObserver *)observer:(id <BIContentChangeObservable>)contentChangedObservable {
    return [[self alloc] initWithObservable:contentChangedObservable];
}

- (instancetype)initWithObservable:(id <BIContentChangeObservable>)contentChangedObservable {
    self = [super init];
    if (self) {
        _contentChangeHandlers = [NSMapTable weakToStrongObjectsMapTable];
        _needReloadAfterChangeHandlers = [NSMapTable weakToStrongObjectsMapTable];
        _needsReloadObservable = [NSMutableArray new];
        _contentChangedObservable = contentChangedObservable;
        @weakify(self);
        _contentChangedObservable.onContentChange = ^(NSString *path, NSData *content) {
            @strongify(self);
            [self notifyContentChangedHandlers:path content:content];
            [self notifyNeedsReloadHandlers];
        };
    }
    return self;
}

- (void)notifyNeedsReloadHandlers {
    for (id key in _needReloadAfterChangeHandlers.keyEnumerator) {
        if (key != nil) {
            OnContentChangedAction handler = [_needReloadAfterChangeHandlers objectForKey:key];
            if (handler != nil) {
                handler();
            } else {
                BILog(@"ERROR: Nil handler detected in %@", self);
            }
        }
    }
}

- (void)notifyContentChangedHandlers:(NSString *)path content:(NSData *)content {
    for (id key in _contentChangeHandlers.keyEnumerator) {
        if (key != nil) {
            OnContentChange handler = [_contentChangeHandlers objectForKey:key];
            if (handler != nil) {
                handler(path, content);
            } else {
                BILog(@"ERROR: Nil handler detected in %@", self);
            }
        }

    }
}

- (void)addNeedsReloadObservable:(id <BIContentChangeObservable>)observable {
    NSAssert(observable != nil, @"Observable must not be null");
    NSAssert(observable.onContentChange == nil, @"onContent change must be nil");
    if (![_needsReloadObservable containsObject:observable]) {
        [_needsReloadObservable addObject:observable];
        @weakify(self);
        observable.onContentChange = ^(NSString *path, NSData *content) {
            @strongify(self);
            [self notifyNeedsReloadHandlers];
        };
    }
}

- (void)addContentChangedHandler:(OnContentChange)handler boundTo:(id)boundObject {
    OnContentChange handlerCopy = [handler copy];
    [_contentChangeHandlers setObject:handlerCopy forKey:boundObject];
}

- (void)addNeedsReloadHandler:(OnContentChangedAction)handler boundTo:(id)boundObject {
    OnContentChangedAction handlerCopy = [handler copy];
    [_needReloadAfterChangeHandlers setObject:handlerCopy forKey:boundObject];
}

- (void)addNeedsReloadSource:(BIContentChangeObserver *)needsReloadSource {
    @weakify(self);
    [needsReloadSource addNeedsReloadHandler:^{
        @strongify(self);
        [self notifyNeedsReloadHandlers];
    }                                boundTo:self];
}
@end