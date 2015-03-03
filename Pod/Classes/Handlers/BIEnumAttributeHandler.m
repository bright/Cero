#import "BISourceReference.h"
#import "BIEnum.h"
#import "BIInflatedViewContainer.h"
#import "BILayoutElement.h"
#import "BIViewContentModeHandler.h"
#import "BIViewHierarchyBuilder.h"

#define NSInvocationObjectIndex(index) index + 2

@implementation BIEnumAttributeHandler

- (BOOL)canHandle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [self.attributeName isEqualToString:attribute] && [builder.current respondsToSelector:self.setter];
}

- (void)handle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    NSString *contentModeString = element.attributes[self.attributeName];
    NSNumber *contentModeNumber = [self.valuesEnum numberValueFor:contentModeString orDefault:nil];
    if (contentModeNumber != nil) {
        NSMethodSignature *methodSignature = [builder.current methodSignatureForSelector:self.setter];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        invocation.selector = self.setter;
        [builder addBuildStep:^(BIInflatedViewContainer *container) {
            UIView *target = container.current;
            NSInteger elem = contentModeNumber.integerValue;
            [invocation setArgument:&elem atIndex:NSInvocationObjectIndex(0)];
            [invocation invokeWithTarget:target];
        }];
    } else {
        BISourceReference *reference = [builder.sourceReference subReferenceFromLine:element.startLineNumber andColumn:element.startColumnNumber];
        NSLog(@"ERROR: Failed to parse attribute '%@' value '%@' as enum of %@ (source %@)", attribute, contentModeString, self.valuesEnum.enumTypeName, reference.sourceDescription);
    }
}
@end