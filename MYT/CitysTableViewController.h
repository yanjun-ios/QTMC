//
//  CitysTableViewController.h
//  MYT
//
//  Created by 熊凯 on 16/1/17.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitysTableViewController : UITableViewController
@property(nonatomic,retain)NSArray* citysList;
@property(nonatomic,assign)int provinceIndex;
@property(nonatomic,assign)int citysIndex;
@end
