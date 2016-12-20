//
//  LYMImageCollectionViewCell.h
//  LYMImagesPickerViewDemo
//
//  Created by peter on 2016/12/20.
//  Copyright © 2016年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYMImageCollectionViewCell;

@protocol LYMImageCollectionViewCellDelegate <NSObject>
- (void)cellDidClickDelete:(LYMImageCollectionViewCell *)cell;

@end

@interface LYMImageCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) id<LYMImageCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL isAdd;

- (void)setImage:(UIImage *)image isAdd:(BOOL)isAdd;

@end
