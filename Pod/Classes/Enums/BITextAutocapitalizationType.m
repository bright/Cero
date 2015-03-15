#import "BITextAutocapitalizationType.h"

@implementation BITextAutocapitalizationType
+ (void)load {
    [super load];
    BIRegisterSelfAsEnum(UITextAutocapitalizationType);
}

- (void)defineEnum {
    BIEnumDefine(UITextAutocapitalizationType,
            UITextAutocapitalizationTypeNone,
            UITextAutocapitalizationTypeWords,
            UITextAutocapitalizationTypeSentences,
            UITextAutocapitalizationTypeAllCharacters);
}
@end