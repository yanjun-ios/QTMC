//
//  HXRequestManager.h
//  HXZXG
//
//  Created by Qingqing on 15/11/13.
//  Copyright (c) 2015年 红星装修公. All rights reserved.
//
/**
 *  主要处理针对返回数据进行预处理，和token相关重登录的操作
 */
#import "PreRequestManager.h"

static NSString * const BaseURLString = @"https://api.app.net/";

@interface QQRequestManager : PreRequestManager

/**
 *  单例
 */
+(instancetype)sharedRequestManager;

/**
 *  GET
 *
 *  @param URLString  请求链接
 *  @param parameters 参数
 *  @param isShow     是否显示HUD(默认YES)
 *  @param success    default
 *  @param failure    default
 *
 *  @return default
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      showHUD:(BOOL)isShow
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  POST
 *
 *  @param URLString  请求链接
 *  @param parameters 参数
 *  @param isShow     是否显示HUD(默认YES)
 *  @param success    default
 *  @param failure    default
 *
 *  @return default
 */
-(NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(id)parameters
                      showHUD:(BOOL)isShow
                      success:(void (^)(NSURLSessionDataTask *, id))success
                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

/**
 *  上传文件
 *
 *  @param URLString  请求链接
 *  @param parameters 参数
 *  @param isShow     是否显示HUD(默认YES)
 *  @param block      构造文件数据用Block
 *  @param success    default
 *  @param failure    default
 *
 *  @return default
 */
-(NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(id)parameters
                      showHUD:(BOOL)isShow
    constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                      success:(void (^)(NSURLSessionDataTask *, id))success
                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end
