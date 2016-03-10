//
//  CusMarkViewController.m
//  MYT
//
//  Created by 熊凯 on 16/1/11.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import "CusMarkViewController.h"
#import "NetRequestManager.h"
#import "QQRequestManager.h"
#import "MJRefresh.h"
@interface CusMarkViewController ()
{
    NSString* clientId;
    int num;
    NSMutableArray* arry;

}
@end

@implementation CusMarkViewController

-(void)viewDidAppear:(BOOL)animated
{
    [_tableview reloadData];
}

- (void)viewDidLoad {
    _tableview.rowHeight=UITableViewAutomaticDimension;
    _tableview.estimatedRowHeight=44.0;//这个必须加上，否则出现高度无法自适应问题。
    
    if(currentVersion>=7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

     [super viewDidLoad];
    self.title=@"备注列表";
    arry=[[NSMutableArray alloc]init];
    num=1;
    clientId=[NetRequestManager sharedInstance].clientId;
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loaData)];
    _tableview.mj_footer.automaticallyHidden =YES;
    [_tableview.mj_footer beginRefreshing];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.sectionFooterHeight=0;
    _tableview.sectionHeaderHeight=10;
    _tableview.rowHeight=UITableViewAutomaticDimension;
    _tableview.estimatedRowHeight=44.0;//这个必须加上，否则出现高度无法自适应问题。
    
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
   // 获取备注列表的接口没有
    [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingString:@"yd/getCusRemarkList.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        num++;
        NSDictionary* dic=responseObject;
        NSArray* trading_record=[dic objectForKey:@"cus_remark"];
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
//    if(!cell)
//    {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
//        
//        //时间
//        UILabel* labtime=[[UILabel alloc]init];
//        labtime.frame=CGRectMake(10, 8, 200, 15);
//        labtime.font=[UIFont systemFontOfSize:12];
//        labtime.textColor=[UIColor darkGrayColor];
//        labtime.tag=1000;
//        [cell.contentView addSubview:labtime];
//        
//        //备注
//        UILabel* labmark=[[UILabel alloc]init];
//        labmark.frame=CGRectMake(10, 20, ScreenWidth-20, 60);
//        labmark.font=[UIFont systemFontOfSize:12];
//        labmark.textColor=[UIColor darkGrayColor];
//        labmark.lineBreakMode=NSLineBreakByWordWrapping;
//        labmark.numberOfLines=0;
//        labmark.tag=1001;
//        [cell.contentView addSubview:labmark];
//    }
    
    ((UILabel*)[cell.contentView viewWithTag:1000]).text=[[arry objectAtIndex:[indexPath row]] objectForKey:@"remdate"];
    ((UILabel*)[cell.contentView viewWithTag:1001]).text=[[arry objectAtIndex:[indexPath row]] objectForKey:@"remark"];
    //((UILabel*)[cell.contentView viewWithTag:1001]).text=@"打工行打款给害死U树肯定就发给你是你告诉大家发个SD卡老师的告诉快递公司上课的感觉是的；开公司的；大客户；SD卡返回的；分开规划";
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arry count];
       // return 5;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 80;
//}

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
