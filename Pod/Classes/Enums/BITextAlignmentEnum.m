#import "BITextAlignmentEnum.h"

@implementation BITextAlignmentEnum
+ (void)load {
    [super load];
    BIRegisterSelfAsEnum(NSTextAlignment);
}

- (void)defineEnum {
    BIEnumDefine(NSTextAlignment,
            NSTextAlignmentLeft,
            NSTextAlignmentCenter,
            NSTextAlignmentRight,
            NSTextAlignmentCenter,
            NSTextAlignmentJustified,
            NSTextAlignmentNatural);
}


@end