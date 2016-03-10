//
//  TreeViewController.h
//  MYT
//
//  Created by yunruiinfo on 16/1/15.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TreeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *findview;
@property (weak, nonatomic) IBOutlet UITextField *findtext;
- (IBAction)click_find:(id)sender;
- (IBAction)find:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *stocksearch;
@property(nonatomic,assign)NSArray *nodearr;
@property(nonatomic,assign)int totlePage;
@end
