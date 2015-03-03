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

        context(@"button with default title", ^{
            beforeEach(^{
                button = inflate(@"<UIButton>"
                        "<title title='Normal' titleColor='#ff0000' titleShadowColor='#00ff00' />"
                        "</UIButton>");
            });


            it(@"should set button title for normal state", ^{
                expect([button titleForState:UIControlStateNormal]).to.equal(@"Normal");
            });

            it(@"should set button title color for normal state", ^{
                expect([button titleColorForState:UIControlStateNormal]).to.equal([UIColor redColor]);
            });
            it(@"should set button title shadow color for normal state", ^{
                expect([button titleShadowColorForState:UIControlStateNormal]).to.equal([UIColor greenColor]);
            });
        });

        context(@"button with default image", ^{
            beforeEach(^{
                button = inflate(@"<UIButton>"
                        "<image image='bright' backgroundImage='bright' />"
                        "</UIButton>");
            });

            it(@"should set image for normal state", ^{
                expect([button imageForState:UIControlStateNormal]).to.equal([UIImage imageNamed:@"bright"]);
            });

            it(@"should set background image for normal state", ^{
                expect([button backgroundImageForState:UIControlStateNormal]).to.equal([UIImage imageNamed:@"bright"]);
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
                        "<title forState=\"UIControlStateNormal\" title=\"Normal\" />"
                        "<title forState=\"UIControlStateSelected\" title=\"Selected\" />"
                        "<title forState=\"UIControlStateDisabled\" title=\"Disabled\" />"
                        "<title forState=\"UIControlStateHighlighted\" title=\"Highlighed\" />"
                        "<title forState=\"UIControlStateApplication\" title=\"Application\" />"
                        "</UIButton>");
            });

            itBehavesLike(@"button state title", nil);
        });

        context(@"button with title short form", ^{
            beforeEach(^{
                button = inflate(@"<UIButton>"
                        "<title forState=\"normal\" title=\"Normal\" />"
                        "<title forState=\"selected\" title=\"Selected\" />"
                        "<title forState=\"disabled\" title=\"Disabled\" />"
                        "<title forState=\"highlighted\" title=\"Highlighed\" />"
                        "<title forState=\"application\" title=\"Application\" />"
                        "</UIButton>");
            });

            itBehavesLike(@"button state title", nil);

        });
    });

SpecEnd
