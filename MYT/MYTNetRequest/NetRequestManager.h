//
//  NetRequestManager.h
//  MYT
//
//  Created by 熊凯 on 16/1/9.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetRequestManager : NSObject
@property(nonatomic,retain)NSString* clientId;//单例传值，客户管理页面点击查看详情的时候将客户id传值给tabbar
@property(nonatomic,retain)NSDictionary* AREALIST;
@property(nonatomic,assign)int FROMDECK;
/**
 *  工具类单例
 */
+ (NetRequestManager *)sharedInstance;
-(NSString*)DataToJsonString:(id)object;
-(void)getArelist;
@end
