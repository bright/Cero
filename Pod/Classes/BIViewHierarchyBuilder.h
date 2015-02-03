@class UIView;
@class BIViewHierarchyBuilder;
@class BIParserDelegate;
@protocol BIBuilderHandler;
@class BIInflatedViewContainer;
@class BILayoutConfiguration;
@protocol BIHandlersConfiguration;
@class BISourceReference;
@class BILayoutElement;


@interface BIViewHierarchyBuilder : NSObject
@property(nonatomic, readonly) UIView *root;
@property(nonatomic, readonly) BIInflatedViewContainer *container;
@property(nonatomic, readonly) UIView *current;
@property(nonatomic, strong) BISourceReference *sourceReference;

- (void)setCurrentAsSubview:(UIView *)view;

- (void)setSuperviewAsCurrent;

+ (BIViewHierarchyBuilder *)builder:(id<BIHandlersConfiguration>)configuration parser:(BIParserDelegate *)parser;

@end