#import "BIAttributeHandler.h"
#import "BIColorAttributeHandler.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"
#import "BIInflatedViewContainer.h"
#import "BIColorParser.h"


@implementation BIColorAttributeHandler

- (BOOL)canHandle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [attribute hasSuffix:@"Color"]
            && [builder.current respondsToSelector:[self parseSetColorSelector:attribute]];
}

- (SEL)parseSetColorSelector:(NSString *)attribute {
    NSString *name = [NSString stringWithFormat:@"set%@%@:", [attribute substringToIndex:1].uppercaseString, [attribute substringFromIndex:1]];
    return NSSelectorFromString(name);
}

- (void)handle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    UIColor *color = [BIColorParser parse:element.attributes[attribute]];
    SEL currentViewSelector = [self parseSetColorSelector:attribute];
    [builder addBuildStep:^(BIInflatedViewContainer *container) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [container.current performSelector:currentViewSelector withObject:color];
#pragma clang diagnostic pop
    }];
}


@end