//
//  LYMImagesPickerView.h
//  LYMImagesPickerViewDemo
//
//  Created by peter on 2016/12/20.
//  Copyright © 2016年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYMImagesPickerView;

@protocol LYMImagesPickerViewDelegate <NSObject>
@optional
- (void)viewDidClickAdd:(LYMImagesPickerView *)pickerView index:(NSInteger)index;
- (void)viewDidClickDelete:(LYMImagesPickerView *)pickerView index:(NSInteger)index;

@end

/// 图片多选view
@interface LYMImagesPickerView : UIView
@property (nonatomic, assign) NSInteger maxImagesCount;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, weak) id<LYMImagesPickerViewDelegate> delegate;

@end
