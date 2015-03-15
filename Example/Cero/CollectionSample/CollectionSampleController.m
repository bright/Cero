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
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionSampleCell_0"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionSampleCell_1"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionSampleCell_2"];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *layoutName = [NSString stringWithFormat:@"CollectionSampleCell_%@", @(indexPath.section % 3)];
    UICollectionViewCell *cell = [_layoutLoader fillCollectionCellContent:collectionView layout:layoutName indexPath:indexPath loaded:^(NSObject <CollectionCellContent> *helper) {
    }];
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arc4random() % 5 + 1;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 100;
}


@end