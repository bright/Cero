#import "BIViewContentModeEnum.h"

@implementation BIViewContentModeEnum
+ (void)load {
    [super load];
    BIRegisterSelfAsEnum(UIViewContentMode);
}

- (void)defineEnum {
    BIEnumDefine(UIViewContentMode,
            UIViewContentModeScaleToFill,
            UIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
            UIViewContentModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.
            UIViewContentModeRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
            UIViewContentModeCenter,              // contents remain same size. positioned adjusted.
            UIViewContentModeTop,
            UIViewContentModeBottom,
            UIViewContentModeLeft,
            UIViewContentModeRight,
            UIViewContentModeTopLeft,
            UIViewContentModeTopRight,
            UIViewContentModeBottomLeft,
            UIViewContentModeBottomRight);
}


@end