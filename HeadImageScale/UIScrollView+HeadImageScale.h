//
//  UIScrollView+HeadImageScale.h
//  HeadImageScale
//
//  Created by eluying on 2017/2/9.
//  Copyright © 2017年 com.edu.info. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HeadImageScale)

/// 头部缩放视图图片
@property (nonatomic, strong) UIImage *headerScaleImage;

/// 头部缩放视图图片高度
@property (nonatomic, assign) CGFloat headerScaleImageHeight;

@end
