typedef void (^OnContentChange)(NSString *path, NSData *content);

@protocol BIContentChangeObservable <NSObject>
@property(nonatomic, copy) OnContentChange onContentChange;
@end