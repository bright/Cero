@class UIView;
@class BIViewHierarchyBuilder;
@class BIParserDelegate;
@protocol BIBuilderHandler;
@class BIInflatedViewContainer;


@interface BIViewHierarchyBuilder : NSObject
@property(nonatomic, readonly) UIView *root;
@property(nonatomic, readonly) BIInflatedViewContainer *container;
@property(nonatomic, readonly) UIView *current;

- (void)setCurrentAsSubview:(UIView *)view;

+ (BIViewHierarchyBuilder *)builderWithParser:(BIParserDelegate *)delegate;

- (void)setSuperviewAsCurrent;

+ (void)registerElementHandler:(id <BIBuilderHandler>)handler;

+ (void)registerDefaultHandlers;
@end