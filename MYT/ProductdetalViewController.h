//
//  ProductdetalViewController.h
//  MYT
//
//  Created by YUNRUIMAC on 15/12/15.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductdetalViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign)NSString* depth0;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *jibie;
@property(nonatomic,assign)NSString* depth1;
@property(nonatomic,assign)NSString* depth2;
@property(nonatomic,assign)NSString* matid;
@end
