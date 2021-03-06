//
//  MpViewController.m
//  MYT
//
//  Created by YUNRUIMAC on 16/1/13.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import "MpViewController.h"

@interface MpViewController ()
{
    CLLocationManager* v;
    CLGeocoder* _geocoder;
    NSMutableArray * addAnnotations;
    NSMutableArray *cusDist;
}
@end

@implementation MpViewController
-(void)viewWillAppear:(BOOL)animated
{}
- (void)viewDidLoad {
    NSLog(@"ss");
    [self initGUI];
    cusDist=[[NSMutableArray alloc]init];
    addAnnotations=[[NSMutableArray alloc]init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        
       
        [self getCusdist];
        
    });
    
    
    
    _geocoder=[[CLGeocoder alloc]init];
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开");
        return;
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

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//获取客户信息列表
-(void)getCusdist
{
    NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
    [parDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];
    //此处要改参数
    [parDic setValue:@"24" forKey:@"lon"];//单例的经度
    [parDic setValue:@"36" forKey:@"lat"];//单例的纬度
    [parDic setValue:@"1000" forKey:@"raidus"];//范围
    [self getAddressByLatitude:39 longitude:120];
    //异步请求
    [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingString:@"yd/getCusDist.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        cusDist=[responseObject objectForKey:@"list"];
        NSLog(@"%@",[cusDist objectAtIndex:0]);
        NSLog(@"%lu",(unsigned long)cusDist.count);
        [self addAnnotation];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        [self qq_performSVHUDBlock:^{
            [SVProgressHUD showErrorWithStatus:@"找不到客户信息"];
        }];
    }];
    
}

//延迟一会才调用而不是之间启动跟踪定位后立马调用
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 添加地图控件
-(void)initGUI{
    //设置代理
    _mapView.delegate=self;
    
    //请求定位服务
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    
    
    
}


#pragma mark 添加大头针
-(void)addAnnotation
{
    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(36.08, 120.35);
    KCAnnotation *annotation1=[[KCAnnotation alloc]init];
    annotation1.title=@"CMJ Studio";
    annotation1.subtitle=@"Kenshin Cui's Studios";
    annotation1.coordinate=location1;
    [_mapView addAnnotation:annotation1];
    float lati=40;
    float longi=120;
    for (int i=0; i<cusDist.count; i++) {
        NSDictionary *cust=[cusDist objectAtIndex:i];
        
        //((NSNumber*)[cust objectForKey:@"latitude"]).floatValue;
        
        //((NSNumber*)[cust objectForKey:@"longitude"]).floatValue;
        CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(lati,longi);
        KCAnnotation *annotation1=[[KCAnnotation alloc]init];
        annotation1.title=[cust objectForKey:@"cusname"];
        annotation1.subtitle=[cust objectForKey:@"cusid"];
        annotation1.coordinate=location1;
        [addAnnotations addObject:annotation1];
        [_mapView addAnnotation:annotation1];
      //  [_mapView selectAnnotation:annotation1 animated:YES];
        lati=lati+5;
        longi=longi+5;
    }
    
    
    
    
}


#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    //如果不需要实时定位，使用完即使关闭定位服务
   // [_locationManager stopUpdatingLocation];
}


//////////////地理编码/////////////
#pragma mark 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address{
    //地理编码
    
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        
        CLPlacemark *placemark=[placemarks firstObject];
       // palceinfor=[NSArray arrayWithArray:placemarks];
        CLLocation *location=placemark.location;//位置
        NSLog(@"%@",location);
        CLRegion *region=placemark.region;//区域
        NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
        //        NSString *name=placemark.name;//地名
        //        NSString *thoroughfare=placemark.thoroughfare;//街道
        //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
        //        NSString *locality=placemark.locality; // 城市
        //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
        //        NSString *administrativeArea=placemark.administrativeArea; // 州
        //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
        //        NSString *postalCode=placemark.postalCode; //邮编
        //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
        //        NSString *country=placemark.country; //国家
        //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
        //        NSString *ocean=placemark.ocean; // 海洋
        //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
    }];
    
}

#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.addressDictionary);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
