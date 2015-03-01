#import <UIKit/UIKit.h>
#import "TestHelpers.h"

SpecBegin(Label_specs)

    describe(@"Inflate label", ^{
        __block UILabel *label;
        UILabel *(^inflate)(NSString *xml) = ^UILabel *(NSString *xml) {
            return (UILabel *) testInflate(xml).root;
        };

        it(@"should set text attribute properly", ^{
            label = inflate(@"<UILabel text='ala ma kota' />");
            expect(label.text).to.equal(@"ala ma kota");
        });

        it(@"should set text color attribute properly", ^{
            label = inflate(@"<UILabel textColor='#00ff00' />");
            UIColor *green = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
            expect(label.textColor).to.equal(green);
        });

        it(@"should set text alignment attribute properly", ^{
            label = inflate(@"<UILabel textAlignment='center' />");
            expect(label.textAlignment).to.equal(NSTextAlignmentCenter);
        });

        it(@"should set text font attribute properly", ^{
            UIFont *font = [UIFont fontWithName:@"Arial" size:17];
            label = inflate(@"<UILabel font='Arial' />");
            expect(label.font).to.equal(font);
        });
        it(@"should set text font with size attribute properly", ^{
            UIFont *font = [UIFont fontWithName:@"Avenir" size:13];
            label = inflate(@"<UILabel font='Avenir(13)' />");
            expect(label.font).to.equal(font);
        });

    });

SpecEnd
