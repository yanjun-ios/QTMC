//
//  addContactsTableViewController.m
//  MYT
//
//  Created by 熊凯 on 15/12/9.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import "addContactsTableViewController.h"
#import "NetRequestManager.h"
#import "QQRequestManager.h"
@interface addContactsTableViewController ()
{
    BOOL bKeyBoardHide;
     NSMutableDictionary* addcusjson;
}
@end

@implementation addContactsTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    bKeyBoardHide=YES;
    
    //消除多余空白行
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    //设置背景颜色
    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                 
                                 initWithImage:[UIImage imageNamed:@"右上角对号"]
                                 style:UIBarButtonItemStyleDone
                                 
                                 target:self
                                 
                                 action:@selector(finishclick)];
    //barbtn.image=searchimage;
    //self.navigationItem.rightBarButtonItem=barbtn;
    self.tabBarController.navigationItem.rightBarButtonItem = rightBtn;//这儿需要load和appear都写 我也不知道为啥 否则bug


}

- (void)viewDidLoad {
    addcusjson=[[NSMutableDictionary alloc]init];
    _clientId= [NetRequestManager sharedInstance].clientId;
    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                 
                                 initWithImage:[UIImage imageNamed:@"右上角对号"]

                                 style:UIBarButtonItemStyleDone
                                 
                                 target:self
                                 
                                 action:@selector(finishclick)];
    //barbtn.image=searchimage;
    //self.navigationItem.rightBarButtonItem=barbtn;
    self.tabBarController.navigationItem.rightBarButtonItem = rightBtn;
    __TF_Company.delegate=self;
    __TF_Email.delegate=self;
    __TF_Name.delegate=self;
    __TF_Phone.delegate=self;
    __TF_QQ.delegate=self;
    __TF_Telephone.delegate=self;
    __TF_other.delegate=self;
    NSLog(@"%@",self.navigationController);
    UIImage *searchimage=[UIImage imageNamed:@"ok"];
 //   UIBarButtonItem *barbtn=[[UIBarButtonItem alloc] initWithImage:searchimage style:UIBarButtonItemStylePlain target:self action:@selector(finishclick)];
    
    //UIBarButtonItem *btn=[[UIBarButtonItem alloc]init];
    //btn=self.navigationItem.rightBarButtonItem;
    //[btn ];
    //[super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    bKeyBoardHide = NO;
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[textField convertRect:textField.bounds toView:window];
    float y1=rect.origin.y;
    if(y1>216)
    {
    self.tableView.frame=CGRectMake(0, -216, ScreenWidth, ScreenHeight);
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{    bKeyBoardHide = YES;
    self.tableView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-50);
}

-(void)finishclick
{ if (__TF_Company.text.length!=0&&__TF_Email.text.length!=0&&__TF_Name.text.length!=0&&__TF_other.text.length!=0&&__TF_Phone.text.length!=0&&__TF_QQ.text.length!=0&&__TF_Telephone.text.length!=0) {
    NSString *clientidstr=_clientId;
    [addcusjson setObject:__TF_Name.text forKey:@"contactsName"];
    [addcusjson setObject:__TF_Email.text forKey:@"email"];
    [addcusjson setObject:__TF_Telephone.text forKey:@"mobilePhone"];
    [addcusjson setObject:__TF_QQ.text forKey:@"qq"];
    [addcusjson setObject:@"0" forKey:@"sex"];
    [addcusjson setObject:__TF_other.text forKey:@"remark"];//经度
    [addcusjson setObject:__TF_Phone.text forKey:@"phone"];//纬度
    [addcusjson setObject:clientidstr forKey:@"cusid"];
    NSLog(@"%@",clientidstr);
    [addcusjson setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];
    
    NSString*  datastr=[[NetRequestManager sharedInstance]DataToJsonString:addcusjson];
    NSMutableDictionary *pir=[[NSMutableDictionary alloc]init];
    [pir setObject:datastr forKey:@"paraMap"];
    
    [[QQRequestManager sharedRequestManager] POST:[SEVER_URL stringByAppendingString:@"yd/addContacts.action"] parameters:pir showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",datastr);
        [self qq_performSVHUDBlock:^{
            [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
        }];
        if([responseObject objectForKey:@"status"])
        {
            /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:NO];
                // 2秒后异步执行这里的代码...
                
            });*/
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        [self qq_performSVHUDBlock:^{
            [SVProgressHUD showErrorWithStatus:@"添加失败"];
        }];
    }];
 
}
else
{
    [SVProgressHUD showSuccessWithStatus:@"请填写完信息再提交"];
}

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
