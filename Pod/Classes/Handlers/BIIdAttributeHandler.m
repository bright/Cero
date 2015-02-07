#import "BIIdAttributeHandler.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"
#import "BIInflatedViewContainer.h"
#import "BISourceReference.h"

@implementation BIIdAttributeHandler

- (BOOL)canHandle:(NSString *)attribute
        ofElement:(BILayoutElement *)element
        inBuilder:(BIViewHierarchyBuilder *)builder {
    return [@"id" isEqualToString:attribute];
}

- (void)handle:(NSString *)attribute
     ofElement:(BILayoutElement *)element
     inBuilder:(BIViewHierarchyBuilder *)builder {
    NSString *idAttributeValue = element.attributes[attribute];
    if (idAttributeValue.length > 0) {
        NSError *error;
        BISourceReference *sourceReference = [builder.sourceReference subReferenceFromLine:element.startLineNumber andColumn:element.startColumnNumber];
        [builder.container tryAddingElement:builder.current
                                     withId:idAttributeValue
                                 fromSource:sourceReference
                                      error:&error];
    } else {
        //TODO: log error message
    }
}

@end