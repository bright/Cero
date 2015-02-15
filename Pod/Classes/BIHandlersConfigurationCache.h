#import "BIHandlersConfiguration.h"

@class BIBuildersCache;

@interface BIHandlersConfigurationCache : NSObject <BIHandlersConfiguration>
@property(nonatomic, strong) NSArray *attributeHandlers;
@property(nonatomic, strong) NSArray *elementHandlers;
@property(nonatomic, strong) BIBuildersCache *buildersCache;
@end