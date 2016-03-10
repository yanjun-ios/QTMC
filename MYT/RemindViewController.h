//
//  RemindViewController.h
//  MYT
//
//  Created by YUNRUIMAC on 15/12/8.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MateProjectViewController.h"
@interface RemindViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UILabel *biaoti;


@end
