//
//  Y_NetRequestManager.m
//  MYT
//
//  Created by 熊凯 on 16/1/9.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import "Y_NetRequestManager.h"
static Y_NetRequestManager * sharedInstance = nil;
@implementation Y_NetRequestManager
+ (Y_NetRequestManager *)sharedInstance{
    if (sharedInstance == nil) {
        sharedInstance = [[Y_NetRequestManager alloc] init];
    }
    return sharedInstance;
}

-(NSDictionary*)getClientList:(NSDictionary*) paraDic
{
    __block NSDictionary* dic;
    
    [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingString:@"yd/getAppUserList.action"] parameters:paraDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        dic=(NSDictionary*)responseObject;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self.superclass qq_performSVHUDBlock:^{
            [SVProgressHUD showErrorWithStatus:@"数据请求错误，请检查网络！"];
        }];
        
    }];
    NSLog(@"我在这里加了一行代码，看到请回复！");
    NSLog(@"ZYX");
    NSLog(@"");
    return dic;
}

-(NSDictionary*)getteamDataByYear:(NSString*)year beginMonth:(NSString*)bengin endMonth:(NSString*)end teamId:(NSString*)teamid userId:(NSString*)userid
{
    NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
    [parDic setValue:year forKey:@"year"];
    [parDic setValue:bengin forKey:@"monthS"];
     [parDic setValue:end forKey:@"monthE"];
    [parDic setValue:teamid forKey:@"depId"];
    [parDic setValue:userid forKey:@"userid"];
   __block NSDictionary* jsonDic;
    [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingPathComponent:@"yd/getDepStaffList.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        jsonDic = (NSDictionary*)responseObject;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
            [SVProgressHUD showErrorWithStatus:@"数据请求错误，请检查网络！"];
    }];
    return jsonDic;
}

@end
