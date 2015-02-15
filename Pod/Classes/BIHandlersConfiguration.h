@class BIBuildersCache;

@protocol BIHandlersConfiguration <NSObject>
- (BIBuildersCache *)buildersCache;

-(NSArray *)elementHandlers;
-(NSArray *)attributeHandlers;
@end