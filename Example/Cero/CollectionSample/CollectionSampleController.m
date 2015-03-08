#import <Cero/BILayoutLoader.h>
#import <Cero/BIInflatedViewHelper.h>
#import "CollectionSampleController.h"

@protocol CollectionCellContent <BIInflatedViewHelper>
- (UIImageView *)logo;
@end

@implementation CollectionSampleController {
    BILayoutLoader *_layoutLoader;
}
- (instancetype)init {
    self = [super initWithCollectionViewLayout:UICollectionViewFlowLayout.new];
    if (self) {
        self.title = @"Collection";
        _layoutLoader = BILayoutLoader.new;
    }

    return self;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor grayColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionSampleCell_0"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionSampleCell_1"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionSampleCell_2"];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *layoutName = [NSString stringWithFormat:@"CollectionSampleCell_%@", @(indexPath.section % 3)];
    __typeof(self) __weak bself = self;
    return [_layoutLoader fillCollectionCellContent:collectionView layout:layoutName indexPath:indexPath loaded:^(NSObject <CollectionCellContent> *helper) {
        __typeof(self) __strong self = bself;
//        helper.logo.tintColor = [self colorForIndexPath:indexPath];
        helper.root.backgroundColor = [self colorForIndexPath:indexPath];
    }];
}

- (UIColor *)colorForIndexPath:(NSIndexPath *)path {
    NSInteger rowValue = path.row + 1;
    NSInteger sectionValue = path.section + 1;
    float rowMax = 5.f;
    float sectionMax = 100.f;
    UIColor *color = [UIColor colorWithRed:rowValue * 255 / rowMax
                                     green:sectionValue * 255 / sectionMax
                                      blue:(rowValue * sectionValue) * 255 / sectionMax * rowMax
                                     alpha:1];
    return color;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arc4random() % 5 + 1;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 100;
}


@end