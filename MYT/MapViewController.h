//
//  MapViewController.h
//  MYT
//
//  Created by YUNRUIMAC on 16/1/10.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KCAnnotation.h"
@interface MapViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *la_place;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *customer_behind;
@property (strong,nonatomic) CLLocationManager * locationManager;
@end
