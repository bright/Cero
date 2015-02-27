#import "BILayoutPriority.h"

@implementation BILayoutPriority
+ (void)load {
    [super load];
    BIRegisterSelfAsEnum(UILayoutPriority);
}

- (void)defineEnum {
    BIEnumDefine(UILayoutPriority,
            UILayoutPriorityRequired,
            UILayoutPriorityDefaultHigh,
            UILayoutPriorityDefaultLow,
            UILayoutPriorityFittingSizeLevel);
}


@end