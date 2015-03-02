#import "BITextAlignmentHandler.h"
#import "BIEnum.h"

@implementation BITextAlignmentHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        self.attributeName = @"textAlignment";
        self.setter = @selector(setTextAlignment:);
        self.valuesEnum = BIEnumFor(NSTextAlignment);
    }

    return self;
}

@end