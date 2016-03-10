//
//  Z_NetRequestManager.m
//  MYT
//
//  Created by 熊凯 on 16/1/9.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import "Z_NetRequestManager.h"
#import "UIViewController+Helper.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
static Z_NetRequestManager * sharedInstance = nil;
@implementation Z_NetRequestManager
{
    CLLocationManager* _locationManager;
     CLGeocoder* _geocoder;
    float longi;
    float lati;
    NSString *begin_hour,*begin_minute,*begin_ms,*end_hour,*end_minute,*end_ms;
    CTCallCenter *callCenter;

}
+ (Z_NetRequestManager *)sharedInstance{
    if (sharedInstance == nil) {
        sharedInstance = [[Z_NetRequestManager alloc] init];
    }
    return sharedInstance;
}
//获取客户列表
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
    
    return dic;
}
//地图定位 调用即可定位
-(void)getlongandlati
{
    NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    //定位管理器
    //_locationManager=[[CLLocationManager alloc]init];
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开");
    }
    //如果没有授权则请求授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=1.0;//一米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
    NSString *longistr=[NSString stringWithFormat:@"%f",longi];
   NSString *latistr=[NSString stringWithFormat:@"%f",lati];
    [dic setValue:longistr forKey:@"longi"];
    [dic setValue:latistr forKey:@"lati"];
   
}
-(NSDictionary *)getlongla
{
    NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
    NSString *longistr=[NSString stringWithFormat:@"%f",longi];
    NSString *latistr=[NSString stringWithFormat:@"%f",lati];
    [dic setValue:longistr forKey:@"longi"];
    [dic setValue:latistr forKey:@"lati"];
    return dic;
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [_locationManager requestAlwaysAuthorization];
            }
            break;
        default:
            break;
            
            
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    longi=coordinate.longitude;
    lati=coordinate.latitude;
    //如果不需要实时定位，使用完即使关闭定位服务
     [_locationManager stopUpdatingLocation];
}
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.addressDictionary);
    }];
}
//以上都是地图代理方法
-(NSDictionary*)getoderDataByYear:(NSString *)year beginMonth:(NSString *)bengin endMonth:(NSString *)end  userId:(NSString *)userid
{
    NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
    [parDic setValue:year forKey:@"year"];
    [parDic setValue:bengin forKey:@"monthS"];
    [parDic setValue:end forKey:@"monthE"];
    [parDic setValue:userid forKey:@"userid"];
    __block NSDictionary* jsonDic;
    [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingPathComponent:@"yd/getMyOrders.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        jsonDic = (NSDictionary*)responseObject;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.superclass qq_performSVHUDBlock:^{
            [SVProgressHUD showErrorWithStatus:@"数据请求错误，请检查网络！"];
        }];
        
    }];
    return jsonDic;
}
//打电话及通话时间
-(NSString*)call:(id)sender view:(UIView*)view
{
    __block NSString* calltime;
    UIButton* btn =  (UIButton*)sender;
    int phonenumber=(int)btn.tag;
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%d",phonenumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [view addSubview:callWebview];
    
    
    callCenter.callEventHandler=^(CTCall* call){
        
        if (call.callState == CTCallStateDialing){
            
            NSLog(@"Call Dialing");
            [self performSelectorOnMainThread:@selector(beginTalktime) withObject:nil waitUntilDone:YES];
        }
        
        if (call.callState == CTCallStateConnected){
            
            NSLog(@"Call Connected");
            
            
            
            
            
        }
        
        if (call.callState == CTCallStateDisconnected){
            
            [self performSelectorOnMainThread:@selector(closeTalktime) withObject:nil waitUntilDone:YES];
            
            NSLog(@"Call Disconnected");
            calltime=[self time:begin_hour begin_minute:begin_minute begin_ms:begin_ms endhour:end_hour end_minute:end_minute end_ms:end_ms];
        }
        
    };
    
    NSLog(@"打电话中");
    return calltime;
}
-(void)beginTalktime
{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh"];
    // NSString hour=[formatter stringFromDate:[NSDate date]];
    begin_hour = [formatter stringFromDate:[NSDate date]];
    begin_hour=[begin_hour stringByReplacingOccurrencesOfString:@"时" withString:@""];
    [formatter setDateFormat:@"mm"];
    begin_minute=[formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"ss"];
    begin_ms=[formatter stringFromDate:[NSDate date]];
    NSLog(@"%@,%@,%@",begin_hour,begin_minute,begin_ms);
}
-(void)closeTalktime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh"];
    end_hour = [formatter stringFromDate:[NSDate date]];
    end_hour=[end_hour stringByReplacingOccurrencesOfString:@"时" withString:@""];
    [formatter setDateFormat:@"mm"];
    end_minute=[formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"ss"];
    end_ms=[formatter stringFromDate:[NSDate date]];
    NSLog(@"%@,%@,%@",end_hour,end_minute,end_ms);
}
-(NSString*)time:(NSString*)begin_h begin_minute:(NSString*)begin_m begin_ms:(NSString*)begin_s endhour:(NSString*)end_h end_minute:(NSString*)end_m end_ms:(NSString*)end_s
{
    NSString* cha;
    int cha_hour ,cha_minute,cha_ms;
    int bh=[begin_h intValue];
    int bm=[begin_m intValue];
    int bs=[begin_s intValue];
    int eh=[end_h intValue];
    int em=[end_m intValue];
    int es=[end_s intValue];
    if (eh>=bh) {
        cha_hour=eh-bh;
    }
    else
        cha_hour=eh+24-bh;
    if (em>=bm) {
        cha_minute=em-bm;
    }
    else
        cha_minute=em+60-bm;
    if (es>=bs) {
        cha_ms=es-bs;
    }
    else
        cha_ms=es+60-bs;
    cha=[NSString stringWithFormat:@"拨打时间为%d时%d份%d秒",cha_hour,cha_minute,cha_ms];
    return  cha;
}
@end
