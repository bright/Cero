#import "BIContentChangeObservable.h"

@protocol BIContentChangeObservable;

typedef void (^OnContentChangedAction)();

@interface BIContentChangeObserver : NSObject
@property(nonatomic, copy) NSString *inBundlePath;

+ (BIContentChangeObserver *)observer:(id <BIContentChangeObservable>)observable;

- (instancetype)initWithObservable:(id <BIContentChangeObservable>)observable;

- (void)addObservable:(id <BIContentChangeObservable>)observable;

- (void)addContentChangedHandler:(OnContentChange)handler boundTo:(id)boundObject;

- (void)addHandler:(OnContentChangedAction)handler boundTo:(id)boundObject;

@end