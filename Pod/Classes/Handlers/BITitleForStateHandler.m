#import "BIBuilderHandler.h"
#import "BITitleForStateHandler.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"
#import "BIInflatedViewContainer.h"
#import "BIEnumsRegistry.h"
#import "BIEnum.h"
#import "BIColorParser.h"


@implementation BITitleForStateHandler

- (BOOL)canHandle:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [element.name isEqualToString:@"title"]
            && [builder.current respondsToSelector:@selector(setTitle:forState:)];
}

- (void)handleEnter:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {

    NSString *stateValue = element.attributes[@"forState"];
    BIEnum *anEnum = BIEnumFor(UIControlState);
    NSNumber *state = [anEnum numberValueFor:stateValue orDefault:@(UIControlStateNormal)];
    UIControlState controlState = (UIControlState) state.unsignedIntegerValue;

    NSString *title = NSLocalizedString(element.attributes[@"title"], nil);
    if (title.length > 0) {
        [builder addBuildStep:^(BIInflatedViewContainer *container) {
            UIButton *button = (UIButton *) container.current;
            [button setTitle:title forState:controlState];
        }];
    }

    UIColor *titleColor = [self parseColorAttribute:@"titleColor" element:element];
    if (titleColor != nil) {
        [builder addBuildStep:^(BIInflatedViewContainer *container) {
            UIButton *button = (UIButton *) container.current;
            [button setTitleColor:titleColor forState:controlState];
        }];
    }

    UIColor *titleShadowColor = [self parseColorAttribute:@"titleShadowColor" element:element];
    if (titleShadowColor != nil) {
        [builder addBuildStep:^(BIInflatedViewContainer *container) {
            UIButton *button = (UIButton *) container.current;
            [button setTitleShadowColor:titleShadowColor forState:controlState];
        }];
    }

    element.handledAllAttributes = YES;
}

- (UIColor *)parseColorAttribute:(NSString *)colorAttribute element:(BILayoutElement *)element {
    UIColor *color;
    NSString *colorString = element.attributes[colorAttribute];
    if (colorString.length > 0) {
        color = [BIColorParser parse:colorString];

    }
    return color;
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
}

@end