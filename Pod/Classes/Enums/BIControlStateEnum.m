#import "BIControlStateEnum.h"

@implementation BIControlStateEnum {
}
+ (void)load {
    BIRegisterSelfAsEnum(UIControlState);
}

- (void)defineEnum {
    BIEnumDefine(UIControlState,
            UIControlStateNormal,
            UIControlStateDisabled,
            UIControlStateSelected,
            UIControlStateHighlighted,
            UIControlStateApplication
    );
}


@end