#import <Cero/BIViewHierarchyBuilder.h>
#import <Cero/BIInflatedViewContainer.h>
#import "BILineBreakModeAttributeHandler.h"
#import "BILayoutElement.h"
#import "BIEnum.h"

@implementation BILineBreakModeAttributeHandler

- (BOOL)canHandle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [@"lineBreakMode" isEqualToString:attribute] && [builder.current respondsToSelector:@selector(setLineBreakMode:)];
#pragma clang diagnostic pop
}

- (void)handle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    BIEnum *lineBreakModeEnum = BIEnumFor(NSLineBreakMode);
    NSLineBreakMode value = (NSLineBreakMode) [lineBreakModeEnum valueFor:element.attributes[attribute]
                                                                orDefault:@(NSLineBreakByWordWrapping)].integerValue;
    [builder addBuildStep:^(BIInflatedViewContainer *container) {
        id view = container.current;
        [view setLineBreakMode:value];
    }];
}

@end