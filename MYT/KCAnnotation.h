//
//  KCAnnotation.h
//  testGit
//
//  Created by 熊凯 on 15/12/14.
//  Copyright © 2015年 YanJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface KCAnnotation : NSObject<MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
