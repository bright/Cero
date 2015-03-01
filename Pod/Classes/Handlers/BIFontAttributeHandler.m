#import "BIFontAttributeHandler.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"
#import "BIInflatedViewContainer.h"
#import "BILog.h"

@implementation BIFontAttributeHandler {
    NSRegularExpression *_fontNameMatch;
    NSCharacterSet *_parenthesis;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _fontNameMatch = [NSRegularExpression regularExpressionWithPattern:@"([^(]+)(\\([0-9]*\\.?[0-9]*\\))?"
                                                                   options:NSRegularExpressionCaseInsensitive
                                                                     error:nil];
        _parenthesis = [NSCharacterSet characterSetWithCharactersInString:@"()"];
    }

    return self;
}


- (BOOL)canHandle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [@"font" isEqualToString:attribute] && [builder.current respondsToSelector:@selector(setFont:)];
#pragma clang diagnostic pop
}

- (void)handle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    NSString *fontName = element.attributes[attribute];
    NSTextCheckingResult *result = [_fontNameMatch firstMatchInString:fontName options:0 range:NSMakeRange(0, fontName.length)];
    if (result.numberOfRanges > 1) {
        NSString *fontNameOnly = [fontName substringWithRange:[result rangeAtIndex:1]];
        CGFloat fontSize = 17;
        if (result.numberOfRanges > 2) {
            NSRange fontSizeRange = [result rangeAtIndex:2];
            if (fontSizeRange.location != NSNotFound) {
                NSString *fontSizeString = [fontName substringWithRange:fontSizeRange];
                fontSizeString = [fontSizeString stringByTrimmingCharactersInSet:_parenthesis];
                if (fontSizeString.length > 0) {
                    fontSize = fontSizeString.floatValue;
                }
            }
        }
        UIFont *font = [UIFont fontWithName:fontNameOnly size:fontSize];
        [builder addBuildStep:^(BIInflatedViewContainer *container) {
            id view = container.current;
            [view setFont:font];
        }];
    } else {
        BILogError(@"ERROR: Font not found with name %@", fontName);
    }
}

@end