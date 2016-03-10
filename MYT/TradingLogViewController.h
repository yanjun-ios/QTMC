//
//  TradingLogViewController.h
//  MYT
//
//  Created by 熊凯 on 16/1/11.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradingLogViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
