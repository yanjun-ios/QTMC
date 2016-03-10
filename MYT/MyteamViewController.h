//
//  MyteamViewController.h
//  MYT
//
//  Created by YUNRUIMAC on 15/12/11.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
@interface MyteamViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NIDropDownDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview1;//主tableview
- (IBAction)monthclickone:(id)sender;
- (IBAction)monthclicktwo:(id)sender;
- (IBAction)yearclick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *monthone;
@property (weak, nonatomic) IBOutlet UIButton *monthtwo;
@property (weak, nonatomic) IBOutlet UIButton *year;
- (IBAction)achievement_click:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *Nabarbutton;
@property (weak, nonatomic) IBOutlet UIButton *shi;
- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btn_jidu1;
@property (weak, nonatomic) IBOutlet UIButton *btn_jidu2;
@property (weak, nonatomic) IBOutlet UIButton *btn_jidu3;
@property (weak, nonatomic) IBOutlet UIButton *btn_jidu4;
- (IBAction)jidu1_click:(id)sender;

@end
