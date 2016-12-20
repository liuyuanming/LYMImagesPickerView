//
//  LYMImageCollectionViewCell.m
//  LYMImagesPickerViewDemo
//
//  Created by peter on 2016/12/20.
//  Copyright © 2016年 peter. All rights reserved.
//

#import "LYMImageCollectionViewCell.h"

@interface LYMImageCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)delete:(UIButton *)sender;

@end

@implementation LYMImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImage:(UIImage *)image isAdd:(BOOL)isAdd {
    if (!image) return;
    self.image = image;
    self.isAdd = isAdd;
    
    [_imageView setImage:self.image];
    
    if (self.isAdd) {
        _deleteButton.hidden = YES;
    } else {
        _deleteButton.hidden = NO;
    }
}

- (IBAction)delete:(UIButton *)sender {
    [_delegate cellDidClickDelete:self];
}
@end
