#import <Cero/BILayoutConfiguration.h>
#import <Cero/BILayoutLoader.h>
#import "BILayoutInflater.h"
#import "BILayoutParser.h"
#import "BIViewHierarchyBuilder.h"
#import "BIInflatedViewContainer.h"
#import "BISourceReference.h"
#import "BIBuildersCache.h"
#import "BIHandlersConfiguration.h"
#import "BILayoutElement.h"
#import "UIView+BIAttributes.h"


@implementation BILayoutInflater {
    id <BIHandlersConfiguration> _handlersCache;
}

+ (instancetype)defaultInflater {
    return [self inflaterWithConfiguration:BILayoutConfiguration.defaultConfiguration];
}

+ (instancetype)inflaterWithConfiguration:(BILayoutConfiguration *)configuration {
    return [[self alloc] initWithConfiguration:configuration];
}

- (instancetype)initWithConfiguration:(BILayoutConfiguration *)configuration {
    self = [super init];
    if (self) {
        _handlersCache = configuration.handlersCache;
    }
    return self;
}

- (BIInflatedViewContainer *)inflateFilePath:(NSString *)inBundlePath superview:(UIView *)superview {
    BIViewHierarchyBuilder *builder = [self inflateBuilder:inBundlePath superview:superview];
    [builder runOnReadyCallbacks];
    return builder.container;
}

- (BIViewHierarchyBuilder *)inflateBuilder:(NSString *)inBundlePath superview:(UIView *)superview {
    NSAssert(inBundlePath.length > 0, @"File path to inflate must not be empty");
    BIViewHierarchyBuilder *builder = [self.buildersCache cachedBuilderFor:inBundlePath
                                                                     onNew:^(NSData *content) {
                                                                         return [self inflateFilePath:inBundlePath superview:superview content:content];
                                                                     } onCached:^(BIViewHierarchyBuilder *cachedBuilder) {
                [cachedBuilder startWithSuperView:superview];
                [cachedBuilder runBuildSteps];
                return cachedBuilder;
            }];
    return builder;
}

- (BIViewHierarchyBuilder *)inflateFilePath:(NSString *)filePath superview:(UIView *)superview content:(NSData *)content {
    BIViewHierarchyBuilder *newBuilder;
    BILayoutParser *layoutParser = [BILayoutParser parserFor:content];
    if ([layoutParser parse]) {
        newBuilder = [BIViewHierarchyBuilder builder:_handlersCache];
        newBuilder.rootInBundlePath = filePath;
        newBuilder.layoutInflater = self;

        [newBuilder startWithSuperView:superview];
        NSString *contentAsString = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
        newBuilder.sourceReference = [BISourceReference reference:filePath andContent:contentAsString];

        layoutParser.onEnterNode = ^(BILayoutElement *element) {
            [newBuilder onEnterNode:element];
        };
        layoutParser.onLeaveNode = ^(BILayoutElement *element) {
            [newBuilder onLeaveNode:element];
        };
        [layoutParser traverseElements];
        return newBuilder;
    } else {
        NSLog(@"Failed to parse %@ with error: %@", filePath, layoutParser.error);
    }

    return newBuilder;
}

- (BIBuildersCache *)buildersCache {
    return _handlersCache.buildersCache;
}

- (NSString *)layoutPath:(NSString *)layoutName {
    return [NSBundle.mainBundle pathForResource:layoutName ofType:@"xml"];
}

- (BIInflatedViewContainer *)reloadSuperview:(UIView *)superview path:(NSString *)path notify:(OnViewInflated)notify {
    for (UIView *view in superview.subviews) {
        if (view.bi_isPartOfLayout) {
            [view removeFromSuperview];
        }
    }
    BIInflatedViewContainer *viewContainer = [self inflateFilePath:path superview:superview];
    if (notify != nil) {
        notify(viewContainer);
    }
    [viewContainer clearRootToAvoidMemoryLeaks];
    return viewContainer;
}
@end