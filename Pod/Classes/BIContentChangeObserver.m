#import "BIContentChangeObserver.h"
#import "BIEXTScope.h"

@interface BIContentChangeObserver ()
@property(nonatomic, strong) NSMutableArray *observables;
@end

@implementation BIContentChangeObserver {
    NSMapTable *_handlers;
}
+ (BIContentChangeObserver *)observer:(id <BIContentChangeObservable>)observable {
    return [[self alloc] initWithObservable:observable];
}

- (instancetype)initWithObservable:(id <BIContentChangeObservable>)observable {
    self = [super init];
    if (self) {
        _handlers = [NSMapTable weakToStrongObjectsMapTable];
        _observables = [NSMutableArray new];
        [self addObservable:observable];
    }
    return self;
}

- (void)addObservable:(id <BIContentChangeObservable>)observable {
    NSAssert(observable != nil, @"Observable must not be null");
    if (![_observables containsObject:observable]) {
        [_observables addObject:observable];
        @weakify(self);
        observable.onContentChange = ^(NSString *path, NSData *content) {
            @strongify(self);
            [self notifyHandlers:path content:content];
        };
    }
}

- (void)notifyHandlers:(NSString *)path content:(NSData *)content {
    for (id key in _handlers.keyEnumerator) {
        if (key != nil) {
            OnContentChange handler = [_handlers objectForKey:key];
            if (handler != nil) {
                handler(path, content);
            } else {
                NSLog(@"ERROR: Nil handler detected in %@", self);
            }
        }

    }
}

- (void)addContentChangedHandler:(OnContentChange)handler boundTo:(id)boundObject {
    OnContentChange handlerCopy = [handler copy];
    [_handlers setObject:handlerCopy forKey:boundObject];
}

- (void)addHandler:(OnContentChangedAction)handler boundTo:(id)boundObject {
    [self addContentChangedHandler:^(NSString *path, NSData *content) {
        handler();
    }                      boundTo:boundObject];
}
@end