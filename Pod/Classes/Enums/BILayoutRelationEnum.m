#import "BILayoutRelationEnum.h"

@implementation BILayoutRelationEnum

+ (void)load {
    [super load];
    BIRegisterSelfAsEnum(NSLayoutRelation);
}

- (void)defineEnum {
    BIEnumDefine(NSLayoutRelation,
            NSLayoutRelationLessThanOrEqual,
            NSLayoutRelationEqual,
            NSLayoutRelationGreaterThanOrEqual);
}


@end