#import "UIView+BIViewExtensions.h"
#import "TestHelpers.h"

SpecBegin(BILayoutInflaterSpec)

    describe(@"BILayoutInflater", ^{
        __block UIView *view;
        context(@"having a simple one elment doc", ^{
            it(@"should properly create uiview", ^{
                view = testInflateView(@"<UIView></UIView>");

                expect(view).notTo.beNil();
                expect(view).to.beKindOf(UIView.class);
            });
            it(@"should properly create uibutton", ^{
                view = testInflateView(@"<UIButton></UIButton>");

                expect(view).notTo.beNil();
                expect(view).to.beKindOf(UIButton.class);
            });
            it(@"should properly create uibutton with custom type", ^{
                UIButton *button = (UIButton *) testInflateView(@"<UIButton type=\"UIButtonTypeInfoDark\"></UIButton>");
                expect(button).notTo.beNil();
                expect(button.buttonType).to.equal(UIButtonTypeInfoDark);
            });
            context(@"building ui view with dimension properties", ^{
                beforeEach(^{
                    view = testInflateView(@"<UIView width=\"100\" height=\"50\" top=\"10\"  left=\"20\" />");
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
        });

        context(@"having a view hierarchy to build", ^{
            context(@"nesting uiview inside uiview", ^{
                beforeEach(^{
                    view = testInflateView(@"<UIView><UIView/></UIView>");
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
                    view = testInflateView(@"<UIView><UIButton /></UIView>");
                });

                it(@"should create nested button properly", ^{
                    expect(view.subviews[0]).toNot.beNil();
                    expect(view.subviews[0]).to.beKindOf(UIButton.class);
                });
            });
            context(@"nesting many uiviews inside uiview", ^{
                beforeEach(^{
                    view = testInflateView(@"<UIView><UIView/><UIButton /></UIView>");
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