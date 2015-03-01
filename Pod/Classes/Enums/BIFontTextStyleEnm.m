#import "BIFontTextStyleEnm.h"
#import "UIFontTextStyle.h"

@implementation BIFontTextStyleEnm
+ (void)load {
    [super load];
    BIRegisterSelfAsEnum(UIFontTextStyle);
}

- (void)defineEnum {
    BIStringEnumDefine(UIFontTextStyle,
            UIFontTextStyleBody,
            UIFontTextStyleHeadline,
            UIFontTextStyleSubheadline,
            UIFontTextStyleFootnote,
            UIFontTextStyleCaption1,
            UIFontTextStyleCaption2);
}


@end