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
    NSMutableDictionary *attributes = element.attributes;
    NSString *on = attributes[@"on"];

    //we can't reference current item directly here, instead we'll wait until the step is executed
    //todo those register when ready blocks are flaky - we should use priorities on build steps instead
    __block UIView *firstItem;
    [builder addBuildStep:^(BIInflatedViewContainer *container) {
        firstItem = container.current;
    }];
    BIIConstraintBuilder *constraintBuilder = [BIIConstraintBuilder builderFor:^(BIInflatedViewContainer *container) {
        return firstItem;
    }];
    [constraintBuilder constraintOn:on];
    [constraintBuilder withRelation:attributes[@"relation"]];

    [constraintBuilder withOtherItem:attributes[@"with"]];
    [constraintBuilder withMultiplier:attributes[@"multiplier"]];
    [constraintBuilder withConstant:attributes[@"constant"]];
    [constraintBuilder withPriority:attributes[@"priority"]];
    [constraintBuilder withSourceReference:reference];

    NSError *validationError;
    if ([constraintBuilder validForCompletion:&validationError]) {
        [self registerInstallWhenBuilderReady:builder attributes:attributes constraintBuilder:constraintBuilder];
    } else {
        BILog(@"ERROR Constraint cannot be build: %@", validationError);
    }
    element.handledAllAttributes = YES;
}

- (void)registerInstallWhenBuilderReady:(BIViewHierarchyBuilder *)builder attributes:(NSMutableDictionary *)attributes constraintBuilder:(BIIConstraintBuilder *)constraintBuilder {
    [builder addOnReadyStep:^(BIInflatedViewContainer *container) {
        NSError *installError;
        NSArray *constraints = [constraintBuilder tryInstall:container error:&installError];
        if (installError == nil && constraints.count > 0) {
            NSString *idAttributeValue = attributes[@"id"];
            if (idAttributeValue.length > 0) {
                NSError *error;
                if (constraints.count == 1) {
                    [container tryAddingElement:constraints[0]
                                         withId:idAttributeValue
                                     fromSource:constraintBuilder.sourceReference
                                          error:&error];
                } else {
                    [container tryAddingElement:constraints
                                         withId:idAttributeValue
                                     fromSource:constraintBuilder.sourceReference
                                          error:&error];
                }
            }
        } else {
            BILog(@"Failed to isntall constraint: %@", installError);
        }
    }];
}

- (void)handleLeave:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
}

@end

