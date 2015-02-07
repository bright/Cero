@class BIInflatedViewContainer;
@class BISourceReference;

typedef UIView *(^ViewFinder)(BIInflatedViewContainer *container);

@interface BIIConstraintBuilder : NSObject
@property(nonatomic, strong) UIView *firstItem;
@property(nonatomic, strong) NSArray *firstAttributes;

@property(nonatomic) enum NSLayoutRelation relation;

@property(nonatomic, copy) ViewFinder otherItemFinder;

@property(nonatomic, strong) NSArray *otherItemAttributes;

@property(nonatomic) CGFloat multiplier;

@property(nonatomic) CGFloat constant;

@property(nonatomic, strong) BISourceReference *sourceReference;

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
