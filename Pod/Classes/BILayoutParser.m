#import "BILayoutParser.h"
#import "BILayoutElement.h"
#import "BILayoutElementTreeNode.h"


@interface BILayoutParser () <NSXMLParserDelegate>
@end

@implementation BILayoutParser {
    BILayoutElementTreeNode *_rootNode;
    BILayoutElementTreeNode *_currentNode;
    NSXMLParser *_parser;
}

+ (BILayoutParser *)parserFor:(NSData *)data {
    return [[self alloc] initWithData:data];
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _parser = [[NSXMLParser alloc] initWithData:data];
        _parser.delegate = self;
    }
    return self;
}

- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributeDict {
    BILayoutElement *element = [BILayoutElement new];
    element.name = elementName;
    element.namepsaceURI = namespaceURI;
    element.attributes = attributeDict.mutableCopy;
    element.startLineNumber = (NSUInteger) parser.lineNumber;
    element.startColumnNumber = (NSUInteger) parser.columnNumber;


    BILayoutElementTreeNode *node = [BILayoutElementTreeNode node:element];
    [self rootNodeIfNeeded:node];
    node.parent = _currentNode;
    [_currentNode addChild:node];
    _currentNode = node;
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    BILayoutElement *element = _currentNode.element;
    element.endLineNumber = (NSUInteger) parser.lineNumber;
    element.endColumnNumber = (NSUInteger) parser.columnNumber;

    _currentNode = _currentNode.parent;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"[ERROR] - BIParserDelegate - %@", parseError);
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    NSLog(@"[WARN] - BIParserDelegate - %@", validationError);
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
}

- (void)rootNodeIfNeeded:(BILayoutElementTreeNode *)node {
    if (_rootNode == nil) {
        _rootNode = node;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
}


- (BOOL)parse {
    [_parser parse];
    return _parser.parserError == nil;
}

- (void)traverseElements {
    [self enterNode:_rootNode];
}

- (void)enterNode:(BILayoutElementTreeNode *)node {
    NSAssert(node != nil, @"Can't enter nil node");
    if (node != nil) {
        if (self.onEnterNode != nil) {
            self.onEnterNode(node.element);
        }
        for (BILayoutElementTreeNode *childNode in node.children) {
            [self enterNode:childNode];
        }
        if (self.onLeaveNode != nil) {
            self.onLeaveNode(node.element);
        }
    }
}

- (NSError *)error {
    return _parser.parserError;
}
@end