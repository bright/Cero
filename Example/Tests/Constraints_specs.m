#import <UIKit/UIKit.h>
#import "TestHelpers.h"

@protocol HasHeightConstraint <BIInflatedViewHelper>
- (NSLayoutConstraint *)heightConstraint;

- (NSArray *)constraints;
@end

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
        context(@"constraint with previous selector", ^{
            beforeEach(^{
                helper = inflateInParent(@""
                        "<UIView id='firstChild'>"
                        "<Constraint on='height' constant='100' />"
                        "</UIView>"
                        "<UIView id='secondChild'>"
                        "<Constraint on='height' constant='100' />"
                        "<Constraint on='top' with=':previous.bottom' />"
                        "</UIView>"
                        ""
                        "");
            });
            it(@"should properly build constraint", ^{
                CGRect secondChildRect = [helper findViewById:@"secondChild"].frame;
                expect(secondChildRect.origin.y).to.equal(100);
            });
        });
        context(@"constraint with next selector", ^{
            beforeEach(^{
                helper = inflateInParent(@""
                        "<UIView id='firstChild'>"
                        "<Constraint on='height' constant='100' />"
                        "<Constraint on='bottom' with=':next.top' />"
                        "</UIView>"
                        "<UIView id='secondChild'>"
                        "<Constraint on='height' constant='100' />"
                        "<Constraint on='top' constant='400' />"
                        "</UIView>"
                        ""
                        "");
            });
            it(@"should properly build constraint", ^{
                CGRect secondChildRect = [helper findViewById:@"firstChild"].frame;
                expect(secondChildRect.origin.y).to.equal(300);
            });
        });
        context(@"a single constraint can be referenced by id", ^{
            beforeEach(^{
                helper = inflateInParent(@""
                        "<UIView id='firstChild'>"
                        "<Constraint id='heightConstraint' on='height' constant='100' />"
                        "</UIView>"
                        ""
                        "");
            });
            it(@"should be able find constraint by id", ^{
                NSLayoutConstraint *heightConstraint = [helper findElementById:@"heightConstraint"];
                expect(heightConstraint).notTo.beNil();
                expect(heightConstraint).to.beInstanceOf([NSLayoutConstraint class]);
            });
            it(@"should be able to find constraint using protocol method", ^{
                id <HasHeightConstraint> helperSpecific = (id <HasHeightConstraint>) helper;
                expect(helperSpecific.heightConstraint).notTo.beNil();
            });
        });
        context(@"multiple constraints can be referenced by id", ^{
            beforeEach(^{
                helper = inflateInParent(@""
                        "<UIView id='firstChild'>"
                        "<Constraint id='constraints' on='height,width' constant='100' />"
                        "</UIView>"
                        ""
                        "");
            });
            it(@"should be able find constraints by id", ^{
                NSArray *constraints = [helper findElementById:@"constraints"];
                expect(constraints).notTo.beNil();
                expect(constraints.count).to.equal(2);
                expect(constraints[0]).to.beInstanceOf([NSLayoutConstraint class]);
                expect(constraints[1]).to.beInstanceOf([NSLayoutConstraint class]);
            });
            it(@"should be able to find constraints using protocol method", ^{
                id <HasHeightConstraint> helperSpecific = (id <HasHeightConstraint>) helper;
                expect(helperSpecific.constraints).notTo.beNil();
            });
        });
    });
SpecEnd
