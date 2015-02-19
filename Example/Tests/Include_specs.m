#import <UIKit/UIKit.h>
#import <Cero/BIViewHierarchyBuilder.h>
#import <Cero/BILayoutLoader.h>
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

        context(@"including nested layouts", ^{
            beforeEach(^{
                parent = testInflate(@"<UIView id='parent'>\n"
                        "<include layout='TestIncludeParent' />\n"
                        "</UIView>");
            });
            it(@"should properly build views included at first level", ^{
                expect(parent.firstIncludedChild).toNot.beNil();
            });
            it(@"should properly build views included at second level", ^{
                expect(parent.secondIncludedChild).toNot.beNil();
            });
        });

        context(@"building included layouts many times", ^{
            __block UIView *firstLoadView;
            __block UIView *secondLoadView;
            __block NSObject <TestInclude> *firstLoad;
            __block NSObject <TestInclude> *secondLoad;
            beforeEach(^{
                BILayoutLoader *loader = testLoader();
                firstLoad = (id) [loader fillView:nil layout:@"TestIncludeParent" loaded:^(id <BIInflatedViewHelper> o) {
                    firstLoadView = o.root;
                }];
                secondLoad = (id) [loader fillView:nil layout:@"TestIncludeParent" loaded:^(id <BIInflatedViewHelper> o) {
                    secondLoadView = o.root;
                }];
            });

            it(@"should load correctly first time", ^{
                expect(firstLoad.firstIncludedChild).toNot.beNil();
                expect(firstLoadView).toNot.beNil();
            });

            it(@"should load correctly second time", ^{
                expect(secondLoad.secondIncludedChild).toNot.beNil();
                expect(secondLoadView).toNot.beNil();
            });
        });

    });
SpecEnd
