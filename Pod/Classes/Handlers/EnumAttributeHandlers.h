@protocol BIAttributeHandler;

@interface EnumAttributeHandlers : NSObject
- (NSObject <BIAttributeHandler> *)textAutocapitalizaitonType;

- (NSObject <BIAttributeHandler> *)textAutocorrectionType;

- (NSObject <BIAttributeHandler> *)spellCheckingType;

- (NSObject <BIAttributeHandler> *)keyboardType;

- (NSObject <BIAttributeHandler> *)keyboardAppearance;

- (NSObject <BIAttributeHandler> *)returnKeyType;
@end