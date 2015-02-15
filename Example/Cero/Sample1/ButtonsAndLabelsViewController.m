#import "ButtonsAndLabelsViewController.h"
#import "BILayoutLoader.h"


@implementation ButtonsAndLabelsViewController {

    BILayoutLoader *_loader;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _loader = BILayoutLoader.new;
        self.title = @"Buttons and Labels";
    }

    return self;
}


- (void)loadView {
    [super loadView];
    [_loader fillViewOfController:self layout:@"ButtonsAndLabels"];
}

@end