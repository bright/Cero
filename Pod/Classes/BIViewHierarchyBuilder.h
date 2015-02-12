@class UIView;
@class BIViewHierarchyBuilder;
@class BIParserDelegate;
@protocol BIBuilderHandler;
@class BIInflatedViewContainer;
@class BILayoutConfiguration;
@protocol BIHandlersConfiguration;
@class BISourceReference;
@class BILayoutElement;

typedef void(^OnBuilderReady)(BIInflatedViewContainer *container);

typedef void(^BuilderStep)(BIInflatedViewContainer *container);

@interface BIViewHierarchyBuilder : NSObject
@property(nonatomic, readonly) UIView *root;
@property(nonatomic, readonly) BIInflatedViewContainer *container;
@property(nonatomic, strong) BISourceReference *sourceReference;


+ (BIViewHierarchyBuilder *)builder:(id <BIHandlersConfiguration>)configuration parser:(BIParserDelegate *)parser;

- (UIView *)current;

- (void)pushOnReady:(OnBuilderReady)onReady;

- (void)addBuildStep:(BuilderStep)step;

- (void)startWithSuperView:(UIView *)view;
@end