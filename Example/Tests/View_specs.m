#import <UIKit/UIKit.h>
#import "TestHelpers.h"

SpecBegin(View_specs)
    describe(@"UIView", ^{
        __block UIView *view;
        UIView *(^inflate)(NSString *xml) = ^UIView *(NSString *xml) {
            return testInflate(xml).root;
        };

        it(@"should set content mode properly", ^{
            view = inflate(@"<UIView contentMode='ScaleAspectFit' />");
            expect(view.contentMode).to.equal(UIViewContentModeScaleAspectFit);
        });

    });
SpecEnd
