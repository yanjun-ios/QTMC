//
//  MyOderViewController.h
//  MYT
//
//  Created by 熊凯 on 15/12/11.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
@interface MyOderViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NIDropDownDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mytableview;
@property (weak, nonatomic) IBOutlet UIButton *btn_year;
@property (weak, nonatomic) IBOutlet UIButton *btn_FirstMonth;
@property (weak, nonatomic) IBOutlet UIButton *btn_endMonth;
@property(nonatomic,assign)NSString * userID;
@end
