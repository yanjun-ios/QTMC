//
//  DMHTTPSessionManager.m
//  DecorationManage
//
//  Created by Qingqing on 15-5-5.
//  Copyright (c) 2015年 xingyijia. All rights reserved.
//

#import "PreRequestManager.h"
#import <objc/runtime.h>

NSString* const isShowHUD = @"isShowHUD";

@implementation PreRequestManager

#pragma mark GET&POST请求预处理——非上传文件 (override)
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    id isShowAttr = objc_getAssociatedObject(URLString, (__bridge const void *)(isShowHUD));
    if (isShowAttr == nil) {
        isShowAttr = @(YES);
    }
    BOOL showHUD = [isShowAttr boolValue];
    if (showHUD) {
        [SVProgressHUD showWithStatus:@"努力加载中..."];
    }
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (showHUD) {
            [SVProgressHUD dismiss];
        }
        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (success) {
                /* 数据预处理，替换Null数据 */
                id resultDic;
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    resultDic = (id)[self preproccessResponseObjectWithDictionary:responseObject];
                }else if ([responseObject isKindOfClass:[NSArray class]]){
                    resultDic = (id)[self preproccessResponseObjectWithArray:responseObject];
                }
                
                if (resultDic) {
                    /* 返回数据 */
                    success(dataTask, resultDic);
                }else{
                    /* 数据异常处理 */
                    [SVProgressHUD showErrorWithStatus:@"数据异常"];
                }
            }
        }
    }];
    
    return dataTask;
}

#pragma mark POST 请求预处理——上传文件、图片 (override)

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            //数据预处理，替换Null数据
            id resultDic;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                resultDic = (id)[self preproccessResponseObjectWithDictionary:responseObject];
            }else if ([responseObject isKindOfClass:[NSArray class]]){
                resultDic = (id)[self preproccessResponseObjectWithArray:responseObject];
            }
            
            if (resultDic&&success) {
                success(task, resultDic);
            }else{
                //数据异常处理
                failure(task, nil);
                [SVProgressHUD showErrorWithStatus:@"数据异常"];
            }
        }
    }];
    
    [task resume];
    
    return task;
}


#pragma mark 预处理——遍历返回数据是否含有NULL，替换为@“”

-(NSMutableDictionary*)preproccessResponseObjectWithDictionary:(NSDictionary*)preDic{
    NSMutableDictionary* resultMutDic = [NSMutableDictionary dictionaryWithDictionary:preDic];
    [resultMutDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNull class]]) {
            [resultMutDic setObject:@"" forKey:key];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            NSDictionary* temDic = [self preproccessResponseObjectWithDictionary:obj];
            [resultMutDic setObject:temDic forKey:key];
        }else if ([obj isKindOfClass:[NSArray class]]){
            NSMutableArray* temAry = [self preproccessResponseObjectWithArray:obj];
            [resultMutDic setObject:temAry forKey:key];
        }
    }];
    return resultMutDic;
}

-(NSMutableArray*)preproccessResponseObjectWithArray:(NSArray*)preAry{
    NSMutableArray* resultMutAry = [NSMutableArray arrayWithArray:preAry];
    [resultMutAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSNull class]]) {
            [resultMutAry replaceObjectAtIndex:idx withObject:@""];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            [resultMutAry replaceObjectAtIndex:idx withObject:[self preproccessResponseObjectWithDictionary:obj]];
        }else if ([obj isKindOfClass:[NSArray class]]){
            [resultMutAry replaceObjectAtIndex:idx withObject:[self preproccessResponseObjectWithArray:obj]];
        }
    }];
    return resultMutAry;
}
@end
