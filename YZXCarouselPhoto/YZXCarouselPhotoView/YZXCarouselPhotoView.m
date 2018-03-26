//
//  YZXCarouselPhotoView.m
//  YZXCarouselPhoto
//
//  Created by 尹星 on 2016/12/28.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import "YZXCarouselPhotoView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "UIImage+WebP.h"
#import "UIImage+MultiFormat.h"

#define self_width self.bounds.size.width
#define self_height self.bounds.size.height

@interface YZXCarouselPhotoView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView                    *scrollView;

/**
 轮播图左边imageView
 */
@property (nonatomic, strong) UIImageView                    *leftImageView;

/**
 轮播图中间imageView
 */
@property (nonatomic, strong) UIImageView                    *centerImageView;

/**
 轮播图右边imageView
 */
@property (nonatomic, strong) UIImageView                    *rightImageView;

/**
 轮播图左边取值下标
 */
@property (nonatomic, assign) NSInteger                    leftPage;

/**
 轮播图中间取值下标
 */
@property (nonatomic, assign) NSInteger                    centerPage;

/**
 轮播图右边取值下标
 */
@property (nonatomic, assign) NSInteger                    rightPage;

/**
 图片总数量
 */
@property (nonatomic, assign) NSInteger                    photoNumber;

@property (nonatomic, strong) UIPageControl                *pageControl;

@property (nonatomic, strong) NSTimer                      *timer;

@end

@implementation YZXCarouselPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeUserInterface];
    }
    return self;
}

//布局
- (void)initializeUserInterface
{
    self.timer.fireDate = [NSDate distantFuture];
    
    [self addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.centerImageView];
    [self.scrollView addSubview:self.rightImageView];
    
    [self addSubview:self.pageControl];
}

//赋值
- (void)toViewTheAssignment
{
    //如果同时传入了两种数组则结束布局
    if (self.imageUrl && self.imageName) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"数据源传入重复，请检查传入的数据源" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alertC animated:YES completion:nil];
        return;
    }
    //获取轮播图总数量
    self.photoNumber = self.imageUrl?self.imageUrl.count:self.imageName.count;
    //中间图片起始下标
    self.centerPage = 0;
    //右边图片起始下标
    self.rightPage = 1>self.photoNumber - 1?0:1;
    //左边图片起始下标
    self.leftPage = self.imageUrl?self.photoNumber - 1:self.photoNumber - 1;
    
    if (self.photoNumber == 0) {
        return;
    }
    
    //设置imageView.image
    [self addTheImageData];
    
    self.pageControl.numberOfPages = self.photoNumber;
    self.pageControl.currentPage = self.centerPage;
}

//显示图片
- (void)addTheImageData
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    
    [self.leftImageView.layer addAnimation:transition forKey:nil];
    [self.centerImageView.layer addAnimation:transition forKey:nil];
    [self.rightImageView.layer addAnimation:transition forKey:nil];
    
    if (self.imageUrl) {
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl[self.leftPage]] placeholderImage:[UIImage imageNamed:@""]];
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl[self.centerPage]] placeholderImage:[UIImage imageNamed:@""]];
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl[self.rightPage]] placeholderImage:[UIImage imageNamed:@""]];
    }else if (self.imageName) {
        self.leftImageView.image = [UIImage imageNamed:self.imageName[self.leftPage]];
        self.centerImageView.image = [UIImage imageNamed:self.imageName[self.centerPage]];
        self.rightImageView.image = [UIImage imageNamed:self.imageName[self.rightPage]];
    }
    
    self.pageControl.currentPage = self.centerPage;
}

//自动轮播
- (void)timerEvent
{
    self.leftPage = self.leftPage + 1 > self.photoNumber - 1?0:self.leftPage + 1;
    self.centerPage = self.centerPage + 1 > self.photoNumber - 1?0:self.centerPage + 1;
    self.rightPage = self.rightPage + 1 > self.photoNumber - 1?0:self.rightPage + 1;
    [self addTheImageData];
}

//pageControl点击事件
- (void)pageControlPressed:(UIPageControl *)sender
{
    NSLog(@"%ld",sender.currentPage);
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.photoNumber == 0) {
        return;
    }
    //右滑(当各下标 + 1大于总数量时，设置为0)
    if (scrollView.contentOffset.x > self_width) {
        self.leftPage = self.leftPage + 1 > self.photoNumber - 1?0:self.leftPage + 1;
        self.centerPage = self.centerPage + 1 > self.photoNumber - 1?0:self.centerPage + 1;
        self.rightPage = self.rightPage + 1 > self.photoNumber - 1?0:self.rightPage + 1;
        [self addTheImageData];
    }else if (scrollView.contentOffset.x < self_width) {//左滑(当各下标 - 1小于0时，设置为总数 - 1)
        self.leftPage = self.leftPage - 1 < 0?self.photoNumber - 1:self.leftPage - 1;
        self.centerPage = self.centerPage - 1 < 0?self.photoNumber - 1:self.centerPage - 1;
        self.rightPage = self.rightPage - 1 < 0?self.photoNumber - 1:self.rightPage - 1;
        [self addTheImageData];
    }
    //重新设置scrollview的contentOffset
    scrollView.contentOffset = CGPointMake(self_width, 0);
}

#pragma mark - 初始化
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self_width, self_height)];
        _scrollView.contentSize = CGSizeMake(self_width * 3.0, 0);
        _scrollView.contentOffset = CGPointMake(self_width, 0);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self_width, 30)];
        _pageControl.center = CGPointMake(self_width / 2.0, self_height - 30.0);
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    }
    return _pageControl;
}

- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self_width, self_height)];
    }
    return _leftImageView;
}

- (UIImageView *)centerImageView
{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self_width, 0, self_width, self_height)];
    }
    return _centerImageView;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self_width * 2, 0, self_width, self_height)];
    }
    return _rightImageView;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    }
    return _timer;
}

#pragma mark - setter
- (void)setImageUrl:(NSArray *)imageUrl
{
    if (_imageUrl != imageUrl) {
        _imageUrl = imageUrl;
    }
    [self toViewTheAssignment];
}

- (void)setImageName:(NSArray *)imageName
{
    if (_imageName != imageName) {
        _imageName = imageName;
    }
    [self toViewTheAssignment];
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    if (_currentPageIndicatorTintColor != currentPageIndicatorTintColor) {
        _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    }
    self.pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    if (_pageIndicatorTintColor != pageIndicatorTintColor) {
        _pageIndicatorTintColor = pageIndicatorTintColor;
    }
    self.pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
}

- (void)setImageContentMode:(UIViewContentMode)imageContentMode
{
    if (_imageContentMode != imageContentMode) {
        _imageContentMode = imageContentMode;
    }
    self.leftImageView.contentMode = _imageContentMode;
    self.centerImageView.contentMode = _imageContentMode;
    self.rightImageView.contentMode = _imageContentMode;
}

- (void)setShufflingFlag:(BOOL)shufflingFlag
{
    if (_shufflingFlag != shufflingFlag) {
        _shufflingFlag = shufflingFlag;
    }
    if (_shufflingFlag) {
        __weak typeof(self) weak_self = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weak_self.timer.fireDate = [NSDate distantPast];
        });
    }
}


@end
