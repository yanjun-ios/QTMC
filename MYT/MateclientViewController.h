//
//  MateclientViewController.h
//  MYT
//
//  Created by YUNRUIMAC on 15/12/9.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MateclientViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic,retain)NSString* rmdid;
@end
