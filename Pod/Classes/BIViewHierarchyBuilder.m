#import "BIViewHierarchyBuilder.h"
#import "BILayoutElement.h"

#import "BIBuilderHandler.h"
#import "BIAttributeHandler.h"
#import "BIInflatedViewContainer.h"
#import "BIHandlersConfiguration.h"
#import "BIEXTScope.h"


@interface BIViewHierarchyBuilder ()
@property(nonatomic, readonly) OnBuilderReady onReadySteps;
@end

@implementation BIViewHierarchyBuilder {
    BIInflatedViewContainer *_container;
    id <BIHandlersConfiguration> _configuration;
    NSMutableArray *_builderSteps;
    NSMutableArray *_builderReadySteps;
    NSMutableArray *_invalidateHandlers;
}

+ (instancetype)builder:(id <BIHandlersConfiguration>)configuration {
    return [[self alloc] initWithParserConfiguration:configuration];
}

- (instancetype)initWithParserConfiguration:(id <BIHandlersConfiguration>)configuration {
    self = [super init];
    if (self) {
        _builderSteps = NSMutableArray.new;
        _builderReadySteps = NSMutableArray.new;
        _invalidateHandlers = NSMutableArray.new;
        _configuration = configuration;
        @weakify(self);
        _onReadySteps = ^(BIInflatedViewContainer *container) {
            @strongify(self);
            [self runOnReadySteps:container];
        };
    }
    return self;
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


- (BOOL)addOnReadyStep:(OnBuilderReady)onReady {
    if (onReady != nil && ![_builderReadySteps containsObject:onReady]) {
        [_builderReadySteps addObject:onReady];
        return YES;
    }
    return NO;
}

- (void)addBuildStep:(BuilderStep)step {
    BIInflatedViewContainer *container = self.container;
    if (step != nil) {
        step(container);
        [_builderSteps addObject:step];
    }
}

- (void)addInvalidateHandler:(OnBuilderInvalidate)builderInvalidate {
    [_invalidateHandlers addObject:builderInvalidate];
}

- (void)startWithSuperView:(UIView *)view {
    _container = [BIInflatedViewContainer container:view];
    _container.current = view;
}

- (void)runBuildSteps {
    BIInflatedViewContainer *container = self.container;
    NSLog(@"Will run %@ build steps", @(_builderSteps.count));
    for (BuilderStep step in _builderSteps) {
        step(container);
    }
}

- (void)runOnReadySteps {
    [self runOnReadySteps:self.container];
}

- (void)runOnReadySteps:(BIInflatedViewContainer *)container {
    for (OnBuilderReady onReady in _builderReadySteps) {
        if (onReady != nil) {
            onReady(container);
        }
    }
}

- (void)addOnReadyStepsFrom:(BIViewHierarchyBuilder *)builder {
    OnBuilderReady ready = builder.onReadySteps;
    if ([self addOnReadyStep:ready]) {
        @weakify(self, ready);
        [builder addInvalidateHandler:^{
            @strongify(self, ready);
            [self removeOnReadyStep:ready];
        }];
    }
}

- (void)removeOnReadyStep:(OnBuilderReady)pFunction {
    [_builderReadySteps removeObject:pFunction];
}

- (void)invalidate {
    for (OnBuilderInvalidate step in _invalidateHandlers) {
        if (step != nil) {
            step();
        }
    }
    _invalidateHandlers = nil;
}
@end
