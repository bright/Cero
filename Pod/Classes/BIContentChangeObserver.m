#import "BIContentChangeObserver.h"
#import "BIEXTScope.h"

@interface BIContentChangeObserver ()
@property(nonatomic, strong) id <BIContentChangeObservable> observable;
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
        self.observable = observable;
        @weakify(self);
        self.observable.onContentChange = ^(NSString *path, NSData *content) {
            @strongify(self);
            [self notifyHandlers:path content:content];
        };
    }
    return self;
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