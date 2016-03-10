//
//  FindmapViewController.h
//  MYT
//
//  Created by yunruiinfo on 16/1/12.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KCAnnotation.h"
@interface FindmapViewController : UIViewController<UISearchBarDelegate,MKMapViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *mapsearch;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager * locationManager;
@end
