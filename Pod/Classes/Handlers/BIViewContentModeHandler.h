#import "BIAttributeHandler.h"

@class BIEnum;

@interface BIViewContentModeHandler : NSObject <BIAttributeHandler>
@property(nonatomic, copy) NSString *attributeName;
@property(nonatomic) SEL setter;
@property(nonatomic, strong) BIEnum *valuesEnum;
@end