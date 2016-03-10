//
//  TradingViewController.h
//  MYT
//
//  Created by 熊凯 on 16/1/10.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@interface TradingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
