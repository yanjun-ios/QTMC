//
//  Z_NetRequestManager.h
//  MYT
//
//  Created by 熊凯 on 16/1/9.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "KCAnnotation.h"
@interface Z_NetRequestManager : NSObject<CLLocationManagerDelegate,MKMapViewDelegate>
/**
 *  工具类单例 这是工具类，将需要多次请求的类放到这里来
 */
+ (Z_NetRequestManager *)sharedInstance;
-(NSDictionary*)getClientList:(NSDictionary *)paraDic;
-(void)getlongandlati;
-(NSDictionary *)getlongla;
-(NSDictionary*)getoderDataByYear:(NSString*)year beginMonth:(NSString*)bengin endMonth:(NSString*)end userId:(NSString*)userid;
-(NSString*)call:(id)sender view:(UIView*)view;

@end
