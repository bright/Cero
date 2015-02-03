@interface BILayoutElement : NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *namepsaceURI;
@property(nonatomic, strong) NSMutableDictionary *attributes;

@property(nonatomic) NSUInteger startLineNumber;

@property(nonatomic) NSUInteger startColumnNumber;
@end