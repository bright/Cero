#import "BIBaselineAdjustmentEnum.h"

@implementation BIBaselineAdjustmentEnum
+ (void)load {
    [super load];
    BIRegisterSelfAsEnum(UIBaselineAdjustment);
}

- (void)defineEnum {
    BIEnumDefine(UIBaselineAdjustment,
            UIBaselineAdjustmentAlignBaselines, // default. used when shrinking text to position based on the original baseline
            UIBaselineAdjustmentAlignCenters,
            UIBaselineAdjustmentNone);
}


@end