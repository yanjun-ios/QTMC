//
//  PerformanceViewController.h
//  MYT
//
//  Created by 熊凯 on 15/12/12.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerformanceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIButton *btnFirst;
@property (weak, nonatomic) IBOutlet UIButton *btnSecond;
- (IBAction)btnFirstClick:(id)sender;
- (IBAction)btnSecondClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *labSelf;
@property (weak, nonatomic) IBOutlet UILabel *labRank;
@end
