#import <Cero/BILayoutLoader.h>
#import <Cero/BIInflatedViewHelper.h>
#import "SegmentsViewController.h"
#import "BIEXTScope.h"

@protocol SegmentsView <BIInflatedViewHelper>
@end

@implementation SegmentsViewController {
    BILayoutLoader *_loader;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"Segments & Cards";
        _loader = BILayoutLoader.new;
    }

    return self;
}

- (void)loadView {
    [super loadView];
    @weakify(self);
    [_loader fillViewOfController:self layout:@"Segments" loaded:^(NSObject <SegmentsView> *view) {
        @strongify(self);
        [self setupView:view];
    }];
}

- (void)setupView:(NSObject <SegmentsView> *)object {

}


@end