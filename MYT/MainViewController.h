//
//  MainViewController.h
//  MYT
//
//  Created by 熊凯 on 15/12/10.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>
//ok
@interface MainViewController : UIViewController
- (IBAction)click_put:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *click_tocompany;
- (IBAction)click_tocompany:(id)sender;

@end
