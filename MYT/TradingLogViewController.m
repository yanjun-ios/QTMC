//
//  TradingLogViewController.m
//  MYT
//
//  Created by 熊凯 on 16/1/11.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import "TradingLogViewController.h"
#import "NetRequestManager.h"
#import "QQRequestManager.h"
#import "MJRefresh.h"
@interface TradingLogViewController ()
{
    NSString* clientId;
    int num;
    NSMutableArray* arry;

}
@end

@implementation TradingLogViewController

- (void)viewDidLoad {
    if(currentVersion>=7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.title=@"业务日志";
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
    //接口有问题
    [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingString:@"yd/getCusbusinessList.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        num++;
        NSDictionary* dic=responseObject;
        NSArray* trading_record=[dic objectForKey:@"businessLog"];
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
        //业务日志
        UILabel* trading_dlvdate=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 20)];
        trading_dlvdate.font=[UIFont systemFontOfSize:14];
        trading_dlvdate.textColor=[UIColor darkGrayColor];
        trading_dlvdate.text=@"拜访时间";
        [cell.contentView addSubview:trading_dlvdate];
        //拜访时间lab
        UILabel* dlvdate=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 200, 20)];
        dlvdate.font=[UIFont systemFontOfSize:14];
        dlvdate.textColor=[UIColor darkGrayColor];
        dlvdate.tag=1000;
        [cell.contentView addSubview:dlvdate];
        
        //接待人
        UILabel* trading_obdcode=[[UILabel alloc]initWithFrame:CGRectMake(20, 40, 100, 20)];
        trading_obdcode.font=[UIFont systemFontOfSize:14];
        trading_obdcode.textColor=[UIColor darkGrayColor];
        trading_obdcode.text=@"接待人";
        [cell.contentView addSubview:trading_obdcode];
        
        //接待人lab
        UILabel* obdcode=[[UILabel alloc]initWithFrame:CGRectMake(105, 40, 300, 20)];
        obdcode.font=[UIFont systemFontOfSize:14];
        obdcode.textColor=[UIColor darkGrayColor];
        obdcode.tag=1001;
        [cell.contentView addSubview:obdcode];
    }
    
        ((UILabel*)[cell.contentView viewWithTag:1000]).text=[[arry objectAtIndex:[indexPath row]] objectForKey:@"visite_time"];
         ((UILabel*)[cell.contentView viewWithTag:1001]).text=[[arry objectAtIndex:[indexPath row]] objectForKey:@"receiver"];
//    ((UILabel*)[cell.contentView viewWithTag:1000]).text=@"2012-12-31";
//    ((UILabel*)[cell.contentView viewWithTag:1001]).text=@"张娟丽";
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arry count];
   // return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
