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
    self.garouselPhotoView.imageName = @[@"c_img_1.png",@"c_img_2.png",@"c_img_3.png"];
//    self.garouselPhotoView.imageUrl = @[@"http://p5m3egx6g.bkt.clouddn.com/%E6%89%8B%E5%8A%BF%E8%A7%A3%E9%94%81.png",@"http://p5m3egx6g.bkt.clouddn.com/WechatIMG5.jpeg",@"http://p5m3egx6g.bkt.clouddn.com/wechat.png"];
    self.garouselPhotoView.currentPageIndicatorTintColor = [UIColor yellowColor];
    self.garouselPhotoView.pageIndicatorTintColor = [UIColor purpleColor];
    self.garouselPhotoView.imageContentMode = UIViewContentModeScaleAspectFit;
    self.garouselPhotoView.shufflingFlag = YES;
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
