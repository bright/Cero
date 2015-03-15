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

- (NSObject <BIAttributeHandler> *)textAutocorrectionType {
    BIEnumAttributeHandler *handler = BIEnumAttributeHandler.new;
    handler.valuesEnum = BIEnumFor(UITextAutocorrectionType);
    handler.setter = @selector(setAutocorrectionType:);
    handler.attributeName = @"autocorrectionType";
    return handler;
}

- (NSObject <BIAttributeHandler> *)spellCheckingType {
    BIEnumAttributeHandler *handler = BIEnumAttributeHandler.new;
    handler.valuesEnum = BIEnumFor(UITextSpellCheckingType);
    handler.setter = @selector(setSpellCheckingType:);
    handler.attributeName = @"spellCheckingType";
    return handler;
}

- (NSObject <BIAttributeHandler> *)keyboardType {
    BIEnumAttributeHandler *handler = BIEnumAttributeHandler.new;
    handler.valuesEnum = BIEnumFor(UIKeyboardType);
    handler.setter = @selector(setKeyboardType:);
    handler.attributeName = @"keyboardType";
    return handler;
}
@end