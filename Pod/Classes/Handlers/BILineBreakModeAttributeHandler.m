#import "BILineBreakModeAttributeHandler.h"
#import "BIEnum.h"

@implementation BILineBreakModeAttributeHandler
- (instancetype)init {
    self = [super init];
    if (self) {
        self.attributeName = @"lineBreakMode";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        self.setter = @selector(setLineBreakMode:);
#pragma clang diagnostic pop
        self.valuesEnum = BIEnumFor(NSLineBreakMode);
    }
    return self;
}

@end