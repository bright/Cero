#import "BIHandlersConfiguration.h"

@interface BIHandlersConfigurationCache : NSObject<BIHandlersConfiguration>
@property(nonatomic, strong) NSArray *attributeHandlers;
@property(nonatomic, strong) NSArray *elementHandlers;
@end