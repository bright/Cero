#import "ButtonsAndLabelsViewController.h"
#import "BILayoutLoader.h"


@implementation ButtonsAndLabelsViewController {

    BILayoutLoader *_watcher;
}

- (void)loadView {
    [super loadView];
    _watcher = [BILayoutLoader watchingInflaterForLayout:@"ButtonsAndLabels"];
    [_watcher fillViewOfController:self];
}

@end