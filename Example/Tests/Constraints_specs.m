#import <UIKit/UIKit.h>
#import "TestHelpers.h"

SpecBegin(Constraints_specs)
    describe(@"BIConstraintElementHandler", ^{
        __block UIView *view;
        __block id <BIInflatedViewHelper> helper;
        id <BIInflatedViewHelper>(^inflateInParent)(NSString *) = ^(NSString *childViews) {
            NSString *wrappedInFrame = [NSString stringWithFormat:@"<UIView id='root' width='100' height='100'>\n\n%@\n\n</UIView>", childViews];
            id <BIInflatedViewHelper> container = testInflate(wrappedInFrame);
            [container.root layoutSubviews];
            return container;
        };

        context(@"constraint width to other element width", ^{
            beforeEach(^{
                helper = inflateInParent(@"<UIView id='child' />");
            });

            it(@"", ^{

            });
        });
    });
SpecEnd
