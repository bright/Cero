#import "TableSampleViewController.h"
#import "BILayoutLoader.h"
#import "BIInflatedViewHelper.h"


@protocol TableSampleCellContent <BIInflatedViewHelper>
- (UILabel *)label;
@end

@implementation TableSampleViewController {
    BILayoutLoader *_layoutLoader;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _layoutLoader = BILayoutLoader.new;
        self.title = @"Table Cell Layouts";
    }

    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1000;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *layoutName = [NSString stringWithFormat:@"TableSampleCellContent_%@", @(indexPath.item % 3)];
    return [_layoutLoader fillTableCellContent:tableView layout:layoutName loaded:^(NSObject <TableSampleCellContent> *helper) {
        helper.label.text = [NSString stringWithFormat:@"Cell no %@", @(indexPath.item)];
    }];
}


@end