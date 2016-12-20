//
//  ViewController.m
//  LYMImagesPickerViewDemo
//
//  Created by peter on 2016/12/20.
//  Copyright © 2016年 peter. All rights reserved.
//

#import "ViewController.h"
#import "LYMImagesPickerView.h"
#import <JFImagePicker/JFImagePickerController.h>
#import <JFImagePicker/JFImageGroupTableViewController.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <ImageIO/ImageIO.h>

@interface ViewController () <LYMImagesPickerViewDelegate>
@property (nonatomic, strong) LYMImagesPickerView *imagePickerView;
@property (nonatomic, strong) NSMutableArray *imagesMArray;
@property (nonatomic, assign) CGFloat imageWH;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat edgeMargin = 10.f;
    CGFloat cellMargin = 10.f;
    self.imageWH = floor(([UIScreen mainScreen].bounds.size.width - edgeMargin * 2 - cellMargin * 2) / 3);
    
    [self.view addSubview:self.imagePickerView];
}

- (void)imagePickerDidFinished:(JFImagePickerController *)picker{
    [self imagePickerDidCancel:picker];
    
    // 获取图片名称集合,图片存入库
    NSMutableArray *photoMArr = @[].mutableCopy;
    for (ALAsset *asset in picker.assets) {
        NSData *imageData = UIImagePNGRepresentation([self thumbnailForAsset:asset maxPixelSize:900]);
        [photoMArr addObject:[[UIImage alloc] initWithData:imageData]];
        
    }
    [self.imagesMArray addObjectsFromArray:photoMArr];
    [self updatePickerViewBounds];
    
    // 清除缓存图片
    [JFImagePickerController clear];
}
- (void)viewDidClickAdd:(LYMImagesPickerView *)pickerView index:(NSInteger)index {
    if (index >= self.imagesMArray.count) {
        JFImageGroupTableViewController *groupVC = [JFImageGroupTableViewController new];
        JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:groupVC];
        picker.pickerDelegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
- (void)viewDidClickDelete:(LYMImagesPickerView *)pickerView index:(NSInteger)index {
    [self.imagesMArray removeObjectAtIndex:index];
    [self updatePickerViewBounds];
}
- (void)updatePickerViewBounds {
    CGFloat imagesViewH = 0;
    NSInteger count = self.imagesMArray.count;
    if (count < 3) {
        imagesViewH = _imageWH + 10 * 2;
    } else if (count >= 3 && count < 6) {
        imagesViewH = _imageWH * 2 + 10 * 3;
    } else {
        imagesViewH = _imageWH * 3 + 10 * 4;
    }
    imagesViewH += 20;
    
    CGRect bottomViewRect = self.imagePickerView.frame;
    bottomViewRect.size.height = imagesViewH;
    self.imagePickerView.frame = bottomViewRect;
    
    self.imagePickerView.images = self.imagesMArray;
}

- (void)imagePickerDidCancel:(JFImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
static size_t getAssetBytesCallback(void *info, void *buffer, off_t position, size_t count) {
    ALAssetRepresentation *rep = (__bridge id)info;
    
    NSError *error = nil;
    size_t countRead = [rep getBytes:(uint8_t *)buffer fromOffset:position length:count error:&error];
    
    if (countRead == 0 && error) {
        // We have no way of passing this info back to the caller, so we log it, at least.
    }
    
    return countRead;
}

static void releaseAssetCallback(void *info) {
    // The info here is an ALAssetRepresentation which we CFRetain in thumbnailForAsset:maxPixelSize:.
    // This release balances that retain.
    CFRelease(info);
}

// Returns a UIImage for the given asset, with size length at most the passed size.
// The resulting UIImage will be already rotated to UIImageOrientationUp, so its CGImageRef
// can be used directly without additional rotation handling.
// This is done synchronously, so you should call this method on a background queue/thread.
- (UIImage *)thumbnailForAsset:(ALAsset *)asset maxPixelSize:(NSUInteger)size {
    NSParameterAssert(asset != nil);
    NSParameterAssert(size > 0);
    
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    
    CGDataProviderDirectCallbacks callbacks = {
        .version = 0,
        .getBytePointer = NULL,
        .releaseBytePointer = NULL,
        .getBytesAtPosition = getAssetBytesCallback,
        .releaseInfo = releaseAssetCallback,
    };
    
    CGDataProviderRef provider = CGDataProviderCreateDirect((void *)CFBridgingRetain(rep), [rep size], &callbacks);
    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);
    
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef) @{
                                                                                                      (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                                                                      (NSString *)kCGImageSourceThumbnailMaxPixelSize : [NSNumber numberWithUnsignedInteger:size],
                                                                                                      (NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                                                                      });
    CFRelease(source);
    CFRelease(provider);
    
    if (!imageRef) {
        return nil;
    }
    
    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    
    return toReturn;
}

- (LYMImagesPickerView *)imagePickerView {
    if (!_imagePickerView) {
        _imagePickerView = [[LYMImagesPickerView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)];
        _imagePickerView.maxImagesCount = 9;
        _imagePickerView.images = self.imagesMArray;
        _imagePickerView.delegate = self;
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
