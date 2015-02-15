@class BIViewHierarchyBuilder;

typedef BIViewHierarchyBuilder *(^BuilderFactory)(NSData *content);

typedef BIViewHierarchyBuilder *(^CachedBuilderFactory)(BIViewHierarchyBuilder *);

@interface BIBuildersCache : NSObject
@property(nonatomic, copy) NSString *rootProjectPath;

- (BIViewHierarchyBuilder *)cachedBuilderFor:(NSString *)inBundlePath onNew:(BuilderFactory)builderFactory onCached:(CachedBuilderFactory)cachedFactory;
@end