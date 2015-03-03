#import "BIViewTintAdjustmentModeEnum.h"

@implementation BIViewTintAdjustmentModeEnum
+ (void)load {
    [super load];
    BIRegisterSelfAsEnum(UIViewTintAdjustmentMode);
}

- (void)defineEnum {
    BIEnumDefine(UIViewTintAdjustmentMode,
            UIViewTintAdjustmentModeAutomatic,

            UIViewTintAdjustmentModeNormal,
            UIViewTintAdjustmentModeDimmed
    );
}


@end