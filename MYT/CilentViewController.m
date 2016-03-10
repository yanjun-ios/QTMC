//
//  CilentViewController.m
//  MYT
//
//  Created by 熊凯 on 15/12/8.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import "CilentViewController.h"
#import "XNTabBarController.h"
#import"Utility.h"
#import "NetRequestManager.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
@interface CilentViewController ()
{
    int  toIndex;
    NSMutableArray *data;//客户数据都在这儿
    int j;
    CTCallCenter *callCenter;
    NSString* clientID;
    NSString* begin_hour;
    NSString* begin_minute;
    NSString* begin_ms;
    NSString* end_hour;
    NSString* end_minute;
    NSString* end_ms;
    int totalpage;//总页数
}

@end

@implementation CilentViewController
-(void)viewDidAppear:(BOOL)animated
{
  NSLog(@"%@",data);
    [_tableview reloadData];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [self.viewDeckController closeRightView];
    [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
}

-(void)viewWillAppear:(BOOL)animated

{
    
    [self.viewDeckController setPanningMode:IIViewDeckFullViewPanning];
//    if ([NetRequestManager sharedInstance].FROMDECK==1) {
//        [self.viewDeckController openRightView];
//    }
    if (self.viewDeckController.openRightView) {
        [self.viewDeckController closeRightView];
    }

    
    [self initinfor];
      // [_tableview reloadData];
    self.navigationController.navigationBarHidden=NO;
   
    
    
}
- (void)viewDidLoad {
    
    callCenter = [[CTCallCenter alloc] init];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _tableview.mj_footer.automaticallyHidden = NO;
   
    _tableview.sectionFooterHeight=0;
    _tableview.sectionHeaderHeight=10;
    _tableview.rowHeight=UITableViewAutomaticDimension;
    _tableview.estimatedRowHeight=44.0;//这个必须加上，否则出现高度无法自适应问题。
    //[_tableview reloadData];
    
    //tableview设置
    
    
    [_tableview reloadData];
    //设置搜索框的代理
    _findcust.delegate=self;
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void)initinfor
{
    j=1;
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]) {
        data = [[NSMutableArray alloc]init];
        NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
        [parDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];
        //NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]);
        [parDic setValue:@"5" forKey:@"pageSize"];
        NSString *stringJ = [NSString stringWithFormat:@"%d",j];
        
        [parDic setValue:stringJ forKey:@"pageNum"];
        //        NSDictionary* responseObject= [[Y_NetRequestManager sharedInstance] getClientList:parDic];
        //       if(responseObject)
        //        {
        //            NSArray *init=[responseObject objectForKey:@"list"];
        //            for (int i = 0; i<init.count; i++) {
        //                [data addObject:[init objectAtIndex:i]];
        //                       [_tableview reloadData];
        //            }
        //        }else
        //        {
        //            [self qq_performSVHUDBlock:^{
        //               [SVProgressHUD showErrorWithStatus:@"暂时没有任何数据！"];
        //            }];
        //        }
        [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingString:@"yd/getAppUserList.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            totalpage=((NSNumber*)[responseObject objectForKey:@"totlePage"]).intValue;
           // NSLog(@"%@",responseObject);
            NSArray *init=[responseObject objectForKey:@"list"];
            for (int i = 0; i<init.count; i++) {
                [data addObject:[init objectAtIndex:i]];
            }
            [_tableview reloadData];
            NSLog(@"%@",data);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            
            [self qq_performSVHUDBlock:^{
                [SVProgressHUD showErrorWithStatus:@"账号或密码错误"];
            }];
        }];
    }
    
    // [_tableview.mj_footer beginRefreshing];
    
}


/*- (void)example01
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_tableview loadNewData];
    }];
    
    // 马上进入刷新状态
    [_tableview.mj_header beginRefreshing];
}*/


/*- (void)example01
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_tableview loadNewData];
    }];
    
    // 马上进入刷新状态
    [_tableview.mj_header beginRefreshing];
}*/
/*- (void)example11
{
   // [self example01];
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}*/
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *find=[searchText stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
    [parDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];//user_id
    [parDic setValue:find forKey:@"cusname"];
    [parDic setValue:@1 forKey:@"pageNum"];
    [parDic setValue:@10 forKey:@"pageSize"];
    [parDic setValue:@"" forKey:@"province"];
    [parDic setValue:@"" forKey:@"city"];
    [parDic setValue:@"" forKey:@"district"];
    [parDic setValue:@"ALL" forKey:@"isneed"];
    NSString* parStr=[[NetRequestManager sharedInstance] DataToJsonString:parDic];
    
    NSMutableDictionary* DIC=[[NSMutableDictionary alloc]init];
    [DIC setObject:parStr forKey:@"paraMap"];
    [self searchClient:DIC];
}

-(NSIndexPath *)tableView:(UITableView *)tableView
 willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_findcust resignFirstResponder];
    return indexPath;
}
-(void)searchClient:(NSDictionary*)parDic
{
    [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingString:@"yd/queryCuss.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *init=[responseObject objectForKey:@"list"];
        [data removeAllObjects];
        [data addObjectsFromArray:init];
        if (init.count==0) {
            [self qq_performSVHUDBlock:^{
                [SVProgressHUD showInfoWithStatus:@"没有搜索到客户!"];
            }];
            
        }

        [_tableview reloadData];
        //NSLog(@"%d",data.count);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        [self qq_performSVHUDBlock:^{
            [SVProgressHUD showErrorWithStatus:@"数据请求错误！"];
        }];
    }];


}

- (void)loadMoreData
{
    // 1.添加假数据
    if (j<totalpage+1) {
        j++;
        NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
        [parDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]);
        [parDic setValue:@"5" forKey:@"pageSize"];
        NSString *stringJ = [NSString stringWithFormat:@"%d",j];
        [parDic setValue:stringJ forKey:@"pageNum"];
        [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingString:@"yd/getAppUserList.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            NSArray *init=[responseObject objectForKey:@"list"];
            for (int i = 0; i<init.count; i++) {
                [data addObject:[init objectAtIndex:i]];
            }
                        [_tableview reloadData];
            //NSLog(@"%d",data.count);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            
            [self qq_performSVHUDBlock:^{
                [SVProgressHUD showErrorWithStatus:@"账号或密码错误"];
            }];
        }];
    }
    else
    {
         [SVProgressHUD showErrorWithStatus:@"已经到底啦"];
    }


    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    
        // 刷新表格
    
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [_tableview.mj_footer endRefreshing];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"%lu",(unsigned long)data.count);
    return data.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",data);
    static NSString *CellIdentifier = @"cell2";
    // 通过indexPath创建cell实例 每一个cell都是单独的
   // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        
        //创建客户名称lab
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        UILabel* lab=[[UILabel alloc]initWithFrame:CGRectMake(8, 16, 300, 21)];
        lab.font=[UIFont systemFontOfSize:16];
        lab.textColor=[UIColor redColor];
        lab.tag=148;
        [cell.contentView addSubview:lab];
        //创建下划线
        
        UIView* line=[[UIView alloc]initWithFrame:CGRectMake(0, 45, ScreenWidth, 1)];
        line.backgroundColor=[UIColor lightGrayColor];
        [cell.contentView addSubview:line];
        
        //创建添加联系人按钮
        UIButton* btnadd=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-40, 55, 35 , 35)];
       
        [btnadd setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [cell.contentView addSubview:btnadd];
        btnadd.tag=200;
        [btnadd addTarget:self action:@selector(addContactsClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //创建客户详情按钮
        UIButton* btnto=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-40, 5, 35 , 35)];
        
        [btnto setImage:[UIImage imageNamed:@"向右15.15"] forState:UIControlStateNormal];
        [cell.contentView addSubview:btnto];
        btnto.tag=190;
        [btnto addTarget:self action:@selector(clickToTaba:) forControlEvents:UIControlEventTouchUpInside];
    }
        NSDictionary* customer=[data objectAtIndex:[indexPath section]];
  //  NSString *d=[NSString stringWithFormat:@"%ld",(long)[indexPath row]];
    NSLog(@"%@",customer);
  //  NSLog(@"%@",d);
        //int custo_id=((NSNumber*)[customer objectForKey:@"id"]).intValue;//获取客户id
        int index=90000+[indexPath section];
        ((UIButton*)[cell.contentView viewWithTag:190]).tag=index;
        ((UIButton*)[cell.contentView viewWithTag:200]).tag=index+10000;//添加联系人
        NSString* custo_name=[customer objectForKey:@"cus_name"];//客户名称 公司或者个体户
        ((UILabel*)[cell.contentView viewWithTag:148]).text=custo_name;
        NSArray* contacts=[customer objectForKey:@"contacts"];//联系人数组
    NSLog(@"%@",contacts);
        NSString* contacts_phone,*contacts_name,*contacts_id;
        int jgx=0;
        //多的话默认显示前3个
        if (contacts.count>=3) {
            for (int i=0; i<3; i++) {
                NSDictionary * contact=[contacts objectAtIndex:i];
                contacts_phone=[contact objectForKey:@"CONTACTS_PHONE"];
                contacts_name=[contact objectForKey:@"CONTACTS_NAME"];
                contacts_id=[contact objectForKey:@"CONTACTS_ID"];
                
                UIButton * btn_contact=[[UIButton alloc]initWithFrame:CGRectMake(15+jgx, 60, 70, 25)];
                [btn_contact addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
                [btn_contact setTitle:contacts_name forState:UIControlStateNormal];
                btn_contact.titleLabel.font = [UIFont systemFontOfSize: 12.0];
                [btn_contact setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn_contact setImage:[UIImage imageNamed:@"电话小"]  forState:UIControlStateNormal];
                [[Utility sharedInstance] setLayerView:btn_contact borderW:1 borderColor:[UIColor redColor] radius:4];
                NSInteger  phonenumber=((NSNumber*)contacts_phone).integerValue;
                btn_contact.tag=phonenumber;
                //[indexPath row]*100+i;
                jgx=jgx+90;
                [cell.contentView addSubview:btn_contact];
            }
        }
        else
        {
            for (int i=0; i<contacts.count; i++) {
                NSDictionary * contact=[contacts objectAtIndex:i];
                contacts_phone=[contact objectForKey:@"CONTACTS_PHONE"];
                contacts_name=[contact objectForKey:@"CONTACTS_NAME"];
                contacts_id=[contact objectForKey:@"CONTACTS_ID"];
                
                UIButton * btn_contact=[[UIButton alloc]initWithFrame:CGRectMake(15+jgx, 60, 70, 25)];
                [btn_contact addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
                [btn_contact setTitle:contacts_name forState:UIControlStateNormal];
                btn_contact.titleLabel.font = [UIFont systemFontOfSize: 12.0];
                [btn_contact setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn_contact setImage:[UIImage imageNamed:@"电话小"]  forState:UIControlStateNormal];
                [[Utility sharedInstance] setLayerView:btn_contact borderW:1 borderColor:[UIColor redColor] radius:4];
                NSInteger phonenumber=((NSNumber*)contacts_phone).integerValue;
                btn_contact.tag=phonenumber;
                //[indexPath row]*100+i;
                jgx=jgx+90;
                [cell.contentView addSubview:btn_contact];
            }
        }
    
    
    
    
    return cell;
    
}
-(void)call:(id)sender
{
    
    UIButton* btn =  (UIButton*)sender;
    NSInteger phonenumber=(NSInteger)btn.tag;
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%ld",(long)phonenumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
  
    
    callCenter.callEventHandler=^(CTCall* call){
        
        if (call.callState == CTCallStateDialing){
            
            NSLog(@"Call Dialing");
            [self performSelectorOnMainThread:@selector(beginTalktime) withObject:nil waitUntilDone:YES];
        }
        
        if (call.callState == CTCallStateConnected){
            
            NSLog(@"Call Connected");
            
            
            
            
            
        }
        
        if (call.callState == CTCallStateDisconnected){
            
            [self performSelectorOnMainThread:@selector(closeTalktime) withObject:nil waitUntilDone:YES];
            
            NSLog(@"Call Disconnected");
            
        }
        
    };
    NSLog(@"打电话中");
}
-(void)beginTalktime
{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh"];
 // NSString hour=[formatter stringFromDate:[NSDate date]];
    begin_hour = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"mm"];
    begin_minute=[formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"ss"];
    begin_ms=[formatter stringFromDate:[NSDate date]];
    NSLog(@"%@,%@,%@",begin_hour,begin_minute,begin_ms);
}
-(void)closeTalktime
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh"];
    end_hour = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"mm"];
    end_minute=[formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"ss"];
    end_ms=[formatter stringFromDate:[NSDate date]];
    NSLog(@"%@,%@,%@",end_hour,end_minute,end_ms);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

//点击按钮到客户详情
-(void)clickToTaba:(id)sender
{
   UIButton* btn =  (UIButton*)sender;
    //clientId=(int)btn.tag-90000;
    int indexP=(int)btn.tag-90000;
     clientID=[[data objectAtIndex:indexP] objectForKey:@"id"];
    toIndex=0;
    [NetRequestManager sharedInstance].clientId=clientID;
    [self performSegueWithIdentifier:@"toTab" sender:nil];
   
}

-(void)addContactsClick:(id)sender
{
    UIButton* btn =  (UIButton*)sender;
    int indexPa=(int)btn.tag-100000;
    toIndex=2;
    [NetRequestManager sharedInstance].clientId=[[data objectAtIndex:indexPa] objectForKey:@"id"];
    [self performSegueWithIdentifier:@"toTab" sender:nil];
    
}


#pragma mark - Navigation
//
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toTab"])
    {
        XNTabBarController* destinationController=segue.destinationViewController;
        destinationController.index=toIndex;
        
    }
}


//导航栏右边侧边栏展开按钮
- (IBAction)rightMenuClick:(id)sender {
    //判断是否打开，做出不同响应
    if ([self.viewDeckController isSideOpen:IIViewDeckRightSide]) {//已经打开
        [self.viewDeckController closeRightView];//则关闭左视图
        }
    else {//未打开
        [self.viewDeckController openRightView];//则打开左视图
        
    }

}

-(void)passLovation:(NSDictionary *)locationDic
{
    NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
    [parDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];//user_id
    [parDic setValue:@"" forKey:@"cusname"];
    [parDic setValue:@1 forKey:@"pageNum"];
    [parDic setValue:@100 forKey:@"pageSize"];
    [parDic setValue:[locationDic objectForKey:@"provinceCode"] forKey:@"province"];
    [parDic setValue:[locationDic objectForKey:@"cityCode"] forKey:@"city"];
    [parDic setValue:[locationDic objectForKey:@"regioncode"] forKey:@"district"];
    [parDic setValue:@"ALL" forKey:@"isneed"];
    NSString* parStr=[[NetRequestManager sharedInstance] DataToJsonString:parDic];
    
    NSMutableDictionary* DIC=[[NSMutableDictionary alloc]init];
    [DIC setObject:parStr forKey:@"paraMap"];
    [self searchClient:DIC];
   
    NSLog(@"%@",locationDic);
}


//添加客户按钮
- (IBAction)addClientClick:(id)sender {
    
}

//位置按钮
- (IBAction)locationClick:(id)sender {
}



@end
