#import "BIReturnKeyType.h"

@implementation BIReturnKeyType
+ (void)load {
    [super load];
    BIRegisterSelfAsEnum(UIReturnKeyType);
}

- (void)defineEnum {
    BIEnumDefine(UIReturnKeyType,
            UIReturnKeyDefault,
            UIReturnKeyGo,
            UIReturnKeyGoogle,
            UIReturnKeyJoin,
            UIReturnKeyNext,
            UIReturnKeyRoute,
            UIReturnKeySearch,
            UIReturnKeySend,
            UIReturnKeyYahoo,
            UIReturnKeyDone,
            UIReturnKeyEmergencyCall);
}


@end