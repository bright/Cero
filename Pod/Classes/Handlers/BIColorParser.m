#import "BIColorParser.h"

@implementation BIColorParser
+ (UIColor *)parse:(NSString *)colorAsString {
    return [self parseColorValue:colorAsString];
}

+ (UIColor *)parseColorValue:(NSString *)color {
    if ([color hasPrefix:@"#"]) {
        return [self colorFromHexString:color];
    }
    SEL uiColorSelector = NSSelectorFromString(color);
    if ([UIColor respondsToSelector:uiColorSelector]) {
        return [UIColor performSelector:uiColorSelector];
    }
    return nil;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned int rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0F
                           green:((rgbValue & 0xFF00) >> 8) / 255.0F
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:1.0];
}


@end