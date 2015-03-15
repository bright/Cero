#import <Cero/BILayoutLoader.h>
#import <Cero/BIInflatedViewHelper.h>
#import "FormSampleViewController.h"
#import "CommentViewModel.h"

@protocol FormView <BIInflatedViewHelper>
- (UITextField *)nick;

- (UITextView *)comment;

- (UIButton *)submit;
@end

@implementation FormSampleViewController {
    BILayoutLoader *_layoutLoader;
    CommentViewModel *_commentViewModel;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _layoutLoader = BILayoutLoader.new;
        _commentViewModel = [CommentViewModel new];
    }

    return self;
}

- (void)loadView {
    [super loadView];
    __weak __typeof(self) wself = self;
    [_layoutLoader fillViewOfController:self layout:@"FormSample" loaded:^(NSObject <FormView> *view) {
        __strong __typeof(self) self = wself;
        view.nick.text = _commentViewModel.nick;
        view.comment.text = _commentViewModel.comment;
        [view.submit addTarget:self action:@selector(submitComment) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)submitComment {

}


@end