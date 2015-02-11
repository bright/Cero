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
    [constraintBuilder withPriority:attributes[@"priority"]];
    [constraintBuilder withSourceReference:reference];

    NSError *validationError;
    if ([constraintBuilder validForCompletion:&validationError]) {
        [self registerForInstall:builder attributes:attributes constraintBuilder:constraintBuilder];
    } else {
        NSLog(@"ERROR Constraint cannot be build: %@", validationError);
    }
    element.handledAllAttributes = YES;
}

- (void)registerForInstall:(BIViewHierarchyBuilder *)builder attributes:(NSMutableDictionary *)attributes constraintBuilder:(BIIConstraintBuilder *)constraintBuilder {
    [builder registerOnReady:^(BIInflatedViewContainer *container) {
        NSError *installError;
        NSArray *constraints = [constraintBuilder tryInstall:container error:&installError];
        if (installError == nil && constraints.count > 0) {
            NSString *idAttributeValue = attributes[@"id"];
            if (idAttributeValue.length > 0) {
                NSError *error;
                if (constraints.count == 1) {
                    [builder.container tryAddingElement:constraints[0]
                                                 withId:idAttributeValue
                                             fromSource:constraintBuilder.sourceReference
                                                  error:&error];
                } else {
                    [builder.container tryAddingElement:constraints
                                                 withId:idAttributeValue
                                             fromSource:constraintBuilder.sourceReference
                                                  error:&error];
                }
            }
        } else {
            NSLog(@"Failed to isntall constraint: %@", installError);
        }
    }];
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
}

@end

