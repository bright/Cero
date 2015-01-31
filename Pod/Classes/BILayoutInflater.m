#import "BILayoutInflater.h"
#import "BIParserDelegate.h"
#import "BIViewHierarchyBuilder.h"
#import "BIInflatedViewContainer.h"


@implementation BILayoutInflater {

    BIParserDelegate *_parserDelegate;
}

- (id)init {
    self = [super init];
    if (self) {
        _parserDelegate = [BIParserDelegate new];

    }
    return self;
}

- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath withContent:(NSData *)content {
    BIViewHierarchyBuilder *builder = [BIViewHierarchyBuilder builderWithParser:_parserDelegate];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:content];
    parser.delegate = _parserDelegate;
    [parser parse];
    return builder.container;
}

- (BIInflatedViewContainer *)inflateFilePath:(NSString *)filePath withContentString:(NSString *)content {
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