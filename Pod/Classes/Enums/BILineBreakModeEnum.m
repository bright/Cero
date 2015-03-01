#import "BILineBreakModeEnum.h"

@implementation BILineBreakModeEnum
+ (void)load {
    [super load];
    BIRegisterSelfAsEnum(NSLineBreakMode);
}

- (void)defineEnum {
    BIEnumDefine(NSLineBreakMode,
            NSLineBreakByWordWrapping,        /* Wrap at word boundaries, default */
            NSLineBreakByCharWrapping,        /* Wrap at character boundaries */
            NSLineBreakByClipping,        /* Simply clip */
            NSLineBreakByTruncatingHead,    /* Truncate at head of line: "...wxyz" */
            NSLineBreakByTruncatingTail,    /* Truncate at tail of line: "abcd..." */
            NSLineBreakByTruncatingMiddle);
}


@end