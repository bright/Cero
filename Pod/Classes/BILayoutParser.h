@class BILayoutElement;


@interface BILayoutParser : NSObject
@property(nonatomic, copy) void (^onEnterNode)(BILayoutElement *);
@property(nonatomic, copy) void (^onLeaveNode)(BILayoutElement *);

+ (BILayoutParser *)parserFor:(NSData *)data;

- (instancetype)initWithData:(NSData *)data;

- (BOOL)parse;

- (void)traverseElements;

- (NSError *)error;
@end