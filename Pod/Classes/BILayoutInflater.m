#import <Cero/BILayoutConfiguration.h>
#import "BILayoutInflater.h"
#import "BIParserDelegate.h"
#import "BIViewHierarchyBuilder.h"
#import "BIInflatedViewContainer.h"
#import "BISourceReference.h"
#import "BIBuildersCache.h"
#import "BIHandlersConfiguration.h"


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

- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath withContent:(NSData *)content {
    return [self inflateFilePath:filePath withContent:content inSuperview:nil];
}

- (NSObject <BIInflatedViewHelper> *)inflateFilePath:(NSString *)filePath withContentString:(NSString *)content {
    return [self inflateFilePath:filePath withContent:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath withContent:(NSData *)content inSuperview:(UIView *)superview {
    BIParserDelegate *parserDelegate = [BIParserDelegate new];
    id <BIHandlersConfiguration> cache = _handlersCache;
    BIViewHierarchyBuilder *builder = [self.buildersCache cachedBuilderFor:filePath onNew:^{
        BIViewHierarchyBuilder *newBuilder = [BIViewHierarchyBuilder builder:cache];
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
    }                                                             onCached:^(BIViewHierarchyBuilder *cachedBuilder) {
        [cachedBuilder startWithSuperView:superview];
        [cachedBuilder runBuildSteps];
        return cachedBuilder;
    }];
    return builder.container;
}

- (BIBuildersCache *)buildersCache {
    return _handlersCache.buildersCache;
}

@end