#import <UIKit/UIKit.h>
#import "TestHelpers.h"

@protocol TestInclude <BIInflatedViewHelper>
- (UIView *)firstIncludedChild;

- (UIView *)secondIncludedChild;
@end

@protocol ParentWithInclude <TestInclude>
- (UIView *)beforeInclude;

- (UIView *)afterInclude;

- (UIView *)parent;
@end

SpecBegin(Include_specs)
    describe(@"BIIncludeHandler", ^{
        __block NSObject <ParentWithInclude> *parent;
        context(@"including file with root", ^{
            beforeEach(^{
                parent = testInflate(@"<UIView>\n"
                        "<UIView id='beforeInclude'></UIView>\n"
                        "<include layout='TestIncludeSingle' />\n"
                        "<UIView id='afterInclude'></UIView>\n"
                        "</UIView>");
            });

            it(@"should build view before include", ^{
                expect(parent.beforeInclude).toNot.beNil();
            });

            it(@"should properly build included views", ^{
                expect(parent.firstIncludedChild).toNot.beNil();
                expect(parent.secondIncludedChild).toNot.beNil();
            });
        });

        context(@"including file with merge root", ^{
            beforeEach(^{
                parent = testInflate(@"<UIView id='parent'>\n"
                        "<include layout='TestIncludeMerge' />\n"
                        "</UIView>");
            });

            it(@"should properly build included views", ^{
                expect(parent.firstIncludedChild).toNot.beNil();
                expect(parent.secondIncludedChild).toNot.beNil();
            });

            it(@"should make included views chidlren of parent view", ^{
                expect(parent.parent.subviews).to.contain(parent.firstIncludedChild);
                expect(parent.parent.subviews).to.contain(parent.secondIncludedChild);
            });
        });

    });
SpecEnd
