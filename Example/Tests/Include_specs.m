#import <UIKit/UIKit.h>
#import "TestHelpers.h"

@protocol TestInclude <BIInflatedViewHelper>
- (UIView *)firstIncludedChild;

- (UIView *)seondIncludedChild;
@end

@protocol ParentWithInclude <TestInclude>
- (UIView *)beforeInclude;

- (UIView *)afterInclude;
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
            });

        });

    });
SpecEnd
