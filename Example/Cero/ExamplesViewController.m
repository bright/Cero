#import "ExamplesViewController.h"
#import "BILayoutLoader.h"
#import "BIEXTScope.h"

@protocol Examples <BIInflatedViewHelper>
@end

@implementation ExamplesViewController {
    BILayoutLoader *_watcher;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Examples";
    }

    return self;
}

- (void)loadView {
    [super loadView];
    _watcher = [BILayoutLoader watchingInflaterForLayout:@"Examples"];
    @weakify(self);
    [_watcher fillViewOfController:self andNotify:^(NSObject <Examples> *view) {
        @strongify(self);
        [self setupView:view];
    }];
}

- (void)setupView:(NSObject <Examples> *)viewHelper {

}

@end