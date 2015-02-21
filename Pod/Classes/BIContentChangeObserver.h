#import "BIContentChangeObservable.h"

@protocol BIContentChangeObservable;

typedef void (^OnContentChangedAction)();

@interface BIContentChangeObserver : NSObject
@property(nonatomic, copy) NSString *inBundlePath;

+ (BIContentChangeObserver *)observer:(id <BIContentChangeObservable>)contentChangedObservable;

- (instancetype)initWithObservable:(id <BIContentChangeObservable>)contentChangedObservable;

- (void)addNeedsReloadObservable:(id <BIContentChangeObservable>)observable;

- (void)addContentChangedHandler:(OnContentChange)handler boundTo:(id)boundObject;

- (void)addNeedsReloadHandler:(OnContentChangedAction)handler boundTo:(id)boundObject;

- (void)notifyContentChangedHandlers:(NSString *)path content:(NSData *)content;

- (void)notifyNeedsReloadHandlers;
@end