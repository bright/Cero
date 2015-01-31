#import "BILayoutInflater.h"
#import "BIViewHierarchyBuilder.h"
#import "UIView+BIViewExtensions.h"

SpecBegin(BILayoutInflaterSpec)

    beforeEach(^{
        [BIViewHierarchyBuilder registerDefaultHandlers];
    });

    describe(@"BILayoutInflater", ^{
        __block UIView *view;
        __block BILayoutInflater *inflater;
        __block UIView *(^inflateView)(NSString *);
        beforeEach(^{
            inflater = [BILayoutInflater new];
            inflateView = ^(NSString *xml) {
                return [inflater inflateFilePath:@"ignore" withContentString:xml];
            };
        });
        context(@"having a simple one elment doc", ^{
            it(@"should properly create uiview", ^{
                view = inflateView(@"<UIView></UIView>");

                expect(view).notTo.beNil();
                expect(view).to.beKindOf(UIView.class);
            });
            it(@"should properly create uibutton", ^{
                view = inflateView(@"<UIButton></UIButton>");

                expect(view).notTo.beNil();
                expect(view).to.beKindOf(UIButton.class);
            });
            it(@"should properly create uibutton with custom type", ^{
                UIButton *button = (UIButton *) inflateView(@"<UIButton type=\"UIButtonTypeInfoDark\"></UIButton>");
                expect(button).notTo.beNil();
                expect(button.buttonType).to.equal(UIButtonTypeInfoDark);
            });
            context(@"building ui view with dimension properties", ^{
                beforeEach(^{
                    view = inflateView(@"<UIView width=\"100\" height=\"50\" top=\"10\"  left=\"20\" />");
                });
                it(@"should build view properly", ^{
                    expect(view).notTo.beNil();
                });
                it(@"should set view width", ^{
                    expect(view.width).to.equal(100);
                });
                it(@"should set view height", ^{
                    expect(view.height).to.equal(50);
                });
                it(@"should set view top", ^{
                    expect(view.top).to.equal(10);
                });
                it(@"should set view left", ^{
                    expect(view.left).to.equal(20);
                });
            });
            context(@"building button with title for state", ^{
                __block UIButton *button;
                beforeEach(^{
                    button = (UIButton *) inflateView(@"<UIButton>"
                            "<titleForState state=\"UIControlStateNormal\" value=\"Normal\" />"
                            "<titleForState state=\"UIControlStateSelected\" value=\"Selected\" />"
                            "<titleForState state=\"UIControlStateDisabled\" value=\"Disabled\" />"
                            "<titleForState state=\"UIControlStateHighlighted\" value=\"Highlighed\" />"
                            "<titleForState state=\"UIControlStateApplication\" value=\"Application\" />"
                            "</UIButton>");
                });
                it(@"should build button properly", ^{
                    expect(button).toNot.beNil();
                });
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
        });

        context(@"having a view hierarchy to build", ^{
            context(@"nesting uiview inside uiview", ^{
                beforeEach(^{
                    view = inflateView(@"<UIView><UIView/></UIView>");
                });
                it(@"should create view properly", ^{
                    expect(view).toNot.beNil();
                });
                it(@"should create nested view properly", ^{
                    expect(view.subviews[0]).toNot.beNil();
                    expect(view.subviews[0]).to.beKindOf(UIView.class);
                });
            });
            context(@"nesting uibutton inside uiview", ^{
                beforeEach(^{
                    view = inflateView(@"<UIView><UIButton /></UIView>");
                });

                it(@"should create nested button properly", ^{
                    expect(view.subviews[0]).toNot.beNil();
                    expect(view.subviews[0]).to.beKindOf(UIButton.class);
                });
            });
            context(@"nesting many uiviews inside uiview", ^{
                beforeEach(^{
                    view = inflateView(@"<UIView><UIView/><UIButton /></UIView>");
                });

                it(@"should create first nested view properly", ^{
                    expect(view.subviews[0]).toNot.beNil();
                    expect(view.subviews[0]).to.beKindOf(UIView.class);
                });

                it(@"should create second nested view properly", ^{
                    expect(view.subviews[1]).toNot.beNil();
                    expect(view.subviews[1]).to.beKindOf(UIButton.class);
                });
            });
        });

    });
SpecEnd