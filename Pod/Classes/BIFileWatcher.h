@interface BIFileWatcher : NSObject
@property(nonatomic, copy) void (^onContentChange)(NSString *path, NSData *content);

+ (instancetype)fileWatcher:(NSString *)path;
@end