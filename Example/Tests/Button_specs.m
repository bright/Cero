#import <UIKit/UIKit.h>
#import "TestHelpers.h"

SpecBegin(Button_specs)

    describe(@"BIButtonHandler", ^{
        __block UIButton *button;
        UIButton *(^inflate)(NSString *xml) = ^UIButton *(NSString *xml) {
            return (UIButton *) testInflate(xml).root;
        };

        context(@"default button", ^{
            beforeEach(^{
                button = inflate(@"<UIButton />");
            });

            it(@"should create a button", ^{
                expect(button).toNot.beNil();
            });
        });

        context(@"button with default titlte", ^{
            beforeEach(^{
                button = inflate(@"<UIButton>"
                        "<title value='Normal' />"
                        "</UIButton>");
            });


            it(@"should set button title for normal state", ^{
                expect([button titleForState:UIControlStateNormal]).to.equal(@"Normal");
            });
        });


        sharedExamplesFor(@"button state title", ^(NSDictionary *data) {
            it(@"should set button title for normal state", ^{
                expect([button titleForState:UIControlStateNormal]).to.equal(@"Normal");
            });
            it(@"should set button title for selected state", ^{
                expect([button titleForState:UIControlStateSelected]).to.equal(@"Selected");
            });
            it(@"should set button title for higlighted state", ^{
                expect([button titleForState:UIControlStateHighlighted]).to.equal(@"Highlighed");
            });
            it(@"should set button title for disabled state", ^{
                expect([button titleForState:UIControlStateDisabled]).to.equal(@"Disabled");
            });
            it(@"should set button title for application state", ^{
                expect([button titleForState:UIControlStateApplication]).to.equal(@"Application");
            });
        });

        context(@"button with title", ^{
            beforeEach(^{
                button = inflate(@"<UIButton>"
                        "<title forState=\"UIControlStateNormal\" value=\"Normal\" />"
                        "<title forState=\"UIControlStateSelected\" value=\"Selected\" />"
                        "<title forState=\"UIControlStateDisabled\" value=\"Disabled\" />"
                        "<title forState=\"UIControlStateHighlighted\" value=\"Highlighed\" />"
                        "<title forState=\"UIControlStateApplication\" value=\"Application\" />"
                        "</UIButton>");
            });

            itBehavesLike(@"button state title", nil);
        });

        context(@"button with title short form", ^{
            beforeEach(^{
                button = inflate(@"<UIButton>"
                        "<title forState=\"normal\" value=\"Normal\" />"
                        "<title forState=\"selected\" value=\"Selected\" />"
                        "<title forState=\"disabled\" value=\"Disabled\" />"
                        "<title forState=\"highlighted\" value=\"Highlighed\" />"
                        "<title forState=\"application\" value=\"Application\" />"
                        "</UIButton>");
            });

            itBehavesLike(@"button state title", nil);

        });
    });

SpecEnd