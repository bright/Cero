#import "BIBuilderHandler.h"
#import "BITitleForStateHandler.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"
#import "BIInflatedViewContainer.h"


@implementation BITitleForStateHandler {
}
- (BOOL)canHandle:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [element.name isEqualToString:@"title"]
            && [builder.current respondsToSelector:@selector(setTitle:forState:)];
}

- (void)handleEnter:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    NSDictionary *stateStringToStateEnum = @{
            @"UIControlStateNormal" : @(UIControlStateNormal),
            @"UIControlStateSelected" : @(UIControlStateSelected),
            @"UIControlStateHighlighted" : @(UIControlStateHighlighted),
            @"UIControlStateDisabled" : @(UIControlStateDisabled),
            @"UIControlStateApplication" : @(UIControlStateApplication),
    };

    NSString *stateValue = element.attributes[@"forState"];
    if (stateValue.length == 0) {
        stateValue = @"UIControlStateNormal";
    }
    NSString *title = element.attributes[@"value"];
    for(NSString *stateName in stateStringToStateEnum){
        if ([stateValue isEqualToString:stateName]) {
            NSNumber * state = stateStringToStateEnum[stateName];
            [builder addBuildStep:^(BIInflatedViewContainer *container) {
                UIButton *button = (UIButton *) container.current;
                [button setTitle:title forState:(UIControlState) state.unsignedIntegerValue];
            }];
        }
    }
    [element.attributes removeObjectsForKeys:@[@"value", @"state"]];
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
}

@end