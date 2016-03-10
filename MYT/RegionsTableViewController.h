//
//  RegionsTableViewController.h
//  MYT
//
//  Created by 熊凯 on 16/1/17.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PassLocationValueDelegate
-(void)passLovation:(NSDictionary*)locationDic;
@end
@interface RegionsTableViewController : UITableViewController<UIAlertViewDelegate>
@property(nonatomic,retain)NSArray*regionsList;
@property(nonatomic,assign)int provinceIndex;
@property(nonatomic,assign)int citysIndex;
@property(nonatomic,retain) id<PassLocationValueDelegate>LocationDelegate;
@end

