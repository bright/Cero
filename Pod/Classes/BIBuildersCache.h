@class BIViewHierarchyBuilder;

typedef BIViewHierarchyBuilder *(^BuilderFactory)();

typedef BIViewHierarchyBuilder *(^CachedBuilderFactory)(BIViewHierarchyBuilder *);

@interface BIBuildersCache : NSObject
- (BIViewHierarchyBuilder *)cachedBuilderFor:(NSString *)inBundlePath onNew:(BuilderFactory)builderFactory onCached:(CachedBuilderFactory)cachedFactory;
@end