//
//  addContactsTableViewController.h
//  MYT
//
//  Created by 熊凯 on 15/12/9.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addContactsTableViewController : UITableViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *_TF_Name;
@property (weak, nonatomic) IBOutlet UITextField *_TF_Company;
@property (weak, nonatomic) IBOutlet UITextField *_TF_Telephone;
@property (weak, nonatomic) IBOutlet UITextField *_TF_Phone;
@property (weak, nonatomic) IBOutlet UITextField *_TF_QQ;
@property (weak, nonatomic) IBOutlet UITextField *_TF_Email;
@property (weak, nonatomic) IBOutlet UITextField *_TF_other;
@property(nonatomic,retain)NSString* clientId;
@end
