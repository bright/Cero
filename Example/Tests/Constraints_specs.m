#import <UIKit/UIKit.h>
#import "TestHelpers.h"

SpecBegin(Constraints_specs)
    describe(@"BIConstraintElementHandler", ^{
        __block UIView *view;
        NSInteger rootWidth = 100;
        NSInteger rootHeight = 300;
        __block id <BIInflatedViewHelper> helper;
        id <BIInflatedViewHelper>(^inflateInParent)(NSString *) = ^(NSString *childViews) {
            NSString *wrappedInFrame = [NSString stringWithFormat:@"<UIView id='root' width='100' height='300'>\n\n%@\n\n</UIView>", childViews];
            id <BIInflatedViewHelper> container = testInflate(wrappedInFrame);
            [container.root setNeedsLayout];
            [container.root layoutIfNeeded];
            return container;
        };

        context(@"constraint width superview width", ^{
            beforeEach(^{
                helper = nil;
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
                expect([helper findViewById:@"child"].frame.size.width).to.equal(rootWidth * 0.9);
            });
        });

        context(@"constraint width superview width specified explicitely", ^{
            beforeEach(^{
                helper = inflateInParent(@"<UIView id='child'>"
                        "<Constraint on='NSLayoutAttributeWidth' relation='NSLayoutRelationEqual'"
                        "            with=':superview.width' multiplier='0.9'"
                        "            constant='0' priority='9' />"
                        "</UIView>");
            });
            it(@"builds a proper view", ^{
                expect(helper.root).toNot.beNil();
            });
            it(@"should properly build constraint", ^{
                expect([helper findViewById:@"child"].frame.size.width).to.equal(rootWidth * 0.9);
            });
        });
        context(@"constraint width superview width short format", ^{
            beforeEach(^{
                helper = inflateInParent(@"<UIView id='child'>"
                        "<Constraint on='width' with=':superview' multiplier='0.9' />"
                        "</UIView>");
            });
            it(@"builds a proper view", ^{
                expect(helper.root).toNot.beNil();
            });
            it(@"should properly build constraint", ^{
                expect([helper findViewById:@"child"].frame.size.width).to.equal(rootWidth * 0.9);
            });
        });
        context(@"constraint both width and height to superview width short format", ^{
            beforeEach(^{
                helper = inflateInParent(@"<UIView id='child'>"
                        "<Constraint on='width' with=':superview' multiplier='0.9' />"
                        "<Constraint on='height' with=':superview' multiplier='0.5' />"
                        "</UIView>");
            });
            it(@"should properly build constraint", ^{
                CGSize childSize = [helper findViewById:@"child"].frame.size;
                expect(childSize.width).to.equal(rootWidth * 0.9);
                expect(childSize.height).to.equal(rootHeight * 0.5);
            });
        });
        context(@"constraint both width and height to superview width short format combined", ^{
            beforeEach(^{
                helper = inflateInParent(@"<UIView id='child'>"
                        "<Constraint on='width,height' with=':superview' multiplier='0.5' />"
                        "</UIView>");
            });
            it(@"should properly build constraint", ^{
                CGSize childSize = [helper findViewById:@"child"].frame.size;
                expect(childSize.width).to.equal(rootWidth * 0.5);
                expect(childSize.height).to.equal(rootHeight * 0.5);
            });
        });
        context(@"constraint with white space in attribute", ^{
            beforeEach(^{
                helper = inflateInParent(@"<UIView id='child'>"
                        "<Constraint on='width ' with=':superview' multiplier='0.5' />"
                        "</UIView>");
            });
            it(@"should properly build constraint", ^{
                CGSize childSize = [helper findViewById:@"child"].frame.size;
                expect(childSize.width).to.equal(rootWidth * 0.5);
            });
        });
    });
SpecEnd
