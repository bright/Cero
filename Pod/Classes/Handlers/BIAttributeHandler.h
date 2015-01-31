@class BIViewHierarchyBuilder;
@class BILayoutElement;

@protocol BIAttributeHandler <NSObject>
- (BOOL)canHandle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder;

- (void)handle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder;
@end