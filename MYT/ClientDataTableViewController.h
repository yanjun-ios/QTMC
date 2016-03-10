//
//  ClientDataTableViewController.h
//  MYT
//
//  Created by 熊凯 on 15/12/9.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientDataTableViewController : UITableViewController
@property(nonatomic,retain)NSString* clientId;
@property (weak, nonatomic) IBOutlet UILabel *lab_cusname;
@property (weak, nonatomic) IBOutlet UILabel *lab_custtname;
@property (weak, nonatomic) IBOutlet UILabel *lab_telephone;
@property (weak, nonatomic) IBOutlet UILabel *lab_creatTime;

@property (weak, nonatomic) IBOutlet UILabel *lab_dlvdate;
@property (weak, nonatomic) IBOutlet UILabel *lab_code;
@property (weak, nonatomic) IBOutlet UILabel *lab_money;
@property (weak, nonatomic) IBOutlet UILabel *lab_visite_time;
@property (weak, nonatomic) IBOutlet UILabel *lab_receiver;
@property (weak, nonatomic) IBOutlet UILabel *lab_contactsname;
@property (weak, nonatomic) IBOutlet UILabel *lab_call_phone;
@property (weak, nonatomic) IBOutlet UILabel *lab_call_time;
@property (weak, nonatomic) IBOutlet UILabel *lab_talk_time;

@property (weak, nonatomic) IBOutlet UILabel *lab_remark;
- (IBAction)clickLocation:(id)sender;
- (IBAction)contactClick:(id)sender;

@end
