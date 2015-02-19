#import "BILayoutElementTreeNode.h"
#import "BILayoutElement.h"

@interface BILayoutElementTreeNode ()
@property(nonatomic, strong) NSMutableArray *children;
@end

@implementation BILayoutElementTreeNode
+ (instancetype)node:(BILayoutElement *)element {
    return [[self alloc] initWithElement:element];
}

- (instancetype)initWithElement:(BILayoutElement *)element {
    self = [super init];
    if (self) {
        _element = element;
        _children = NSMutableArray.new;
    }
    return self;
}

- (void)addChild:(BILayoutElementTreeNode *)node {
    [_children addObject:node];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Woverriding-method-mismatch"

- (id <NSFastEnumeration>)children {
    return _children;
}

#pragma clang diagnostic pop
@end