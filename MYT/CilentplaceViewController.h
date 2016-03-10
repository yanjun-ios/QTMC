//
//  CilentplaceViewController.h
//  MYT
//
//  Created by YUNRUIMAC on 16/1/17.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KCAnnotation.h"
@interface CilentplaceViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager * locationManager;
@property(nonatomic,assign)NSString* lati;
@property(nonatomic,assign)NSString* longi;
@end
