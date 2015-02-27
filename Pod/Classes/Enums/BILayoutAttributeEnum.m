#import "BILayoutAttributeEnum.h"

@implementation BILayoutAttributeEnum

+ (void)load {
    [super load];
    BIRegisterSelfAsEnum(NSLayoutAttribute);
}

- (void)defineEnum {
    BIEnumDefine(NSLayoutAttribute,
            NSLayoutAttributeLeft,
            NSLayoutAttributeRight,
            NSLayoutAttributeTop,
            NSLayoutAttributeBottom,
            NSLayoutAttributeLeading,
            NSLayoutAttributeTrailing,
            NSLayoutAttributeWidth,
            NSLayoutAttributeHeight,
            NSLayoutAttributeCenterX,
            NSLayoutAttributeCenterY,
            NSLayoutAttributeBaseline,
            NSLayoutAttributeLastBaseline
    );

    BIEnumDefine(NSLayoutAttribute,
            NSLayoutAttributeFirstBaseline,
            NSLayoutAttributeLeftMargin,
            NSLayoutAttributeRightMargin,
            NSLayoutAttributeTopMargin,
            NSLayoutAttributeBottomMargin,
            NSLayoutAttributeLeadingMargin,
            NSLayoutAttributeTrailingMargin,
            NSLayoutAttributeCenterXWithinMargins,
            NSLayoutAttributeCenterYWithinMargins,
            NSLayoutAttributeNotAnAttribute);
}


@end