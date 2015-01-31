#import "ButtonsAndLabelsViewController.h"
#import "BILayoutInflaterWatcher.h"


@implementation ButtonsAndLabelsViewController {

    BILayoutInflaterWatcher *_watcher;
}

- (void)loadView {
    [super loadView];
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"ButtonsAndLabels" ofType:@"xml"];
    _watcher = [BILayoutInflaterWatcher watcherInflaterFor:fullPath];
    [_watcher fillView:self.view];
}

@end