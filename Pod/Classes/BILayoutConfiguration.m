#import "BILayoutConfiguration.h"
#import "BIViewHierarchyBuilder.h"
#import "BILayoutInflaterWatcher.h"
#import "BISimpleViewHandler.h"
#import "BIButtonHandler.h"
#import "BITitleForStateHandler.h"
#import "BISimpleAttributeHandler.h"
#import "BIColorAttributeHandler.h"
#import "BIHandlersConfigurationCache.h"
#import "BILayoutInflater.h"
#import "BIInflatedViewHelper.h"
#import "BIIdAttributeHandler.h"


@implementation BILayoutConfiguration {
    NSMutableArray *_sharedAttributeHandlers;
    NSMutableArray *_sharedElementHandlers;
}
static BILayoutConfiguration*DefaultConfiguration;
- (instancetype)init {
    self = [super init];
    if (self) {
        _sharedAttributeHandlers = [NSMutableArray new];
        _sharedElementHandlers = [NSMutableArray new];
    }

    return self;
}

- (void)setRootProjectPathFrom:(const char *)filePathFrom__FILE__ {
    NSString *path = [NSString stringWithUTF8String:filePathFrom__FILE__];
    self.rootProjectPath = [path stringByDeletingLastPathComponent];
}

+ (instancetype)defaultConfiguration {
    @synchronized (self) {
        if(DefaultConfiguration == nil){
            DefaultConfiguration = [self new];
        }
    }
    return DefaultConfiguration;
}

- (void)setup {
    BILayoutInflaterWatcher.rootProjectPath = self.rootProjectPath;
    [self registerAttributeHandler:[BIColorAttributeHandler new]];
    [self registerAttributeHandler:[BIIdAttributeHandler new]];
    [self registerAttributeHandler:[BISimpleAttributeHandler new]];
    [self registerElementHandler:[BITitleForStateHandler new]];
    [self registerElementHandler:[BIButtonHandler new]];
    [self registerElementHandler:[BISimpleViewHandler new]];
}

- (void)registerElementHandler:(id <BIBuilderHandler>)handler {
    [_sharedElementHandlers addObject:handler];
}

- (void)registerAttributeHandler:(id <BIAttributeHandler>)handler {
    [_sharedAttributeHandlers addObject:handler];
}

- (id <BIHandlersConfiguration>)handlersCache {
    BIHandlersConfigurationCache* object = [BIHandlersConfigurationCache new];
    object.attributeHandlers = _sharedAttributeHandlers.copy;
    object.elementHandlers = _sharedElementHandlers.copy;
    return object;
}
@end