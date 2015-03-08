#import "ExamplesViewController.h"
#import "BILayoutLoader.h"
#import "BIEXTScope.h"
#import "ButtonsAndLabelsViewController.h"
#import "TableSampleViewController.h"
#import "ScrollSampleViewController.h"
#import "SegmentsViewController.h"
#import "CollectionSampleController.h"

@protocol Examples <BIInflatedViewHelper>
- (UIButton *)buttonsAndLabels;

- (UIButton *)tableSample;

- (UIButton *)scrollSample;

- (UIButton *)segmentSample;

- (UIButton *)collectionSample;
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
    [viewHelper.scrollSample addTarget:self action:@selector(openScrollSample) forControlEvents:UIControlEventTouchUpInside];
    [viewHelper.segmentSample addTarget:self action:@selector(openSegmentSample) forControlEvents:UIControlEventTouchUpInside];
    [viewHelper.collectionSample addTarget:self action:@selector(openCollectionSample) forControlEvents:UIControlEventTouchUpInside];
}

- (void)openCollectionSample {
    [self.navigationController pushViewController:CollectionSampleController.new animated:YES];
}

- (void)openSegmentSample {
    [self.navigationController pushViewController:SegmentsViewController.new animated:YES];
}

- (void)openTableSample {
    [self.navigationController pushViewController:TableSampleViewController.new animated:YES];
}

- (void)openButtonsAndLabels {
    [self.navigationController pushViewController:ButtonsAndLabelsViewController.new animated:YES];
}

- (void)openScrollSample {
    [self.navigationController pushViewController:ScrollSampleViewController.new animated:YES];
}

@end