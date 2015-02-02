@class BILayoutElement;


@interface BIParserDelegate : NSObject <NSXMLParserDelegate>
@property(nonatomic, copy) void (^onEnterNode)(BILayoutElement *);
@property(nonatomic, copy) void (^onLeaveNode)(BILayoutElement *);
@end