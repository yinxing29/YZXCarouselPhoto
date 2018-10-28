//
//  YZXCarouselPhotoView.m
//  YZXCarouselPhoto
//
//  Created by 尹星 on 2016/12/28.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import "YZXCarouselPhotoView.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
        self.shufflingFlag = YES;
        [self p_initView];
    }
    return self;
}

//布局
- (void)p_initView
{
    [self addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.centerImageView];
    [self.scrollView addSubview:self.rightImageView];
    
    [self addSubview:self.pageControl];
}

//赋值
- (void)p_initData
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
    
    if (self.photoNumber == 0) {
        return;
    }
    
    //中间图片起始下标
    self.centerPage = 0;
    //右边图片起始下标
    self.rightPage = (self.photoNumber - 1 < 1)?0:1;
    //左边图片起始下标
    self.leftPage = self.photoNumber - 1;
    
    //设置imageView.image
    [self p_showImage];
    
    self.pageControl.numberOfPages = self.photoNumber;
    self.pageControl.currentPage = self.centerPage;
    
    if (self.shufflingFlag) {
        [self p_createTimer];
    }
}

//显示图片
- (void)p_showImage
{
    if (self.imageUrl) {
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl[self.leftPage]]];
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl[self.centerPage]]];
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl[self.rightPage]]];
    }else if (self.imageName) {
        self.leftImageView.image = [UIImage imageNamed:self.imageName[self.leftPage]];
        self.centerImageView.image = [UIImage imageNamed:self.imageName[self.centerPage]];
        self.rightImageView.image = [UIImage imageNamed:self.imageName[self.rightPage]];
    }
}

//自动轮播
- (void)timerEvent
{
    [self.scrollView setContentOffset:CGPointMake(self_width * 2, 0) animated:YES];
}

//pageControl点击事件
- (void)pageControlPressed:(UIPageControl *)sender
{
    NSLog(@"%ld",sender.currentPage);
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = self.centerPage;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.leftPage = self.leftPage + 1 > self.photoNumber - 1?0:self.leftPage + 1;
    self.centerPage = self.centerPage + 1 > self.photoNumber - 1?0:self.centerPage + 1;
    self.rightPage = self.rightPage + 1 > self.photoNumber - 1?0:self.rightPage + 1;
    
    [self p_showImage];
    self.scrollView.contentOffset = CGPointMake(self_width, 0);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self p_removeTimer];
    //防止过快滑动c造成数据更新不过来，在滑动结束时打开交互
    self.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.photoNumber == 0) {
        return;
    }
    
    if (self.shufflingFlag) {
        [self p_createTimer];
    }
    
    //右滑(当各下标 + 1大于总数量时，设置为0)
    if (self.scrollView.contentOffset.x > self_width) {
        self.leftPage = self.leftPage + 1 > self.photoNumber - 1?0:self.leftPage + 1;
        self.centerPage = self.centerPage + 1 > self.photoNumber - 1?0:self.centerPage + 1;
        self.rightPage = self.rightPage + 1 > self.photoNumber - 1?0:self.rightPage + 1;
    }else if (self.scrollView.contentOffset.x < self_width) {//左滑(当各下标 - 1小于0时，设置为总数 - 1)
        self.leftPage = self.leftPage - 1 < 0?self.photoNumber - 1:self.leftPage - 1;
        self.centerPage = self.centerPage - 1 < 0?self.photoNumber - 1:self.centerPage - 1;
        self.rightPage = self.rightPage - 1 < 0?self.photoNumber - 1:self.rightPage - 1;
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    [self p_showImage];
    self.scrollView.contentOffset = CGPointMake(self_width, 0);
    
    self.userInteractionEnabled = YES;
}

- (void)p_createTimer
{
    [self p_removeTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)p_removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
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

#pragma mark - setter
- (void)setImageUrl:(NSArray *)imageUrl
{
    _imageUrl = imageUrl;
    [self p_initData];
}

- (void)setImageName:(NSArray *)imageName
{
    _imageName = imageName;
    [self p_initData];
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
}

- (void)setImageContentMode:(UIViewContentMode)imageContentMode
{
    _imageContentMode = imageContentMode;
    self.leftImageView.contentMode = _imageContentMode;
    self.centerImageView.contentMode = _imageContentMode;
    self.rightImageView.contentMode = _imageContentMode;
}

- (void)setShufflingFlag:(BOOL)shufflingFlag
{
    _shufflingFlag = shufflingFlag;
    if (!_shufflingFlag) {
        [self p_removeTimer];
    }
}


@end
