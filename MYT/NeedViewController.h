//
//  NeedViewController.h
//  MYT
//
//  Created by YUNRUIMAC on 15/12/15.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
