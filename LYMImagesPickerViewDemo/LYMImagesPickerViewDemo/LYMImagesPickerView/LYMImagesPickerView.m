//
//  LYMImagesPickerView.m
//  LYMImagesPickerViewDemo
//
//  Created by peter on 2016/12/20.
//  Copyright © 2016年 peter. All rights reserved.
//

#import "LYMImagesPickerView.h"
#import "LYMImageCollectionViewCell.h"

@interface LYMImagesPickerView()<UICollectionViewDataSource, UICollectionViewDelegate, LYMImageCollectionViewCellDelegate> {
    BOOL _hasAdd; // YES表示有加号，NO表示没有加号
}
@property (nonatomic, strong) UICollectionView *imagesCollectionView;

@end

@implementation LYMImagesPickerView

static NSString * const kLYMImageCollectionViewCellId = @"LYMImageCollectionViewCell";

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 设置背景色
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat edgeMargin = 10.f;
        CGFloat cellMargin = 5;
        CGFloat insetTopAndBotton = 10.f;
        CGFloat cellW = floor(([UIScreen mainScreen].bounds.size.width - edgeMargin * 2 - cellMargin * 4) / 3);
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = cellMargin;
        layout.minimumInteritemSpacing = cellMargin;
        layout.itemSize = CGSizeMake(cellW, cellW);
        layout.sectionInset = UIEdgeInsetsMake(insetTopAndBotton, edgeMargin, insetTopAndBotton, edgeMargin);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UICollectionView *imagesCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        
        [imagesCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LYMImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kLYMImageCollectionViewCellId];
        
        imagesCollectionView.dataSource = self;
        imagesCollectionView.delegate = self;
        imagesCollectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:imagesCollectionView];
        
        self.imagesCollectionView = imagesCollectionView;
    }
    return self;
}

- (void)setImages:(NSMutableArray *)images {
    if (!images) return;
    
    if (images.count > _maxImagesCount) {
        [images removeObjectsInRange:NSMakeRange(_maxImagesCount, images.count - _maxImagesCount)];
    }
    if (!_images) {
        _images = [NSMutableArray array];
    }
    [_images removeAllObjects];
    [_images addObjectsFromArray:images];
    
    if (images.count < _maxImagesCount) {
        UIImage *addImage = [UIImage imageNamed:@"add"];
        [_images addObject:addImage];
        _hasAdd = YES;
    } else {
        _hasAdd = NO;
    }
    [self.imagesCollectionView reloadData];
    
    self.imagesCollectionView.frame = self.bounds;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LYMImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLYMImageCollectionViewCellId forIndexPath:indexPath];
    UIImage *image = self.images[indexPath.row];
    if (_hasAdd && indexPath.row == self.images.count - 1) {
        [cell setImage:image isAdd:YES];
    } else {
        [cell setImage:image isAdd:NO];
    }
    cell.delegate = self;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate viewDidClickAdd:self index:indexPath.row];
}

#pragma mark 移动
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    UIImage *image = self.images[fromIndexPath.item];
    [self.images removeObjectAtIndex:fromIndexPath.item];
    [self.images insertObject:image atIndex:toIndexPath.item];
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_hasAdd && indexPath.row == self.images.count - 1) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    if (_hasAdd && fromIndexPath.row == self.images.count - 1) {
        return NO;
    } else {
        return YES;
    }
}

- (void)cellDidClickDelete:(LYMImageCollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.imagesCollectionView indexPathForCell:cell];
    [_delegate viewDidClickDelete:self index:indexPath.row];
}

@end
