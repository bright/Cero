#import "EnumAttributeHandlers.h"
#import "BIAttributeHandler.h"
#import "BIEnumAttributeHandler.h"
#import "BIEnumsRegistry.h"
#import "BIEnum.h"

@implementation EnumAttributeHandlers {

}
- (NSObject <BIAttributeHandler> *)textAutocapitalizaitonType {
    BIEnumAttributeHandler *handler = BIEnumAttributeHandler.new;
    handler.valuesEnum = BIEnumFor(UITextAutocapitalizationType);
    handler.setter = @selector(setAutocapitalizationType:);
    handler.attributeName = @"autocapitalizationType";
    return handler;
}

@end