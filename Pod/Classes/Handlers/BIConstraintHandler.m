#import "BIConstraintHandler.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"
#import "BISourceReference.h"
#import "BIInflatedViewContainer.h"
#import "BIConstraintBuilder.h"

@implementation BIConstraintHandler {
}
- (BOOL)canHandle:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [element.name isEqualToString:@"Constraint"];
}

- (void)handleEnter:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    BISourceReference *reference = [builder.sourceReference subReferenceFromLine:element.startLineNumber andColumn:element.startColumnNumber];
    if (builder.current == nil) {
        NSLog(@"WARN: Constraint not under view %@", reference);
        return;
    }
    NSMutableDictionary *attributes = element.attributes;
    NSString *on = attributes[@"on"];

    BIIConstraintBuilder *constraintBuilder = [BIIConstraintBuilder builderFor:builder.current];
    [constraintBuilder constraintOn:on];
    [constraintBuilder withRelation:attributes[@"relation"]];

    [constraintBuilder withOtherItem:attributes[@"with"]];
    [constraintBuilder withMultiplier:attributes[@"multiplier"]];
    [constraintBuilder withConstant:attributes[@"constant"]];
    [constraintBuilder withSourceReference:reference];

    NSError *validationError;
    if ([constraintBuilder validForCompletion:&validationError]) {
        [builder registerOnReady:^(BIInflatedViewContainer *container) {
            NSError *installError;
            if (![constraintBuilder tryInstall:container error:&installError]) {
                NSLog(@"Failed to isntall constraint: %@", installError);
            }
        }];
    } else {
        NSLog(@"ERROR Constraint cannot be build: %@", validationError);
    }

    element.attributes = NSMutableDictionary.new;
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
}

@end

