@class BIBuildersCache;
@class BIContentChangeObserver;

@interface BIContentChanges : NSObject
@property(nonatomic, weak) BIBuildersCache *cache;

- (BIContentChangeObserver *)contentChangedObserver:(NSString *)inBundlePath rootProjectPath:(NSString *)rootProjectPath;
@end