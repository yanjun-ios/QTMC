//
//  NeedsearchViewController.h
//  MYT
//
//  Created by yunruiinfo on 16/1/18.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeedsearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,assign)NSArray *nodearr;
@end
