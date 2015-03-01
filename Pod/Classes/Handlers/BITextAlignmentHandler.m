#import <Cero/BIViewHierarchyBuilder.h>
#import <Cero/BIInflatedViewContainer.h>
#import "BITextAlignmentHandler.h"
#import "BILayoutElement.h"
#import "BIEnum.h"

@implementation BITextAlignmentHandler

- (BOOL)canHandle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [@"textAlignment" isEqualToString:attribute] && [builder.current respondsToSelector:@selector(setTextAlignment:)];
}

- (void)handle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    BIEnum *alignmentEnum = BIEnumFor(NSTextAlignment);
    NSString *textAlignmentAsString = element.attributes[attribute];
    NSTextAlignment alignment = (NSTextAlignment) [alignmentEnum valueFor:textAlignmentAsString 
                                                                orDefault:@(NSTextAlignmentLeft)].integerValue;
    [builder addBuildStep:^(BIInflatedViewContainer *container) {
        id view = container.current;
        [view setTextAlignment:alignment];
    }];
}

@end