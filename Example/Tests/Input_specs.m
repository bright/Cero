#import <UIKit/UIKit.h>
#import "TestHelpers.h"

SpecBegin(Input_specs)
    describe(@"TextInputTraits", ^{
        __block UIView <UITextInputTraits> *input;
        UIView <UITextInputTraits> *(^inflate)(NSString *xml) = ^UIView <UITextInputTraits> *(NSString *xml) {
            return (UIView <UITextInputTraits> *) testInflate(xml).root;
        };

        it(@"can set text autocapitalization", ^{
            input = inflate(@"<UITextField autocapitalizationType='words' />");
            expect(input.autocapitalizationType).to.equal(UITextAutocapitalizationTypeWords);
        });
        it(@"can set text autocorrection", ^{
            input = inflate(@"<UITextField autocorrectionType='no' />");
            expect(input.autocorrectionType).to.equal(UITextAutocorrectionTypeNo);
        });
        it(@"can set text spelling type", ^{
            input = inflate(@"<UITextField spellCheckingType='no' />");
            expect(input.spellCheckingType).to.equal(UITextSpellCheckingTypeNo);
        });
    });
SpecEnd
