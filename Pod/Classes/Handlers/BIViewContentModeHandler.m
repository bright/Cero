#import "BIViewContentModeHandler.h"
#import "BIEnum.h"


@implementation BIViewContentModeHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        self.setter = @selector(setContentMode:);
        self.attributeName = @"contentMode";
        self.valuesEnum = BIEnumFor(UIViewContentMode);
    }
    return self;
}

@end