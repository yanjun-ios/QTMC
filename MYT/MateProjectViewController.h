//
//  MateProjectViewController.h
//  MYT
//
//  Created by YUNRUIMAC on 15/12/8.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MateProjectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *abandon;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *mate_name;
@property(retain,nonatomic)NSString* name;
- (IBAction)clickPhone:(id)sender;

- (IBAction)clickBandon:(id)sender;
@property(nonatomic,retain)NSString* cusId;//这个传递的是产品明细id而不是客户id，

@end
