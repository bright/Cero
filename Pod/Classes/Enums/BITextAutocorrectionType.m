#import "BITextAutocorrectionType.h"

@implementation BITextAutocorrectionType
+ (void)load {
    [super load];
    BIRegisterSelfAsEnum(UITextAutocorrectionType);
}

- (void)defineEnum {
    BIEnumDefine(UITextAutocorrectionType,
            UITextAutocorrectionTypeDefault,
            UITextAutocorrectionTypeNo,
            UITextAutocorrectionTypeYes);
}


@end