#import "BIViewHierarchyBuilder.h"
#import "BIParserDelegate.h"
#import "BIEXTScope.h"
#import "BILayoutElement.h"

#import "BIBuilderHandler.h"
#import "BISimpleViewHandler.h"
#import "BIButtonHandler.h"
#import "BIAttributeHandler.h"
#import "BIColorAttributeHandler.h"
#import "BISimpleAttributeHandler.h"
#import "BITitleForStateHandler.h"


@interface BIViewHierarchyBuilder ()
- (void)onEnterNode:(id)node;

- (void)onLeaveNode:(id)node;

@property(nonatomic, strong) UIView *current;
@end

@implementation BIViewHierarchyBuilder {
    BIParserDelegate *_delegate;
    NSArray *_elementHandlers;
    NSArray *_attributeHandlers;
}
static NSMutableArray *_sharedElementHandlers;
static NSMutableArray *_sharedAttributeHandlers;

- (void)setCurrentAsSubview:(UIView *)view {
    UIView *parent = self.current;
    [parent addSubview:view];
    self.current = view;
}

+ (BIViewHierarchyBuilder *)builderWithParser:(BIParserDelegate *)delegate {
    return [[self alloc] initWithParser:delegate];
}

+ (void)registerDefaultHandlers {
    [self registerAttributeHandler:[BIColorAttributeHandler new]];
    [self registerAttributeHandler:[BISimpleAttributeHandler new]];
    [self registerElementHandler:[BITitleForStateHandler new]];
    [self registerElementHandler:[BIButtonHandler new]];
    [self registerElementHandler:[BISimpleViewHandler new]];
}

+ (void)registerElementHandler:(id <BIBuilderHandler>)handler {
    static dispatch_once_t initHandlers;
    dispatch_once(&initHandlers, ^{
        _sharedElementHandlers = [NSMutableArray new];
    });
    [_sharedElementHandlers addObject:handler];
}

+ (void)registerAttributeHandler:(id <BIAttributeHandler>)handler {
    static dispatch_once_t initHandlers;
    dispatch_once(&initHandlers, ^{
        _sharedAttributeHandlers = [NSMutableArray new];
    });
    [_sharedAttributeHandlers addObject:handler];
}


- (id)initWithParser:(BIParserDelegate *)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        @weakify(self);
        _delegate.onEnterNode = ^(BILayoutElement *node) {
            @strongify(self);
            [self onEnterNode:node];
        };
        _delegate.onLeaveNode = ^(BILayoutElement *node) {
            @strongify(self);
            [self onLeaveNode:node];
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

- (void)onEnterNode:(BILayoutElement *)node {
    id <BIBuilderHandler> elementHandler = nil;
    for (elementHandler in [self elementHandlers]) {
        if ([elementHandler canHandle:node inBuilder:self]) {
            [elementHandler handleEnter:node inBuilder:self];
            break;
        }
    }
    for (NSString *attribute in node.attributes) {
        for (id <BIAttributeHandler> attributeHandler in [self attributeHandlers]) {
            if ([attributeHandler canHandle:attribute ofElement:node inBuilder:self]) {
                [attributeHandler handle:attribute ofElement:node inBuilder:self];
                break;
            }
        }
    }
}

- (void)setCurrent:(UIView *)current {
    if (_view == nil) {
        _view = current;
    }
    _current = current;
}

- (NSArray *)elementHandlers {
    if (_elementHandlers == nil) {
        _elementHandlers = [NSArray arrayWithArray:_sharedElementHandlers];
    }
    return _elementHandlers;
}

- (NSArray *)attributeHandlers {
    if (_attributeHandlers == nil) {
        _attributeHandlers = [NSArray arrayWithArray:_sharedAttributeHandlers];
    }
    return _attributeHandlers;
}


- (void)setSuperviewAsCurrent {
    UIView *parent = self.current.superview;
    self.current = parent;
}
@end
