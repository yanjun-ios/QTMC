//
//  TradingViewController.m
//  MYT
//
//  Created by 熊凯 on 16/1/10.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import "TradingViewController.h"
#import "NetRequestManager.h"
#import "QQRequestManager.h"
@interface TradingViewController ()
{
    NSString* clientId;
    int num;
    NSMutableArray* arry;
}
@end

@implementation TradingViewController

- (void)viewDidLoad {
    if(currentVersion>=7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.title=@"交易记录";
    
    arry=[[NSMutableArray alloc]init];
    num=1;
    clientId=[NetRequestManager sharedInstance].clientId;
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loaData)];
    _tableview.mj_footer.automaticallyHidden = NO;
    [_tableview.mj_footer beginRefreshing];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    //消除多余空白行
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_tableview setTableFooterView:view];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)loaData
{
    NSString* NUM = [NSString stringWithFormat:@"%d",num];
    NSString* cusid=clientId;
    NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
    [parDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];
    [parDic setObject:cusid forKey:@"cusid"];
    [parDic setObject:@5 forKey:@"pageSize"];
    [parDic setObject:NUM forKey:@"pageNum"];
    [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingString:@"yd/getTradList.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        num++;
        NSDictionary* dic=responseObject;
        NSArray* trading_record=[dic objectForKey:@"trading_record"];
        [arry addObjectsFromArray:trading_record];
        [_tableview reloadData];
        [_tableview.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

//taleview代理方法
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifi=@"cell";
    UITableViewCell* cell;
    cell=[_tableview dequeueReusableCellWithIdentifier:identifi];
    if(!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
        //交易时间
        UILabel* trading_dlvdate=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
        trading_dlvdate.font=[UIFont systemFontOfSize:14];
        trading_dlvdate.textColor=[UIColor darkGrayColor];
        trading_dlvdate.text=@"交易时间";
        [cell.contentView addSubview:trading_dlvdate];
        //交易时间lab
        UILabel* dlvdate=[[UILabel alloc]initWithFrame:CGRectMake(105, 10, 200, 20)];
        dlvdate.font=[UIFont systemFontOfSize:14];
        dlvdate.textColor=[UIColor darkGrayColor];
        dlvdate.tag=1000;
        [cell.contentView addSubview:dlvdate];
        
        //订单编码
        UILabel* trading_obdcode=[[UILabel alloc]initWithFrame:CGRectMake(20, 30, 100, 20)];
        trading_obdcode.font=[UIFont systemFontOfSize:14];
        trading_obdcode.textColor=[UIColor darkGrayColor];
        trading_obdcode.text=@"订单编码";
         [cell.contentView addSubview:trading_obdcode];
        
        //订单编码lab
        UILabel* obdcode=[[UILabel alloc]initWithFrame:CGRectMake(105, 30, 300, 20)];
        obdcode.font=[UIFont systemFontOfSize:14];
        obdcode.textColor=[UIColor darkGrayColor];
        obdcode.tag=1001;
        [cell.contentView addSubview:obdcode];
        
        //金额
        UILabel* trading_money=[[UILabel alloc]initWithFrame:CGRectMake(20, 60, 200, 20)];
        trading_money.font=[UIFont systemFontOfSize:14];
        trading_money.textColor=[UIColor redColor];
        trading_money.text=@"交易金额";
         [cell.contentView addSubview:trading_money];
        //金额lab
        UILabel* money=[[UILabel alloc]initWithFrame:CGRectMake(105, 60, 100, 20)];
        money.font=[UIFont systemFontOfSize:14];
        money.textColor=[UIColor redColor];
        money.tag=1002;
        [cell.contentView addSubview:money];
    }
    
    ((UILabel*)[cell.contentView viewWithTag:1000]).text=[[arry objectAtIndex:[indexPath row]] objectForKey:@"trading_dlvdate"];
     ((UILabel*)[cell.contentView viewWithTag:1001]).text=[[arry objectAtIndex:[indexPath row]] objectForKey:@"trading_obdcode"];
     ((UILabel*)[cell.contentView viewWithTag:1002]).text=[[arry objectAtIndex:[indexPath row]] objectForKey:@"trading_money"];
//        ((UILabel*)[cell.contentView viewWithTag:1000]).text=@"2012-12-31";
//         ((UILabel*)[cell.contentView viewWithTag:1001]).text=@"32b425h4u5b5b4u3";
//    ((UILabel*)[cell.contentView viewWithTag:1002]).text=@"1000元";

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [arry count];
//    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
