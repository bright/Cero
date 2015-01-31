@class UIView;
@class BIViewHierarchyBuilder;
@class BIParserDelegate;
@protocol BIBuilderHandler;


@interface BIViewHierarchyBuilder : NSObject
@property(nonatomic, readonly) UIView *view;
@property(nonatomic, readonly) UIView *current;

- (void)setCurrentAsSubview:(UIView *)view;

+ (BIViewHierarchyBuilder *)builderWithParser:(BIParserDelegate *)delegate;

- (void)setSuperviewAsCurrent;

+ (void)registerElementHandler:(id <BIBuilderHandler>)handler;

+ (void)registerDefaultHandlers;
@end