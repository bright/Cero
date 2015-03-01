#import <Cero/BIViewHierarchyBuilder.h>
#import "BIFontTextStyleAttributeHandler.h"
#import "BILayoutElement.h"
#import "BIEnum.h"
#import "UIFontTextStyle.h"
#import "BIInflatedViewContainer.h"

@implementation BIFontTextStyleAttributeHandler

- (BOOL)canHandle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [@"fontTextStyle" isEqualToString:attribute] && [builder.current respondsToSelector:@selector(setFont:)];
#pragma clang diagnostic pop
}

- (void)handle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    NSString *fontTextStyle = element.attributes[attribute];
    BIEnum *textStyleEnum = BIEnumFor(UIFontTextStyle);
    UIFontTextStyle style = [textStyleEnum stringValueFor:fontTextStyle orDefault:fontTextStyle];

    UIFont *styledFont = [UIFont preferredFontForTextStyle:style];
    if (styledFont != nil) {
        [builder addBuildStep:^(BIInflatedViewContainer *container) {
            id view = container.current;
            [view setFont:styledFont];
        }];
    } else {
        NSLog(@"ERROR: No preffered font found for %@", fontTextStyle);
    }
}

@end