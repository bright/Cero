@class BIEnum;
@protocol BIAttributeHandler;

@interface BIEnumAttributeHandler : NSObject <BIAttributeHandler>
@property(nonatomic, copy) NSString *attributeName;
@property(nonatomic) SEL setter;
@property(nonatomic, strong) BIEnum *valuesEnum;
@end