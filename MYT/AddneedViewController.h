//
//  AddneedViewController.h
//  MYT
//
//  Created by YUNRUIMAC on 16/1/16.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddneedViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,assign)NSArray *nodearr;
@property(nonatomic,retain)NSString* clientId;
- (IBAction)click_ok:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *stocksearch;
@property (weak, nonatomic) IBOutlet UIView *findview;
- (IBAction)click_find:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *findtext;
- (IBAction)find:(id)sender;
@property(nonatomic,assign)int totlePage;
@end
