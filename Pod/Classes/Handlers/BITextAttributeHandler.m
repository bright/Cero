#import <Cero/BIViewHierarchyBuilder.h>
#import <Cero/BIInflatedViewContainer.h>
#import "BITextAttributeHandler.h"
#import "BILayoutElement.h"

@implementation BITextAttributeHandler

- (BOOL)canHandle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [@"text" isEqualToString:attribute] &&
            [builder.current respondsToSelector:@selector(setText:)];
}

- (void)handle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    NSString *key = element.attributes[attribute];
    if (key.length > 0) {
        NSString *localizedString = NSLocalizedString(key, nil);
        [builder addBuildStep:^(BIInflatedViewContainer *container) {
            id current = container.current;
            [current setText:localizedString];
        }];
    }
}

@end