#import <Specta/SpectaDSL.h>
#import <UIKit/UIKit.h>
#import "TestHelpers.h"

SpecBegin(IdAttribute_specs)
    describe(@"BIAttributeHandler", ^{
        __block id<BIInflatedViewHelper> container;

        context(@"a single view has id", ^{
            before(^{
               container = testInflate(@"<UIView id='firstId' />");
            });

            it(@"should build view properly", ^{
                expect(container.root).toNot.beNil();
            });

            it(@"should be able to find the view by id", ^{
                expect([container findViewById:@"firstId"]).to.equal(container.root);
            });

            it(@"should return nil if view with given id is not in the hierarchy", ^{
                expect([container findViewById:@"firstIdWrong"]).to.beNil();
            });
        });

        context(@"many views have different ids", ^{
            beforeEach(^{
                container = testInflate(@"<UIView> <UIView id='firstChild' />  <UIView id='secondChild' /> </UIView>");
            });

            it(@"should be able to find each child", ^{
                expect([container findViewById:@"firstChild"]).toNot.beNil();
                expect([container findViewById:@"firstChild"]).to.equal(container.root.subviews[0]);
                expect([container findViewById:@"secondChild"]).toNot.beNil();
                expect([container findViewById:@"secondChild"]).to.equal(container.root.subviews[1]);
            });
        });

        context(@"two views have the same id", ^{
            beforeEach(^{
                container = testInflate(@"<UIView> <UIView id='duplicateId' />  <UIView id='duplicateId' /> </UIView>");
            });

            it(@"print a message about duplicate id", ^{
            });
        });
    });
SpecEnd
