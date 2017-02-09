//
//  UIScrollView+HeadImageScale.m
//  HeadImageScale
//
//  Created by eluying on 2017/2/9.
//  Copyright © 2017年 com.edu.info. All rights reserved.
//

#import "UIScrollView+HeadImageScale.h"
#import <objc/runtime.h>

#define KeyPath(objc,keyPath) @(((void)objc.keyPath,#keyPath))

@interface NSObject (MethodSwizzling)

+ (void)swizzleInstanceSelector:(SEL)origSelector
                   swizzleSelector:(SEL)swizzleSelector;

@end

@implementation NSObject (MethodSwizzling)

+ (void)swizzleInstanceSelector:(SEL)origSelector
                   swizzleSelector:(SEL)swizzleSelector {
    
    Method origMethod = class_getInstanceMethod(self, origSelector);
    Method swizzleMethod = class_getInstanceMethod(self, swizzleSelector);
    

    BOOL isAdd = class_addMethod(self, origSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    
    if (!isAdd) {
        method_exchangeImplementations(origMethod, swizzleMethod);
    }
    else {
        class_replaceMethod(self, swizzleSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
}

@end


static char HeaderImageViewKey;
static char HeaderImageViewHeightKey;
static char IsInitialKey;

static const CGFloat OriImageH = 200.f;

@implementation UIScrollView (HeadImageScale)

+ (void)load {
    [self swizzleInstanceSelector:@selector(setTableHeaderView:) swizzleSelector:@selector(setCuTableHeaderView:)];
}

- (void)dealloc {
    if (self.isInitial) {
        [self removeObserver:self forKeyPath:KeyPath(self, contentOffset)];
    }
}

#pragma mark
- (void)setCuTableHeaderView:(UIView *)tableHeaderView {
    if (![self isMemberOfClass:[UITableView class]]) return;
    
    //setTableHeaderView
    [self setCuTableHeaderView:tableHeaderView];
    
    UITableView *tableView = (UITableView *)self;
    self.headerScaleImageHeight = tableView.tableHeaderView.frame.size.height;
}

#pragma mark - private methods
- (void)setupHeaderImageView
{
    [self setupHeaderImageViewFrame];
    
    // KVO监听偏移量，修改头部imageView的frame
    if (self.isInitial == NO) {
        [self addObserver:self forKeyPath:KeyPath(self, contentOffset) options:NSKeyValueObservingOptionNew context:nil];
        self.isInitial = YES;
    }
}

- (void)setupHeaderImageViewFrame {
    self.headerImageView.frame = CGRectMake(0 , 0, self.bounds.size.width , self.headerScaleImageHeight);
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    // 获取当前偏移量
    CGFloat offsetY = self.contentOffset.y;
    
    if (offsetY < 0) {
        self.headerImageView.frame = CGRectMake(offsetY, offsetY, self.bounds.size.width - offsetY * 2, self.headerScaleImageHeight - offsetY);
    } else {
        self.headerImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.headerScaleImageHeight);
    }
}

#pragma mark - getter & setter
- (UIImage *)headerScaleImage {
    return self.headerImageView.image;
}

- (void)setHeaderScaleImage:(UIImage *)headerScaleImage {
    self.headerImageView.image = headerScaleImage;
    
    [self setupHeaderImageView];
}


- (CGFloat)headerScaleImageHeight {
    CGFloat headerImageHeight = [objc_getAssociatedObject(self, &HeaderImageViewHeightKey) floatValue];
    return headerImageHeight == 0 ? OriImageH : headerImageHeight;
}
- (void)setHeaderScaleImageHeight:(CGFloat)headerScaleImageHeight {
    objc_setAssociatedObject(self, &HeaderImageViewHeightKey, @(headerScaleImageHeight),OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self setupHeaderImageViewFrame];
}


- (BOOL)isInitial {
    return [objc_getAssociatedObject(self, &IsInitialKey) boolValue];
}

- (void)setIsInitial:(BOOL)isInitial {
    objc_setAssociatedObject(self, &IsInitialKey, @(isInitial), OBJC_ASSOCIATION_ASSIGN);
}


- (UIImageView *)headerImageView {
    UIImageView *imageView = objc_getAssociatedObject(self, &HeaderImageViewKey);
    
    if (imageView == nil) {
        imageView = [[UIImageView alloc] init];
        
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self insertSubview:imageView atIndex:0];
        
        objc_setAssociatedObject(self, &HeaderImageViewKey, imageView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return imageView;
}

@end
