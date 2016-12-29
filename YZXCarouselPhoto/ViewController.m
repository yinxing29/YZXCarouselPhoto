//
//  ViewController.m
//  YZXCarouselPhoto
//
//  Created by 尹星 on 2016/12/28.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import "ViewController.h"
#import "YZXCarouselPhotoView.h"

@interface ViewController ()

@property (nonatomic, strong) YZXCarouselPhotoView                    *garouselPhotoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"轮播图";
    self.view.backgroundColor = [UIColor grayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.garouselPhotoView.imageName = @[@"c_img_1.png",@"c_img_2.png",@"c_img_3.png",@"c_img_4.png",@"c_img_5.png",@"c_img_6.png"];
    self.garouselPhotoView.currentPageIndicatorTintColor = [UIColor yellowColor];
    self.garouselPhotoView.pageIndicatorTintColor = [UIColor purpleColor];
    self.garouselPhotoView.imageContentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.garouselPhotoView];
}

#pragma mark - 初始化
- (YZXCarouselPhotoView *)garouselPhotoView
{
    if (!_garouselPhotoView) {
        _garouselPhotoView = [[YZXCarouselPhotoView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
        _garouselPhotoView.center = self.view.center;
        _garouselPhotoView.backgroundColor = [UIColor orangeColor];
    }
    return _garouselPhotoView;
}

@end
