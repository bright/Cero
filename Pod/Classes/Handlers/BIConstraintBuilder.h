@class BIInflatedViewContainer;
@class BISourceReference;
@class BIIConstraintBuilder;

typedef UIView *(^ViewFinder)(BIInflatedViewContainer *container, BIIConstraintBuilder *builder);

@interface BIIConstraintBuilder : NSObject
@property(nonatomic, copy) ViewFinder firstItemFinder;

+ (instancetype)builder;

- (void)constraintOn:(NSString *)on;

- (void)withRelation:(NSString *)relation;

- (void)withOtherItem:(NSString *)otherItemSpec;

- (void)withMultiplier:(NSString *)multiplier;

- (void)withConstant:(NSString *)constant;

- (void)withSourceReference:(BISourceReference *)reference;

- (BOOL)validForCompletion:(NSError **)pError;

- (NSArray *)tryInstall:(BIInflatedViewContainer *)container error:(NSError **)error;

- (BISourceReference *)sourceReference;

- (void)withPriority:(NSString *)priority;

- (instancetype)copy;
@end
