//
//  Utility.h
//  HXZXG
//
//  Created by Qingqing on 15/11/5.
//  Copyright (c) 2015年 红星装修公. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject/* 工具类只做通用的最简单的操作，复杂的通用工具应单独构建相应类去处理 */

#pragma mark Proprety
@property (nonatomic ,assign) BOOL firstStart;

/**
 *  工具类单例
 */
+ (Utility *)sharedInstance;

/**
 *  判断字符串是否是数字
 *
 *  @param string 待扫描字符串
 *
 *  @return default
 */
- (BOOL)isPureInt:(NSString*)string;

/**
 *  urlEncode编码字符串
 *
 *  @param oriStr 待编码的字符的字符串
 *
 *  @return 编码后的字符串
 */
- (NSString *)urlEncode:(NSString*)oriStr;

- (NSString *)urlEncodeValue:(NSString *)str;


-(CGSize)getStringSize:(NSString*)string boundsSize:(CGSize)size fontSize:(int)fontSize;

//设置视图圆角
-(void)setLayerView:(UIView*)view borderW:(CGFloat)W borderColor:(UIColor*)color radius:(CGFloat)r;

@end
