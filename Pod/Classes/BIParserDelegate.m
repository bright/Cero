#import "BIParserDelegate.h"
#import "BILayoutElement.h"


@implementation BIParserDelegate {
    NSMutableArray *_stack;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _stack = NSMutableArray.new;
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
    [self pushToStack:element];
    if (self.onEnterNode != nil) {
        self.onEnterNode(element);
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    BILayoutElement *element = [self popFromStack];
    element.endLineNumber = (NSUInteger) parser.lineNumber;
    element.endColumnNumber = (NSUInteger) parser.columnNumber;
    if (self.onLeaveNode != nil) {
        self.onLeaveNode(element);
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"[ERROR] - BIParserDelegate - %@",parseError);
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    NSLog(@"[WARN] - BIParserDelegate - %@",validationError);
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {

}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (self.onParsingCompleted != nil) {
        self.onParsingCompleted();
    }
}

- (void)pushToStack:(BILayoutElement *)element {
    [_stack addObject:element];
}

- (BILayoutElement *)popFromStack {
    BILayoutElement *element = [_stack lastObject];
    [_stack removeLastObject];
    return element;
}


@end