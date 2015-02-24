#import <Cero/BIViewHierarchyBuilder.h>
#import "BIViewContentModeHandler.h"
#import "BILayoutElement.h"
#import "BIInflatedViewContainer.h"
#import "BIEnum.h"

@implementation BIViewContentModeHandler
- (BOOL)canHandle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [@"contentMode" isEqualToString:attribute] && [builder.container.current isKindOfClass:UIView.class];
}

- (void)handle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    BIEnum *contentModeEnum = BIEnumFor(UIViewContentMode);
    NSString *contentModeString = element.attributes[@"contentMode"];
    NSNumber *contentModeNumber = [contentModeEnum valueFor:contentModeString orDefault:@(UIViewContentModeScaleToFill)];
    UIViewContentMode contentMode = (UIViewContentMode) contentModeNumber.integerValue;
    [builder addBuildStep:^(BIInflatedViewContainer *container) {
        container.current.contentMode = contentMode;
    }];
}
@end