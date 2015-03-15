#import "BIKeyboardType.h"

@implementation BIKeyboardType
+ (void)load {
    [super load];
    BIRegisterSelfAsEnum(UIKeyboardType);
}

- (void)defineEnum {
    BIEnumDefine(UIKeyboardType,
            UIKeyboardTypeDefault,                // Default type for the current input method.
            UIKeyboardTypeASCIICapable,           // Displays a keyboard which can enter ASCII characters, non-ASCII keyboards remain active
            UIKeyboardTypeNumbersAndPunctuation,  // Numbers and assorted punctuation.
            UIKeyboardTypeURL,                    // A type optimized for URL entry (shows . / .com prominently).
            UIKeyboardTypeNumberPad,              // A number pad (0-9). Suitable for PIN entry.
            UIKeyboardTypePhonePad,               // A phone pad (1-9, *, 0, #, with letters under the numbers).
            UIKeyboardTypeNamePhonePad,           // A type optimized for entering a person's name or phone number.
            UIKeyboardTypeEmailAddress,           // A type optimized for multiple email address entry (shows space @ . prominently).
            UIKeyboardTypeDecimalPad,   // A number pad with a decimal point.
            UIKeyboardTypeTwitter,      // A type optimized for twitter text entry (easy access to @ #)
            UIKeyboardTypeWebSearch,    // A default keyboard type with URL-oriented addition (shows space . prominently).

            UIKeyboardTypeAlphabet);
}


@end