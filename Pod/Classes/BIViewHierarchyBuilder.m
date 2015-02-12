#import "BIViewHierarchyBuilder.h"
#import "BIParserDelegate.h"
#import "BIEXTScope.h"
#import "BILayoutElement.h"

#import "BIBuilderHandler.h"
#import "BIAttributeHandler.h"
#import "BIInflatedViewContainer.h"
#import "BIHandlersConfiguration.h"


@interface BIViewHierarchyBuilder ()
- (void)onEnterNode:(id)node;

- (void)onLeaveNode:(id)node;

- (void)onReady;

@property(nonatomic, copy) OnBuilderReady onReadyQueue;

@end

@implementation BIViewHierarchyBuilder {
    BIParserDelegate *_delegate;
    BIInflatedViewContainer *_container;
    id <BIHandlersConfiguration> _configuration;
    NSMutableArray *_builderSteps;
}

+ (instancetype)builder:(id <BIHandlersConfiguration>)configuration parser:(BIParserDelegate *)delegate {
    return [[self alloc] initWithParserConfiguration:configuration parser:delegate];
}

- (instancetype)initWithParserConfiguration:(id <BIHandlersConfiguration>)configuration parser:(BIParserDelegate *)delegate {
    self = [super init];
    if (self) {
        _builderSteps = NSMutableArray.new;
        self.onReadyQueue = ^(BIInflatedViewContainer *_) {
        };
        _delegate = delegate;
        _configuration = configuration;
        @weakify(self);
        _delegate.onEnterNode = ^(BILayoutElement *node) {
            @strongify(self);
            [self onEnterNode:node];
        };
        _delegate.onLeaveNode = ^(BILayoutElement *node) {
            @strongify(self);
            [self onLeaveNode:node];
        };
        _delegate.onParsingCompleted = ^() {
            @strongify(self);
            [self onReady];
        };
    }
    return self;
}

- (void)onReady {
    self.onReadyQueue(self.container);
}

- (void)onEnterNode:(BILayoutElement *)node {
    id <BIBuilderHandler> elementHandler = nil;
    for (elementHandler in [self elementHandlers]) {
        if ([elementHandler canHandle:node inBuilder:self]) {
            [elementHandler handleEnter:node inBuilder:self];
            break;
        }
    }
    if (!node.handledAllAttributes) {
        for (NSString *attribute in node.attributes) {
            for (id <BIAttributeHandler> attributeHandler in [self attributeHandlers]) {
                if ([attributeHandler canHandle:attribute ofElement:node inBuilder:self]) {
                    [attributeHandler handle:attribute ofElement:node inBuilder:self];
                    break;
                }
            }
        }
    }
}


- (void)onLeaveNode:(BILayoutElement *)node {
    for (id <BIBuilderHandler> handler in [self elementHandlers]) {
        if ([handler canHandle:node inBuilder:self]) {
            [handler handleLeave:node inBuilder:self];
            break;
        }
    }
}

- (UIView *)root {
    return _container.root;
}

- (UIView *)current {
    return _container.current;
}

- (NSArray *)elementHandlers {
    return _configuration.elementHandlers;
}


- (NSArray *)attributeHandlers {
    return _configuration.attributeHandlers;
}


- (void)pushOnReady:(OnBuilderReady)onReady {
    if (onReady != nil) {
        OnBuilderReady previous = self.onReadyQueue;
        self.onReadyQueue = ^(BIInflatedViewContainer *container) {
            previous(container);
            onReady(container);
        };
    }
}

- (void)addBuildStep:(BuilderStep)step {
    step(self.container);
    [_builderSteps addObject:step];
}

- (void)startWithSuperView:(UIView *)view {
    _container = [BIInflatedViewContainer container:view];
    _container.current = view;
}
@end
