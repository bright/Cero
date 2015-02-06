#import <UIKit/UIKit.h>
#import "TestHelpers.h"

SpecBegin(Constraints_specs)
    describe(@"BIConstraintElementHandler", ^{
        __block UIView *view;
        __block id <BIInflatedViewHelper> helper;
        id <BIInflatedViewHelper>(^inflateInParent)(NSString *) = ^(NSString *childViews) {
            NSString *wrappedInFrame = [NSString stringWithFormat:@"<UIView id='root' width='100' height='100'>\n\n%@\n\n</UIView>", childViews];
            id <BIInflatedViewHelper> container = testInflate(wrappedInFrame);
            [container.root setNeedsLayout];
            [container.root layoutIfNeeded];
            return container;
        };

        context(@"constraint width to other element width", ^{
            beforeEach(^{
                helper = inflateInParent(@"<UIView id='child'>"
                        "<Constraint on='NSLayoutAttributeWidth' relation='NSLayoutRelationEqual'"
                        "            with=':superview' multiplier='0.9'"
                        "            constant='0' priority='9' />"
                        "</UIView>");
            });

            it(@"builds a proper view", ^{
                expect(helper.root).toNot.beNil();
            });
            it(@"should properly build constraint", ^{
                expect([helper findViewById:@"child"].frame.size.width).to.equal(90);
            });
        });
    });
SpecEnd
