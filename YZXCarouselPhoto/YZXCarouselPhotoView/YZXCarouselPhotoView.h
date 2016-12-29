//
//  YZXCarouselPhotoView.h
//  YZXCarouselPhoto
//
//  Created by 尹星 on 2016/12/28.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZXCarouselPhotoView : UIView

//传参时，只能选择传imageUrl和iamgeName中的一个

/**
 传入网址字符串数组
 */
@property (nonatomic, strong) NSArray                    *imageUrl;

/**
 传入本地字符串数组
 */
@property (nonatomic, strong) NSArray                    *imageName;

/**
 pageControl圆点背景颜色
 */
@property (nonatomic, strong) UIColor                    *pageIndicatorTintColor;

/**
 pageControl圆点选中颜色
 */
@property (nonatomic, strong) UIColor                    *currentPageIndicatorTintColor;

/**
 图片的contentMode
 */
@property (nonatomic, assign) UIViewContentMode          imageContentMode;

@end
