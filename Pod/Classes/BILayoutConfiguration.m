#import "BILayoutConfiguration.h"
#import "BIViewHierarchyBuilder.h"
#import "BILayoutInflaterWatcher.h"


@implementation BILayoutConfiguration

- (void)setRootProjectPathFrom:(const char *)filePathFrom__FILE__ {
    NSString *path = [NSString stringWithUTF8String:filePathFrom__FILE__];
    self.rootProjectPath = [path stringByDeletingLastPathComponent];
}

- (void)setup {
    BILayoutInflaterWatcher.rootProjectPath = self.rootProjectPath;
    [BIViewHierarchyBuilder registerDefaultHandlers];
}
@end