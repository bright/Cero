#import <UIKit/UIKit.h>
#import "TestHelpers.h"

SpecBegin(SegmentedControl_specs)
    describe(@"Segmented Control", ^{
        __block UISegmentedControl *control;
        UISegmentedControl *(^inflate)(NSString *xml) = ^UISegmentedControl *(NSString *xml) {
            return (UISegmentedControl *) testInflate(xml).root;
        };
        context(@"default control", ^{
            beforeEach(^{
                control = inflate(@"<UISegmentedControl />");
            });

            it(@"should create a segmented control", ^{
                expect(control).toNot.beNil();
            });
        });
        context(@"control with string items", ^{
            beforeEach(^{
                control = inflate(@"<UISegmentedControl items='Ala, Ola, Pies'/>");
            });

            it(@"should add items in given order", ^{
                expect([control titleForSegmentAtIndex:0]).to.equal(@"Ala");
                expect([control titleForSegmentAtIndex:1]).to.equal(@"Ola");
                expect([control titleForSegmentAtIndex:2]).to.equal(@"Pies");
            });
        });
        context(@"control with mixed items", ^{
            beforeEach(^{
                control = inflate(@"<UISegmentedControl>"
                        "<segment title='Ala' />"
                        "<segment image='bright' />"
                        "<segment title='Ola' enabled='false' />"
                        "</UISegmentedControl>");
            });

            it(@"should add string items in given order", ^{
                expect([control titleForSegmentAtIndex:0]).to.equal(@"Ala");
                expect([control titleForSegmentAtIndex:2]).to.equal(@"Ola");
            });

            it(@"should add image items", ^{
                expect([control imageForSegmentAtIndex:1]).to.equal([UIImage imageNamed:@"bright"]);
            });
        });
    });
SpecEnd
