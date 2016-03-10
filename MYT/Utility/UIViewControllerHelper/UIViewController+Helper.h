//
//  UIViewController+Helper.h
//  HXZXG
//
//  Created by Qingqing on 15/11/11.
//  Copyright (c) 2015年 红星装修公. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Helper)

/**
 *  hidden the navigationBar
 *
 *  @param hidden default
 */
-(void)qq_setNavigationBarHidden:(BOOL)isHidden;

/**
 *  延迟执行方法
 *
 *  @param block 被延迟执行的Block
 *  @param delay 延迟时间
 */
-(void)qq_performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay;

/**
 *  延迟执行SVProgressHUD 动画
 *  主要为了解决 SVProgressHUD 已经执行过一次后，在执行消失动画的1.5S内，
 *  再次显示 SVProgressHUD 会出现BUG 的问题
 *
 *  @param block 被延迟执行的Block
 */
-(void)qq_performSVHUDBlock:(void(^)())block;

@end
