#import "BILayoutConfiguration.h"
#import "BILayoutLoader.h"
#import "BISimpleViewHandler.h"
#import "BIButtonHandler.h"
#import "BITitleForStateHandler.h"
#import "BISimpleAttributeHandler.h"
#import "BIColorAttributeHandler.h"
#import "BIHandlersConfigurationCache.h"
#import "BIIdAttributeHandler.h"
#import "BIConstraintHandler.h"
#import "BIImageAttributeHandler.h"
#import "BIBuildersCache.h"


@implementation BILayoutConfiguration {
    NSMutableArray *_sharedAttributeHandlers;
    NSMutableArray *_sharedElementHandlers;
}
static BILayoutConfiguration *DefaultConfiguration;

- (instancetype)init {
    self = [super init];
    if (self) {
        _sharedAttributeHandlers = [NSMutableArray new];
        _sharedElementHandlers = [NSMutableArray new];
        self.buildersCache = BIBuildersCache.new;
    }

    return self;
}

- (void)setRootProjectPathFrom:(const char *)filePathFrom__FILE__ {
    NSString *path = [NSString stringWithUTF8String:filePathFrom__FILE__];
    self.rootProjectPath = [path stringByDeletingLastPathComponent];
}

+ (instancetype)defaultConfiguration {
    @synchronized (self) {
        if (DefaultConfiguration == nil) {
            DefaultConfiguration = [self new];
        }
    }
    return DefaultConfiguration;
}

- (void)setup {
    BILayoutLoader.rootProjectPath = self.rootProjectPath;
    [self registerAttributeHandler:[BIImageAttributeHandler new]];
    [self registerAttributeHandler:[BIColorAttributeHandler new]];
    [self registerAttributeHandler:[BIIdAttributeHandler new]];
    [self registerAttributeHandler:[BISimpleAttributeHandler new]];
    [self registerElementHandler:[BITitleForStateHandler new]];
    [self registerElementHandler:[BIButtonHandler new]];
    [self registerElementHandler:[BIConstraintHandler new]];
    [self registerElementHandler:[BISimpleViewHandler new]];
}

- (void)registerElementHandler:(id <BIBuilderHandler>)handler {
    [_sharedElementHandlers addObject:handler];
}

- (void)registerAttributeHandler:(id <BIAttributeHandler>)handler {
    [_sharedAttributeHandlers addObject:handler];
}

- (id <BIHandlersConfiguration>)handlersCache {
    BIHandlersConfigurationCache *object = [BIHandlersConfigurationCache new];
    object.attributeHandlers = _sharedAttributeHandlers.copy;
    object.elementHandlers = _sharedElementHandlers.copy;
    object.buildersCache = self.buildersCache;
    return object;
}
@end