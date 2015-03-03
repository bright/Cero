#import "BIViewTintAdjustmentModeHandler.h"
#import "BIEnumsRegistry.h"

@implementation BIViewTintAdjustmentModeHandler
- (instancetype)init {
    self = [super init];
    if (self) {
        self.attributeName = @"tintAdjustmentMode";
        self.setter = @selector(setTintAdjustmentMode:);
        self.valuesEnum = BIEnumFor(UIViewTintAdjustmentMode);
    }

    return self;
}

@end