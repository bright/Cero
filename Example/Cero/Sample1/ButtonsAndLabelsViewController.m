#import "ButtonsAndLabelsViewController.h"
#import "BILayoutInflaterWatcher.h"


@implementation ButtonsAndLabelsViewController {

    BILayoutInflaterWatcher *_watcher;
}

- (void)loadView {
    [super loadView];
    _watcher = [BILayoutInflaterWatcher watchingInflaterForLayout:@"ButtonsAndLabels"];
    [_watcher fillViewOfController:self];
}

@end