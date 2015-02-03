#import "BIParserDelegate.h"
#import "BILayoutElement.h"


@implementation BIParserDelegate
- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributeDict {
    if (self.onEnterNode != nil) {
        BILayoutElement *element = [BILayoutElement new];
        element.name = elementName;
        element.namepsaceURI = namespaceURI;
        element.attributes = attributeDict.mutableCopy;
        element.startLineNumber = (NSUInteger) parser.lineNumber;
        element.startColumnNumber = (NSUInteger) parser.columnNumber;
        self.onEnterNode(element);
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    if (self.onLeaveNode != nil) {
        BILayoutElement *element = [BILayoutElement new];
        element.name = elementName;
        element.namepsaceURI = namespaceURI;
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

}


@end