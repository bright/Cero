@protocol BIAttributeHandler;

@interface EnumAttributeHandlers : NSObject
- (NSObject <BIAttributeHandler> *)textAutocapitalizaitonType;

- (NSObject <BIAttributeHandler> *)textAutocorrectionType;
@end