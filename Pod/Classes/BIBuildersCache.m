#import "BIBuildersCache.h"
#import "BIViewHierarchyBuilder.h"

@implementation BIBuildersCache {

}
- (BIViewHierarchyBuilder *)cachedBuilderFor:(NSString *)inBundlePath
                                       onNew:(BuilderFactory)builderFactory
                                    onCached:(CachedBuilderFactory)cachedFactory {
    return builderFactory();
}

@end