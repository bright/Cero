#import "BIBaselineAdjustmentAttributeHandler.h"
#import "BIEnum.h"

@implementation BIBaselineAdjustmentAttributeHandler
- (instancetype)init {
    self = [super init];
    if (self) {
        self.attributeName = @"baselineAdjustment";
        self.setter = @selector(setBaselineAdjustment:);
        self.valuesEnum = BIEnumFor(UIBaselineAdjustment);
    }

    return self;
}

@end