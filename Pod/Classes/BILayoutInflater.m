#import <Cero/BILayoutConfiguration.h>
#import <Cero/BILayoutLoader.h>
#import "BILayoutInflater.h"
#import "BIParserDelegate.h"
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

- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath superview:(UIView *)superview {
    NSAssert(filePath.length > 0, @"File path to inflate must not be empty");
    BIViewHierarchyBuilder *builder = [self.buildersCache cachedBuilderFor:filePath onNew:^(NSData *content) {
        return [self inflateFilePath:filePath superview:superview content:content];
    }                                                             onCached:^(BIViewHierarchyBuilder *cachedBuilder) {
        [cachedBuilder startWithSuperView:superview];
        [cachedBuilder runBuildSteps];
        return cachedBuilder;
    }];
    return builder.container;
}

- (BIViewHierarchyBuilder *)inflateFilePath:(NSString *)filePath superview:(UIView *)superview content:(NSData *)content {
    BIParserDelegate *parserDelegate = [BIParserDelegate new];
    BIViewHierarchyBuilder *newBuilder = [BIViewHierarchyBuilder builder:_handlersCache];
    newBuilder.rootInBundlePath = filePath;
    newBuilder.layoutInflater = self;
    parserDelegate.onEnterNode = ^(BILayoutElement *element) {
        [newBuilder onEnterNode:element];
    };
    parserDelegate.onLeaveNode = ^(BILayoutElement *element) {
        [newBuilder onLeaveNode:element];
    };
    parserDelegate.onParsingCompleted = ^{
        [newBuilder onReady];
    };
    [newBuilder startWithSuperView:superview];
    NSString *contentAsString = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
    newBuilder.sourceReference = [BISourceReference reference:filePath andContent:contentAsString];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:content];
    parser.delegate = parserDelegate;
    [parser parse];
    if (parser.parserError != nil) {
        NSLog(@"Error: %@", parser.parserError);
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