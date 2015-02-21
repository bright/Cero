@class BIViewHierarchyBuilder;
@class BIContentChangeObserver;

typedef BIViewHierarchyBuilder *(^BuilderFactory)(NSData *content);

typedef BIViewHierarchyBuilder *(^CachedBuilderFactory)(BIViewHierarchyBuilder *);

@interface BIBuildersCache : NSObject
@property(nonatomic, copy) NSString *rootProjectPath;

- (BIViewHierarchyBuilder *)cachedBuilderFor:(NSString *)inBundlePath onNew:(BuilderFactory)builderFactory onCached:(CachedBuilderFactory)cachedFactory;

- (BIContentChangeObserver *)contentChangedObserver:(NSString *)inBundlePath;

- (void)setupInvalidateOnContentChange:(NSString *)inBundlePath;

- (void)invalidateFilePath:(NSString *)inBundlePath withNewContent:(NSData *)content;

- (void)addReloadSource:(NSString *)inBundlePath contentChangeObserver:(NSString *)rootInBundlePath;
@end