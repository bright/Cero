#import <Cero/BIViewHierarchyBuilder.h>
#import "BIViewContentModeHandler.h"
#import "BILayoutElement.h"
#import "BIInflatedViewContainer.h"
#import "BIEnum.h"
#import "BISourceReference.h"

#define NSInvocationObjectIndex(index) index + 2

@implementation BIViewContentModeHandler
- (instancetype)init {
    self = [super init];
    if (self) {
        self.setter = @selector(setContentMode:);
        self.attributeName = @"contentMode";
        self.valuesEnum = BIEnumFor(UIViewContentMode);
    }

    return self;
}

- (BOOL)canHandle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [self.attributeName isEqualToString:attribute] && [builder.current respondsToSelector:self.setter];
}

- (void)handle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    NSString *contentModeString = element.attributes[self.attributeName];
    NSNumber *contentModeNumber = [self.valuesEnum valueFor:contentModeString orDefault:nil];
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