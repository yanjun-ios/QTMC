//
//  NetRequestManager.m
//  MYT
//
//  Created by 熊凯 on 16/1/9.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import "NetRequestManager.h"
#import "QQRequestManager.h"
static NetRequestManager * sharedInstance = nil;
@implementation NetRequestManager
+ (NetRequestManager *)sharedInstance{
    if (sharedInstance == nil) {
        sharedInstance = [[NetRequestManager alloc] init];
    }
    return sharedInstance;
}

/////对象转json，返回json格式字符串
-(NSString*)DataToJsonString:(id)object
{
    
    NSString *jsonString = nil;
    NSError *error;
    NSLog(@"%@",object);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

-(void)getArelist
{
    NSMutableDictionary* parDic=[[NSMutableDictionary alloc]init];
    
    [parDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];
    [[QQRequestManager sharedRequestManager]GET:[SEVER_URL stringByAppendingString:@"yd/getAreaList.action"] parameters:parDic showHUD:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        _AREALIST=(NSDictionary*)responseObject;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
            [SVProgressHUD showErrorWithStatus:@"获取区域数据失败"];
    }];
}
@end
