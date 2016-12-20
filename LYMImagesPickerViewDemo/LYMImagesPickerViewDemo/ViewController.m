//
//  ViewController.m
//  LYMImagesPickerViewDemo
//
//  Created by peter on 2016/12/20.
//  Copyright © 2016年 peter. All rights reserved.
//

#import "ViewController.h"
#import "LYMImagesPickerView.h"

@interface ViewController ()
@property (nonatomic, strong) LYMImagesPickerView *imagePickerView;
@property (nonatomic, strong) NSMutableArray *imagesMArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.imagePickerView];
}

- (LYMImagesPickerView *)imagePickerView {
    if (!_imagePickerView) {
        _imagePickerView = [[LYMImagesPickerView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)];
        _imagePickerView.maxImagesCount = 9;
        _imagePickerView.images = self.imagesMArray;
    }
    return _imagePickerView;
}
- (NSMutableArray *)imagesMArray {
    if (!_imagesMArray) {
        _imagesMArray = [NSMutableArray new];
    }
    return _imagesMArray;
}

@end
