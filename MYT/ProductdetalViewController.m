//
//  ProductdetalViewController.m
//  MYT
//
//  Created by YUNRUIMAC on 15/12/15.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import "ProductdetalViewController.h"
#import "ButtomView.h"
@interface ProductdetalViewController ()

@end

@implementation ProductdetalViewController

- (void)viewDidLoad {
    ButtomView* BtmV=[[ButtomView alloc]initWithFrame:CGRectMake(0, ScreenHeight-49, ScreenWidth, 50)];
    [self.view addSubview:BtmV];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _jibie.textColor=[UIColor orangeColor];
    _jibie.text=[NSString stringWithFormat:@"%@>%@>%@",_depth0,_depth1,_depth2];
    _jibie.font=[UIFont fontWithName:@"ArialMT" size:14];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)initinfo
{
    NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
    [parDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]);
    [parDic setValue:@"null" forKey:@"parentid"];
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(concurrentQueue, ^{
        [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingString:@"yd/getMatTree.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                        //将请求到的第一层数据分类
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            
            [self qq_performSVHUDBlock:^{
                [SVProgressHUD showErrorWithStatus:@"请求数据失败"];
            }];
        }];
        
        /*download the image here*/
        
    });

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{return  0;}
/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 60)];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0,  _tableView.frame.size.width, 35)];
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(0, 35,  _tableView.frame.size.width, 25)];
    view2.backgroundColor=[UIColor lightGrayColor];
    
    UILabel *jibie=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 35)];
    jibie.textColor=[UIColor orangeColor];
    jibie.text=[NSString stringWithFormat:@"%@>%@>%@",_depth0,_depth1,_depth2];
    jibie.font=[UIFont fontWithName:@"ArialMT" size:14];
    [view1 addSubview:jibie];
    
    UILabel *length=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width/3, 25)];
    length.textColor=[UIColor blackColor];
    length.text=@"长度";
    length.textAlignment=NSTextAlignmentCenter;
    length.font=[UIFont fontWithName:@"ArialMT" size:14];
    
    UILabel *from=[[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width/3, 0, tableView.frame.size.width/3, 25)];
    from.textColor=[UIColor blackColor];
    from.text=@"产地";
    from.textAlignment=NSTextAlignmentCenter;
    from.font=[UIFont fontWithName:@"ArialMT" size:14];
    
    
    UILabel *count=[[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width*2/3, 0, tableView.frame.size.width/3, 25)];
    count.textColor=[UIColor blackColor];
    count.textAlignment=NSTextAlignmentCenter;
    count.text=@"数量";
    count.font=[UIFont fontWithName:@"ArialMT" size:14];
    
    
    [view2 addSubview:length];
    [view2 addSubview:from];
    [view2 addSubview:count];
    
    [view addSubview:view1];
    [view addSubview:view2];
    return view;
}*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 10;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
