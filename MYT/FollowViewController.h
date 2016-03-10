//
//  FollowViewController.h
//  MYT
//
//  Created by 熊凯 on 16/1/14.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *btn_hasCalled;
@property (weak, nonatomic) IBOutlet UIButton *btn_notCalled;
@property (weak, nonatomic) IBOutlet UIButton *btn_abandon;
@property (weak, nonatomic) IBOutlet UIView *topView;
- (IBAction)btnChooseClick:(id)sender;
@property(nonatomic,retain)NSMutableDictionary* parDic;
@end
