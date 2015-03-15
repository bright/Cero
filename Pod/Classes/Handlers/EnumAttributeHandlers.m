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

- (NSObject <BIAttributeHandler> *)keyboardAppearance {
    BIEnumAttributeHandler *handler = BIEnumAttributeHandler.new;
    handler.valuesEnum = BIEnumFor(UIKeyboardAppearance);
    handler.setter = @selector(setKeyboardAppearance:);
    handler.attributeName = @"keyboardAppearance";
    return handler;
}

- (NSObject <BIAttributeHandler> *)returnKeyType {
    BIEnumAttributeHandler *handler = BIEnumAttributeHandler.new;
    handler.valuesEnum = BIEnumFor(UIReturnKeyType);
    handler.setter = @selector(setReturnKeyType:);
    handler.attributeName = @"returnKeyType";
    return handler;
}
@end