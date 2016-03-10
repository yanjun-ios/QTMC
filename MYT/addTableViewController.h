//
//  addTableViewController.h
//  MYT
//
//  Created by 熊凯 on 15/12/8.
//  Copyright © 2015年 YunRui. All rights reserved.
//
//ok
#import <UIKit/UIKit.h>
#import "RegionsTableViewController.h"
@interface addTableViewController : UITableViewController<UITextFieldDelegate,UIAlertViewDelegate,PassLocationValueDelegate>
@property (weak, nonatomic) IBOutlet UILabel *locati;

@property (weak, nonatomic) IBOutlet UITextField *TF_CusName;
@property (weak, nonatomic) IBOutlet UITextField *TF_CusTtName;
@property (weak, nonatomic) IBOutlet UITextField *TF_MobilePhone;
@property (weak, nonatomic) IBOutlet UITextField *TF_CusCode;
- (IBAction)Click_GetLocation:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *TF_Phone;
@property (weak, nonatomic) IBOutlet UITextField *TF_website;
@property (weak, nonatomic) IBOutlet UIButton *btn_qiye;
- (IBAction)click_qiye:(id)sender;

- (IBAction)click_finish:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_person;
- (IBAction)click_person:(id)sender;
@end
