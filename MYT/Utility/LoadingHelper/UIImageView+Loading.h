//
//  UIImageView+Loading.h
//  Sunshine
//
//  Created by Qingqing on 15/10/20.
//  Copyright (c) 2015年 Qingqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

@interface UIImageView (Loading)

/* 扩展加载图片时显示菊花 */
-(void)qq_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
