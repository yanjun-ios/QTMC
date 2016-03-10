//
//  UIViewController+Helper.m
//  HXZXG
//
//  Created by Qingqing on 15/11/11.
//  Copyright (c) 2015年 红星装修公. All rights reserved.
//

#import "UIViewController+Helper.h"
#import <objc/runtime.h>

@implementation UIViewController (Helper)

#pragma mark Public Method

-(void)qq_setNavigationBarHidden:(BOOL)isHidden{
    NSAssert(self.navigationController, @"self.navigationController no exit!");
    
    objc_setAssociatedObject(self.navigationController.navigationBar, @"backUpImg", self.navigationController.navigationBar.backIndicatorImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (isHidden) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = YES;//导航栏全透明
    }else{
        UIImage* backUpImg = objc_getAssociatedObject(self.navigationController.navigationBar, @"backUpImg");
        [self.navigationController.navigationBar setBackgroundImage:backUpImg forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = backUpImg;
        self.navigationController.navigationBar.translucent = NO;//导航栏全透明
    }
}

-(void)qq_performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        block();
    });
}

-(void)qq_performSVHUDBlock:(void(^)())block{
    [self qq_performBlock:block afterDelay:0.15];
}
@end
