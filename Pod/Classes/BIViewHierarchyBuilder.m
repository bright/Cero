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

@property(nonatomic, strong) UIView *current;
@end

@implementation BIViewHierarchyBuilder {
    BIParserDelegate *_delegate;
    BIInflatedViewContainer *_container;
    id <BIHandlersConfiguration> _configuration;
}
- (void)setCurrentAsSubview:(UIView *)view {
    UIView *parent = self.current;
    [parent addSubview:view];
    self.current = view;
}

+ (instancetype)builder:(id <BIHandlersConfiguration>)configuration parser:(BIParserDelegate *)delegate {
    return [[self alloc] initWithParserConfiguration:configuration parser:delegate];
}

- (instancetype)initWithParserConfiguration:(id <BIHandlersConfiguration>)configuration parser:(BIParserDelegate *)delegate {
    self = [super init];
    if (self) {
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

- (void)onLeaveNode:(BILayoutElement *)node {
    for (id <BIBuilderHandler> handler in [self elementHandlers]) {
        if ([handler canHandle:node inBuilder:self]) {
            [handler handleLeave:node inBuilder:self];
            break;
        }
    }
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

- (UIView *)root {
    return _container.root;
}

- (void)setCurrent:(UIView *)current {
    if (_container == nil && current != nil) {
        _container = [BIInflatedViewContainer container:current];
    }
    _current = current;
}

- (NSArray *)elementHandlers {
    return _configuration.elementHandlers;
}


- (NSArray *)attributeHandlers {
    return _configuration.attributeHandlers;
}

- (void)setSuperviewAsCurrent {
    UIView *parent = self.current.superview;
    self.current = parent;
}

- (void)registerOnReady:(OnBuilderReady)onReady {
    if (onReady != nil) {
        OnBuilderReady previous = self.onReadyQueue;
        self.onReadyQueue = ^(BIInflatedViewContainer *container) {
            previous(container);
            onReady(container);
        };
    }
}
@end
