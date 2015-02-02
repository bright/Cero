@protocol BIHandlersConfiguration;
@interface BILayoutConfiguration : NSObject
@property(nonatomic, copy) NSString *rootProjectPath;

- (void)setRootProjectPathFrom:(const char *)filePathFrom__FILE__;

+ (instancetype)defaultConfiguration;

- (void)setup;

- (id <BIHandlersConfiguration>)handlersCache;
@end