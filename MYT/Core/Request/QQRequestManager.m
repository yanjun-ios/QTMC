//
//  HXRequestManager.m
//  HXZXG
//
//  Created by Qingqing on 15/11/13.
//  Copyright (c) 2015年 红星装修公. All rights reserved.
//

#import "QQRequestManager.h"
#import <SVProgressHUD.h>
#import <objc/runtime.h>
extern NSString* const isShowHUD;

@implementation QQRequestManager

+(instancetype)sharedRequestManager{
    static QQRequestManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [_sharedClient.reachabilityManager startMonitoring];//启动网络状态监听
        _sharedClient = [[QQRequestManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return _sharedClient;
}

#pragma mark Public Method

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      showHUD:(BOOL)isShow
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    /* 扩展一个属性——用于判断是否全局显示指示符 */
    objc_setAssociatedObject(URLString, (__bridge const void *)(isShowHUD), @(isShow), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return [self GET:URLString parameters:parameters success:success failure:failure];
}

-(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters showHUD:(BOOL)isShow success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    /* 扩展一个属性——用于判断是否全局显示指示符 */
    objc_setAssociatedObject(URLString, (__bridge const void *)(isShowHUD), @(isShow), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return [self POST:URLString parameters:parameters success:success failure:failure];
}

-(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters showHUD:(BOOL)isShow constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    /* 扩展一个属性——用于判断是否全局显示指示符 */
    objc_setAssociatedObject(URLString, (__bridge const void *)(isShowHUD), @(isShow), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:block success:success failure:failure];
}

#pragma mark Overwrite Method
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSLog(@"\n\n网络请求GET：\n%@\n参数：%@\n\n",URLString,parameters);
    
    NSURLSessionDataTask* task = [super GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self preprocessWithDataTask:task result:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"服务器内部错误:%@",error]];
        failure(task, error);
    }];
    
    return task;
}

-(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    NSLog(@"\n\n网络请求POST：\n%@\n参数：%@\n\n",URLString,parameters);

    NSURLSessionDataTask* task = [super POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self preprocessWithDataTask:task result:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"服务器内部错误:%@",error]];
        failure(task, error);
    }];
    
    return task;
}

-(NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    NSLog(@"\n\n网络请求POST(文件上传)：\n%@\n参数：%@\n\n",URLString,parameters);

    NSURLSessionDataTask* task =[super POST:URLString parameters:parameters constructingBodyWithBlock:block success:^(NSURLSessionDataTask *task, id responseObject) {
        [self preprocessWithDataTask:task result:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"服务器内部错误:%@",error]];
        NSLog(@"ERROR:%@",error);
        failure(task, error);
    }];
    
    return task;
}
#pragma mark Private Method

-(void)preprocessWithDataTask:(NSURLSessionDataTask*)task
                       result:(id)responseObject
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))handleSuccess
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))handleFailure {
    
#warning 临时用
    handleSuccess(task, responseObject);
    
//    ComMetaModel* metaModel = [ComMetaModel objectWithKeyValues:[responseObject objectForKey:@"meta"]];
//    NSString* msg = metaModel.msg;
//    switch (metaModel.code) {
//        case 200:{
//            //请求成功
//            handleSuccess(task, responseObject);
//            break;
//        }
//        case 400:
//            //@"错误请求"
//            [SVProgressHUD showErrorWithStatus:msg];
//            handleFailure(task,nil);
//            break;
//            
//        case 401:
//            //@"未授权"
//            [SVProgressHUD showErrorWithStatus:msg];
//            handleFailure(task,nil);
//            break;
//            
//        case 404:
//            //@"请求不存在"
//            [SVProgressHUD showErrorWithStatus:msg];
//            handleFailure(task,nil);
//            break;
//            
//        case 451:
//            //@"参数验证错误"
//            [self showErrorHUDWithMessage:msg];
//            handleFailure(task,nil);
//            break;
//            
//        case 460:
//            //token错误
//            
//            break;
//            
//        case 461:
//            //token格式错误
//            
//            break;
//            
//        case 462:{
//            //token过期
//            
//            break;
//        }
//        case 500:
//            [SVProgressHUD showErrorWithStatus:@"服务器内部错误"];
//            handleFailure(task,nil);
//            break;
//            
//        default:
//            [SVProgressHUD showErrorWithStatus:@"未知错误"];
//            handleFailure(task,nil);
//            break;
//    }
}


/**
 *  延迟执行，解决HUD不显示BUG
 *
 */
- (void)showErrorHUDWithMessage:(NSString*)msg{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressHUD showErrorWithStatus:msg];
    });
}
@end
