//
//  CallLogViewController.m
//  MYT
//
//  Created by 熊凯 on 16/1/11.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import "CallLogViewController.h"
#import "NetRequestManager.h"
#import "QQRequestManager.h"
#import "MJRefresh.h"
@interface CallLogViewController ()
{
    NSString* clientId;
    int num;
    NSMutableArray* arry;
}
@end

@implementation CallLogViewController

- (void)viewDidLoad {
    if(currentVersion>=7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.title=@"通话记录";
    arry=[[NSMutableArray alloc]init];
    num=1;
    clientId=[NetRequestManager sharedInstance].clientId;
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loaData)];
    _tableview.mj_footer.automaticallyHidden = NO;
    [_tableview.mj_footer beginRefreshing];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [super viewDidLoad];
    //消除多余空白行
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_tableview setTableFooterView:view];
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
    [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingString:@"yd/getCusCallLogList.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        num++;
        NSDictionary* dic=responseObject;
        NSArray* trading_record=[dic objectForKey:@"call_log"];
        [arry addObjectsFromArray:trading_record];
        [_tableview reloadData];
        [_tableview.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self qq_performSVHUDBlock:^{
            [SVProgressHUD showErrorWithStatus:@"数据请求错误！"];
            [_tableview.mj_footer endRefreshing];
        }];
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
        //姓名
        UILabel* trading_dlvdate=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 50, 20)];
        trading_dlvdate.font=[UIFont systemFontOfSize:14];
        trading_dlvdate.textColor=[UIColor darkGrayColor];
        trading_dlvdate.tag=1000;
        [cell.contentView addSubview:trading_dlvdate];
        //电话
        UILabel* dlvdate=[[UILabel alloc]initWithFrame:CGRectMake(80, 10, 200, 20)];
        dlvdate.font=[UIFont systemFontOfSize:14];
        dlvdate.textColor=[UIColor darkGrayColor];
        dlvdate.tag=1001;
        [cell.contentView addSubview:dlvdate];
        
        //时间
        UILabel* trading_obdcode=[[UILabel alloc]initWithFrame:CGRectMake(20, 40, 150, 20)];
        trading_obdcode.font=[UIFont systemFontOfSize:14];
        trading_obdcode.textColor=[UIColor darkGrayColor];
        trading_obdcode.tag=1002;
        [cell.contentView addSubview:trading_obdcode];
        
        //通话时长
        UILabel* talk_time=[[UILabel alloc]initWithFrame:CGRectMake(180, 40, 70, 20)];
        talk_time.font=[UIFont systemFontOfSize:14];
        talk_time.textColor=[UIColor darkGrayColor];
        talk_time.text=@"通话时长：";
        [cell.contentView addSubview:talk_time];
        //通话时间
        UILabel* obdcode=[[UILabel alloc]initWithFrame:CGRectMake(260, 40, 60, 20)];
        obdcode.font=[UIFont systemFontOfSize:14];
        obdcode.textColor=[UIColor darkGrayColor];
        obdcode.tag=1003;
        [cell.contentView addSubview:obdcode];
    }
    
    ((UILabel*)[cell.contentView viewWithTag:1000]).text=[[arry objectAtIndex:[indexPath row]] objectForKey:@"contactsname"];
    ((UILabel*)[cell.contentView viewWithTag:1001]).text=[[arry objectAtIndex:[indexPath row]] objectForKey:@"call_phone"];
      ((UILabel*)[cell.contentView viewWithTag:1002]).text=[[arry objectAtIndex:[indexPath row]] objectForKey:@"call_time"];
    ((UILabel*)[cell.contentView viewWithTag:1003]).text=[[[arry objectAtIndex:[indexPath row]] objectForKey:@"talk_time"] stringByAppendingString:@"分钟"];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arry count];
//     return 10;
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
