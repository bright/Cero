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

    NSString *title = element.attributes[@"title"];
    if (title.length > 0) {
        [builder addBuildStep:^(BIInflatedViewContainer *container) {
            UIButton *button = (UIButton *) container.current;
            [button setTitle:title forState:controlState];
        }];
    }


    NSString *colorString = element.attributes[@"titleColor"];
    if (colorString.length > 0) {
        UIColor *color = [BIColorParser parse:colorString];
        if (color != nil) {
            [builder addBuildStep:^(BIInflatedViewContainer *container) {
                UIButton *button = (UIButton *) container.current;
                [button setTitleColor:color forState:controlState];
            }];
        }
    }

    element.handledAllAttributes = YES;
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
}

@end