#import "BIConstraintHandler.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"
#import "BISourceReference.h"
#import "BIInflatedViewContainer.h"
#import "BIConstraintBuilder.h"
#import "BILog.h"

@implementation BIConstraintHandler {
}
- (BOOL)canHandle:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return [element.name isEqualToString:@"Constraint"];
}

- (void)handleEnter:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    BISourceReference *reference = [builder.sourceReference subReferenceFromLine:element.startLineNumber andColumn:element.startColumnNumber];
    if (builder.current == nil) {
        BILog(@"WARN: Constraint not under view %@", reference);
        return;
    }

    //we can't reference current item directly here, instead we'll wait until the step is executed
    //todo those register when ready blocks are flaky - we should use priorities on build steps instead
    BIIConstraintBuilder *constraintBuilder = [BIIConstraintBuilder builder];
    NSMutableDictionary *attributes = element.attributes;
    [constraintBuilder constraintOn:attributes[@"on"]];
    [constraintBuilder withRelation:attributes[@"relation"]];
    [constraintBuilder withOtherItem:attributes[@"with"]];
    [constraintBuilder withMultiplier:attributes[@"multiplier"]];
    [constraintBuilder withConstant:attributes[@"constant"]];
    [constraintBuilder withPriority:attributes[@"priority"]];
    [constraintBuilder withSourceReference:reference];

    NSError *validationError;
    if ([constraintBuilder validForCompletion:&validationError]) {
        [builder addBuildStep:^(BIInflatedViewContainer *currentContainer) {
            UIView *firstItem = currentContainer.current;
            BIIConstraintBuilder *constraintBuilderForItem = [constraintBuilder copy];
            constraintBuilderForItem.firstItemFinder = ^UIView *(id _, id _2) {
                return firstItem;
            };

            [currentContainer addOnReadyStep:^(BIInflatedViewContainer *container) {
                NSError *installError;
                NSArray *constraints = [constraintBuilderForItem tryInstall:container error:&installError];
                if (installError == nil && constraints.count > 0) {
                    NSString *idAttributeValue = attributes[@"id"];
                    if (idAttributeValue.length > 0) {
                        NSError *error;
                        if (constraints.count == 1) {
                            [container tryAddingElement:constraints[0]
                                                 withId:idAttributeValue
                                             fromSource:constraintBuilderForItem.sourceReference
                                                  error:&error];
                        } else {
                            [container tryAddingElement:constraints
                                                 withId:idAttributeValue
                                             fromSource:constraintBuilderForItem.sourceReference
                                                  error:&error];
                        }
                    }
                } else {
                    BILog(@"Failed to isntall constraint: %@", installError);
                }
            }];
        }];

    } else {
        BILog(@"ERROR Constraint cannot be build: %@", validationError);
    }
    element.handledAllAttributes = YES;
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
}

@end

