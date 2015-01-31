@interface BILayoutConfiguration : NSObject
@property(nonatomic, copy) NSString *rootProjectPath;

- (void)setRootProjectPathFrom:(const char *)filePathFrom__FILE__;

- (void)setup;
@end