#import "BITextSpellCheckingType.h"

@implementation BITextSpellCheckingType
+ (void)load {
    [super load];
    BIRegisterSelfAsEnum(UITextSpellCheckingType);
}

- (void)defineEnum {
    BIEnumDefine(UITextSpellCheckingType,
            UITextSpellCheckingTypeDefault,
            UITextSpellCheckingTypeNo,
            UITextSpellCheckingTypeYes);
}


@end