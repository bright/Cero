@class BIBuildersCache;
@class BIContentChangeObserver;
@class BIFileWatcher;

@interface BIContentChanges : NSObject
@property(nonatomic, weak) BIBuildersCache *cache;

- (BIContentChangeObserver *)contentChangedObserver:(NSString *)inBundlePath rootProjectPath:(NSString *)rootProjectPath;

- (BIFileWatcher *)fileContentWatcher:(NSString *)diskPath;

- (void)addChangeSource:(NSString *)inBundlePath contentChangeObserver:(NSString *)rootInBundlePath rootProjectPath:(NSString *)rootProjectPath;
@end