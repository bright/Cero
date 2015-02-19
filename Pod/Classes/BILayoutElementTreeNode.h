@class BILayoutElement;

@interface BILayoutElementTreeNode : NSObject
@property(nonatomic, readonly) BILayoutElement *element;
@property(nonatomic, weak) BILayoutElementTreeNode *parent;

+ (instancetype)node:(BILayoutElement *)element;

- (void)addChild:(BILayoutElementTreeNode *)node;

- (id <NSFastEnumeration>)children;
@end