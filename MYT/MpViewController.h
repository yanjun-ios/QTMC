//
//  MpViewController.h
//  MYT
//
//  Created by YUNRUIMAC on 16/1/13.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KCAnnotation.h"
@interface MpViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager * locationManager;
@end
