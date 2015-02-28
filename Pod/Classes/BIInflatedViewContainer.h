#import "BIInflatedViewHelper.h"

@class BILayoutElement;
@class BISourceReference;
@class BIInflatedViewContainer;

typedef void(^OnBuilderReady)(BIInflatedViewContainer *container);

@interface BIInflatedViewContainer : NSObject <BIInflatedViewHelper>
@property(nonatomic, strong, readonly) UIView *root;

@property(nonatomic, strong) UIView *current;

+ (instancetype)container:(UIView *)root;

- (BOOL)addOnReadyStep:(OnBuilderReady)onReady;

- (void)addOnReadyStepsFrom:(BIInflatedViewContainer *)container;

- (void)runOnReadySteps;

- (void)setSuperviewAsCurrent;

- (void)setCurrentAsSubview:(UIView *)view;

- (void)clearRootToAvoidMemoryLeaks;

- (BOOL)tryAddingElement:(id)element withId:(NSString *)id fromSource:(BISourceReference *)source error:(NSError **)error;

- (BOOL)tryAddingElementsFrom:(BIInflatedViewContainer *)container error:(NSError **)error;
@end