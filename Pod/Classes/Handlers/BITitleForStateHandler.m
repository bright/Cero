#import "BIBuilderHandler.h"
#import "BITitleForStateHandler.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"


@implementation BITitleForStateHandler {
}
- (BOOL)canHandle:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [element.name isEqualToString:@"titleForState"]
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
    UIButton *button = (UIButton *) builder.current;
    NSString *stateValue = element.attributes[@"state"];
    for(NSString *stateName in stateStringToStateEnum){
        if ([stateValue isEqualToString:stateName]) {
            NSNumber * state = stateStringToStateEnum[stateName];
            [button setTitle:element.attributes[@"value"] forState:(UIControlState) state.unsignedIntegerValue];
        }    
    }
    [element.attributes removeObjectsForKeys:@[@"value", @"state"]];
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
}

@end