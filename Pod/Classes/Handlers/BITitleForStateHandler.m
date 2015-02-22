#import "BIBuilderHandler.h"
#import "BITitleForStateHandler.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"
#import "BIInflatedViewContainer.h"
#import "BIEnumsRegistry.h"
#import "BIEnum.h"


@implementation BITitleForStateHandler {
}
- (BOOL)canHandle:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [element.name isEqualToString:@"title"]
            && [builder.current respondsToSelector:@selector(setTitle:forState:)];
}

- (void)handleEnter:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {

    NSString *stateValue = element.attributes[@"forState"];
    NSString *title = element.attributes[@"value"];
    BIEnum *anEnum = BIEnumFor(UIControlState);
    NSNumber *state = [anEnum valueFor:stateValue orDefault:@(UIControlStateNormal)];
    UIControlState controlState = (UIControlState) state.unsignedIntegerValue;
    [builder addBuildStep:^(BIInflatedViewContainer *container) {
        UIButton *button = (UIButton *) container.current;
        [button setTitle:title forState:controlState];
    }];
    element.handledAllAttributes = YES;
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
}

@end