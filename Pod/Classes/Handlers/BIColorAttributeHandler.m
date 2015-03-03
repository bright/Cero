#import "BIAttributeHandler.h"
#import "BIColorAttributeHandler.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"
#import "BIInflatedViewContainer.h"


@implementation BIColorAttributeHandler

- (BOOL)canHandle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [attribute hasSuffix:@"Color"]
            && [builder.current respondsToSelector:[self parseSetColorSelector:attribute]];
}

- (SEL)parseSetColorSelector:(NSString *)attribute {
    NSString *name = [NSString stringWithFormat:@"set%@%@:", [attribute substringToIndex:1].uppercaseString, [attribute substringFromIndex:1]];
    return NSSelectorFromString(name);
}

- (void)handle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    UIColor *color = [self parseColorValue:element.attributes[attribute]];
    SEL currentViewSelector = [self parseSetColorSelector:attribute];
    [builder addBuildStep:^(BIInflatedViewContainer *container) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [container.current performSelector:currentViewSelector withObject:color];
#pragma clang diagnostic pop
    }];
}

- (UIColor *)parseColorValue:(NSString *)color {
    if ([color hasPrefix:@"#"]) {
        return [self colorFromHexString:color];
    }
    SEL uiColorSelector = NSSelectorFromString(color);
    if ([UIColor respondsToSelector:uiColorSelector]) {
        return [UIColor performSelector:uiColorSelector];
    }
    return nil;
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
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