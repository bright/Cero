#import "BISimpleAttributeHandler.h"
#import "BILayoutElement.h"
#import "BIViewHierarchyBuilder.h"
#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnusedImportStatement"
#import "UIView+BIViewExtensions.h"
#pragma clang diagnostic pop

#import "NSObject+KVCExtensions.h"


@implementation BISimpleAttributeHandler
- (BOOL)canHandle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    return YES;
}

- (void)handle:(NSString *)attribute ofElement:(BILayoutElement *)element inBuilder:(BIViewHierarchyBuilder *)builder {
    NSDictionary *attributes = [element attributes];
    id value = attributes[attribute];
    if([builder.current canSetValueForKeyPath:attribute]){
        [builder.current setValue:value forKeyPath:attribute];
    } else {
        NSLog(@"Element %@ does not support attribute %@ with value %@", element.name, attribute,value );
    }
}

@end