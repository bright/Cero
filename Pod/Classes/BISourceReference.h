@interface BISourceReference : NSObject
@property(nonatomic, copy) NSString *sourcePath;

+ (instancetype)reference:(NSString *)path andContent:(NSString *)data;

- (BISourceReference *)subReferenceFromLine:(NSUInteger)lineNumber andColumn:(NSUInteger)columnNumber;

- (NSString *)sourceDescription;
@end