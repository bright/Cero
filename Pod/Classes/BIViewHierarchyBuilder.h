@class UIView;
@class BIViewHierarchyBuilder;
@class BIParserDelegate;
@protocol BIBuilderHandler;
@class BIInflatedViewContainer;
@class BILayoutConfiguration;
@protocol BIHandlersConfiguration;
@class BISourceReference;
@class BILayoutElement;
@class BILayoutLoader;
@class BILayoutInflater;

typedef void(^OnBuilderReady)(BIInflatedViewContainer *container);

typedef void(^BuilderStep)(BIInflatedViewContainer *container);

@interface BIViewHierarchyBuilder : NSObject
@property(nonatomic, readonly) UIView *root;
@property(nonatomic, readonly) BIInflatedViewContainer *container;
@property(nonatomic, strong) BISourceReference *sourceReference;


@property(nonatomic, copy) NSString *rootInBundlePath;

@property(nonatomic, weak) BILayoutInflater *layoutInflater;

+ (instancetype)builder:(id <BIHandlersConfiguration>)configuration;

- (void)onReady;

- (void)onEnterNode:(BILayoutElement *)node;

- (void)onLeaveNode:(BILayoutElement *)node;

- (UIView *)current;

- (void)pushOnReady:(OnBuilderReady)onReady;

- (void)addBuildStep:(BuilderStep)step;

- (void)startWithSuperView:(UIView *)view;

- (void)runBuildSteps;
@end