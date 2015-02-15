#import <UIKit/UIKit.h>
#import "TestHelpers.h"

@protocol IdAttributeTestViewHelper <BIInflatedViewHelper>
- (UIView *)firstChild;

- (UIView *)secondChild;

- (UIView *)notExisting;
@end

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

        context(@"finding views with dynamic methods", ^{
            beforeEach(^{
                container = testInflate(@"<UIView> <UIView id='firstChild' />  <UIView id='secondChild' /> </UIView>");
            });

            it(@"should be able to find a view with a simple method call", ^{
                id <IdAttributeTestViewHelper> specificContainer = (id <IdAttributeTestViewHelper>) container;
                UIView *firstChild = specificContainer.firstChild;
                expect(firstChild).to.equal([container findViewById:@"firstChild"]);
                UIView *secondChild = specificContainer.secondChild;
                expect(secondChild).to.equal([container findViewById:@"secondChild"]);
            });

            it(@"should throw an error if one tries to use method for which view doesn't exist", ^{
                id <IdAttributeTestViewHelper> specificContainer = (id <IdAttributeTestViewHelper>) container;
                expect(^{
                    [specificContainer notExisting];
                }).to.raiseAny();
            });
        });
    });
SpecEnd

