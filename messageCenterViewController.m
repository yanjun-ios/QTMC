//
//  messageCenterViewController.m
//  MYT
//
//  Created by 熊凯 on 15/12/11.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import "messageCenterViewController.h"
#import "ButtomView.h"
#import "MJRefresh.h"
#import "QQRequestManager.h"
#import "Utility.h"
#import "messageDetailViewController.h"
@interface messageCenterViewController ()
{
    int num;
    NSMutableArray* jsonlist;
    NSString* detail;
}
@end

@implementation messageCenterViewController

- (void)viewDidLoad {
    jsonlist=[[NSMutableArray alloc]init];
    num=1;
     _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loaData)];
    _tableView.mj_footer.automaticallyHidden = NO;
    [_tableView.mj_footer beginRefreshing];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //消除多余空白行
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_tableView  setTableFooterView:view];
    _tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    //添加底部菜单栏
    ButtomView* BtmV=[[ButtomView alloc]initWithFrame:CGRectMake(0,ScreenHeight-50, ScreenWidth, 50)];
    [self.view addSubview:BtmV];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//设置分割线
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [jsonlist count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* identif=@"cell";
    
    UITableViewCell* cell=[self.tableView dequeueReusableCellWithIdentifier:identif];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identif];
        //初始化时间标签
        UILabel* lab_time=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-110, 8, 110, 20)];
        lab_time.font=[UIFont systemFontOfSize:12];
        lab_time.textColor=[UIColor lightGrayColor];
        lab_time.tag=100;
        [cell.contentView addSubview:lab_time];
        //初始化图片
        UIImageView* img=[[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 40, 40)];
        img.tag=101;
        [cell.contentView addSubview:img];
        
        //初始化title
        UILabel* lab_title=[[UILabel alloc]initWithFrame:CGRectMake(55, 8, 150, 20)];
        lab_title.font=[UIFont systemFontOfSize:14];
        lab_title.textColor=[UIColor darkGrayColor];
        lab_title.tag=102;
        [cell.contentView addSubview:lab_title];
        
        //初始化detail
        UILabel* lab_detail=[[UILabel alloc]initWithFrame:CGRectMake(55, 30, 200, 20)];
        lab_detail.font=[UIFont systemFontOfSize:14];
        lab_detail.textColor=[UIColor lightGrayColor];
        lab_detail.tag=103;
        [cell.contentView addSubview:lab_detail];
    }
    int type=((NSNumber*)[[jsonlist objectAtIndex:[indexPath row]] objectForKey:@"TYPE"]).intValue;
    
    switch (type) {
        case 0:
           ((UIImageView*)[cell.contentView viewWithTag:101]).image=[UIImage imageNamed:@"入库提醒"];
            break;
        case 1:
            ((UIImageView*)[cell.contentView viewWithTag:101]).image=[UIImage imageNamed:@"放假通知"];
            break;
        case 2:
            ((UIImageView*)[cell.contentView viewWithTag:101]).image=[UIImage imageNamed:@"通知公告"];
            break;
        case 3:
            ((UIImageView*)[cell.contentView viewWithTag:101]).image=[UIImage imageNamed:@"通知公告"];
            break;
        default:
            break;
    }
    
   ((UILabel*)[cell.contentView viewWithTag:102]).text=[[jsonlist objectAtIndex:[indexPath row]] objectForKey:@"TITLE"];
   ((UILabel*)[cell.contentView viewWithTag:103]).text=[[jsonlist objectAtIndex:[indexPath row]] objectForKey:@"CONT"];
    ((UILabel*)[cell.contentView viewWithTag:100]).text=[[jsonlist objectAtIndex:[indexPath row]] objectForKey:@"TIME"];
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    detail=[[jsonlist objectAtIndex:[indexPath row]] objectForKey:@"CONT"];
    [self performSegueWithIdentifier:@"detail" sender:self];
}

-(void)loaData
{
   NSString* userid= [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSMutableDictionary* parDic=[[NSMutableDictionary alloc]init];
    [parDic setObject:userid forKey:@"userid"];
    [parDic setObject:[NSString stringWithFormat:@"%d",num] forKey:@"pageNum"];
    [parDic setObject:@"10" forKey:@"pageSize"];
    [[QQRequestManager sharedRequestManager]GET:[SEVER_URL stringByAppendingString:@"yd/getMsgList.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        num++;
        [jsonlist addObjectsFromArray:[(NSDictionary*)responseObject objectForKey:@"list"]];
        [_tableView reloadData];
        [_tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self qq_performSVHUDBlock:^{
            [SVProgressHUD showErrorWithStatus:@"数据请求错误！"];
             [_tableView.mj_footer endRefreshing];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detail"]) {
        messageDetailViewController* destination=[segue destinationViewController];
        destination.getMessageDetail=detail;
    }
}


@end
