#import "ExamplesViewController.h"
#import "BILayoutLoader.h"
#import "BIEXTScope.h"
#import "ButtonsAndLabelsViewController.h"
#import "TableSampleViewController.h"

@protocol Examples <BIInflatedViewHelper>
- (UIButton *)buttonsAndLabels;

- (UIButton *)tableSample;
@end

@implementation ExamplesViewController {
    BILayoutLoader *_watcher;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Examples";
        _watcher = BILayoutLoader.new;
    }

    return self;
}

- (void)loadView {
    [super loadView];
    @weakify(self);
    [_watcher fillViewOfController:self layout:@"Examples" loaded:^(NSObject <Examples> *view) {
        @strongify(self);
        [self setupView:view];
    }];
}

- (void)setupView:(NSObject <Examples> *)viewHelper {
    [viewHelper.buttonsAndLabels addTarget:self action:@selector(openButtonsAndLabels) forControlEvents:UIControlEventTouchUpInside];
    [viewHelper.tableSample addTarget:self action:@selector(openTableSample) forControlEvents:UIControlEventTouchUpInside];
}

- (void)openTableSample {
    [self.navigationController pushViewController:TableSampleViewController.new animated:YES];
}

- (void)openButtonsAndLabels {
    [self.navigationController pushViewController:ButtonsAndLabelsViewController.new animated:YES];
}

@end