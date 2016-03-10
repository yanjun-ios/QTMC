//
//  Y_NetRequestManager.h
//  MYT
//
//  Created by 熊凯 on 16/1/9.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Y_NetRequestManager : NSObject
/**
 *  工具类单例 这是工具类，将需要多次请求的类放到这里来
 */
+ (Y_NetRequestManager *)sharedInstance;
-(NSDictionary*)getClientList:(NSDictionary *)paraDic;
-(NSDictionary*)getteamDataByYear:(NSString*)year beginMonth:(NSString*)bengin endMonth:(NSString*)end teamId:(NSString*)teamid userId:(NSString*)userid;
@end
