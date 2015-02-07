@class BIInflatedViewContainer;
@class BISourceReference;

typedef UIView *(^ViewFinder)(BIInflatedViewContainer *container);

@interface BIIConstraintBuilder : NSObject

+ (instancetype)builderFor:(UIView *)view;

- (instancetype)initWithView:(UIView *)view;

- (void)constraintOn:(NSString *)on;

- (void)withRelation:(NSString *)relation;

- (void)withOtherItem:(NSString *)otherItemSpec;

- (void)withMultiplier:(NSString *)multiplier;

- (void)withConstant:(NSString *)constant;

- (void)withSourceReference:(BISourceReference *)reference;

- (BOOL)validForCompletion:(NSError **)pError;

- (BOOL)tryInstall:(BIInflatedViewContainer *)container error:(NSError **)error;
@end
