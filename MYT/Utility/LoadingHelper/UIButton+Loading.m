//
//  UIButton+Loading.m
//  Sunshine
//
//  Created by Qingqing on 15/10/20.
//  Copyright (c) 2015年 Qingqing. All rights reserved.
//

#import "UIButton+Loading.h"

@implementation UIButton (Loading)

-(void)qq_setButtonImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    /* 加载时指示菊花 by qingqing*/
    __block UIActivityIndicatorView* loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadingIndicator.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    loadingIndicator.hidesWhenStopped = YES;
    [self addSubview:loadingIndicator];
    [loadingIndicator startAnimating];
    /*        end         */
    [self sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [loadingIndicator stopAnimating];
        [loadingIndicator removeFromSuperview];
        loadingIndicator = nil;
    }];
}

@end
