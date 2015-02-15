@protocol BIHandlersConfiguration;
@class BIBuildersCache;

@interface BILayoutConfiguration : NSObject
@property(nonatomic, copy) NSString *rootProjectPath;

@property(nonatomic, strong) BIBuildersCache *buildersCache;

- (void)setRootProjectPathFrom:(const char *)filePathFrom__FILE__;

+ (instancetype)defaultConfiguration;

- (void)setup;

- (id <BIHandlersConfiguration>)handlersCache;
@end