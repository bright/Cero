#import <Cero/BILayoutLoader.h>
#import <Cero/BIInflatedViewHelper.h>
#import "ScrollSampleViewController.h"
#import "BIEXTScope.h"

@implementation ScrollSampleViewController {

    BILayoutLoader *_watcher;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Scroll";
        _watcher = BILayoutLoader.new;
    }

    return self;
}

- (void)loadView {
    [super loadView];
    @weakify(self);
    [_watcher fillViewOfController:self layout:@"ScrollSampleBad" loaded:^(NSObject <BIInflatedViewHelper> *view) {
    }];
}


@end