#import "BIKeyboardAppearance.h"

@implementation BIKeyboardAppearance
+ (void)load {
    [super load];
    BIRegisterSelfAsEnum(UIKeyboardAppearance);
}

- (void)defineEnum {
    BIEnumDefine(UIKeyboardAppearance,
            UIKeyboardAppearanceDefault,
            UIKeyboardAppearanceDark,
            UIKeyboardAppearanceLight,
            UIKeyboardAppearanceAlert);
}


@end