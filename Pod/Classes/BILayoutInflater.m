#import <Cero/BILayoutConfiguration.h>
#import "BILayoutInflater.h"
#import "BIParserDelegate.h"
#import "BIViewHierarchyBuilder.h"
#import "BIInflatedViewContainer.h"
#import "BIInflatedViewHelper.h"
#import "BISourceReference.h"


@implementation BILayoutInflater {

    BIParserDelegate *_parserDelegate;
    id <BIHandlersConfiguration> _handlersCache;
}

+ (instancetype)defaultInflater {
    return [self inflaterWithConfiguration:BILayoutConfiguration.defaultConfiguration];
}

+ (instancetype)inflaterWithConfiguration:(BILayoutConfiguration *)configuration {
    return [[self alloc]initWithConfiguration:configuration];
}

- (instancetype)initWithConfiguration:(BILayoutConfiguration *)configuration {
    self = [super init];
    if (self) {
        _parserDelegate = [BIParserDelegate new];
        _handlersCache = configuration.handlersCache;
        
    }
    return self;
}


- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath withContent:(NSData *)content {
    BIViewHierarchyBuilder*builder = [BIViewHierarchyBuilder builder:_handlersCache parser:_parserDelegate];
    NSString *contentAsString = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
    builder.sourceReference = [BISourceReference reference:filePath andContent:contentAsString];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:content];
    parser.delegate = _parserDelegate;
    [parser parse];
    return builder.container;
}

- (NSObject <BIInflatedViewHelper> *)inflateFilePath:(NSString *)filePath withContentString:(NSString *)content {
    return [self inflateFilePath:filePath withContent:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath {
    NSData *content = [NSData dataWithContentsOfFile:filePath];
    return [self inflateFilePath:filePath withContent:content];
}

+ (BIInflatedViewContainer *)inflateViewFromFile:(NSString *)fullPath {
    BILayoutInflater *inflater = [BILayoutInflater new];
    return [inflater inflateFilePath:fullPath withContent:nil];
}
@end