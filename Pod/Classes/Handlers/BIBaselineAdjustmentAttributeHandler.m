#import <Cero/BIViewHierarchyBuilder.h>
#import <Cero/BIInflatedViewContainer.h>
#import "BIBaselineAdjustmentAttributeHandler.h"
#import "BILayoutElement.h"
#import "BIEnum.h"

@implementation BIBaselineAdjustmentAttributeHandler

- (BOOL)canHandle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [@"baselineAdjustment" isEqualToString:attribute] && [builder.current respondsToSelector:@selector(setBaselineAdjustment:)];
}

- (void)handle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    BIEnum *baselineEnum = BIEnumFor(UIBaselineAdjustment);
    NSString *baseLineAsString = element.attributes[attribute];
    NSNumber *baseLineNumber = [baselineEnum valueFor:baseLineAsString orDefault:nil];
    if (baseLineNumber != nil) {
        UIBaselineAdjustment adjustment = (UIBaselineAdjustment) baseLineNumber.integerValue;
        [builder addBuildStep:^(BIInflatedViewContainer *container) {
            id view = container.current;
            [view setBaselineAdjustment:adjustment];
        }];
    } else {
        NSLog(@"ERROR: Could not parse baselineAdjustment '%@'", baseLineAsString);
    }
}

@end