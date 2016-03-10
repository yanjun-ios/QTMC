//
//  PerformanceViewController.m
//  MYT
//
//  Created by 熊凯 on 15/12/12.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import "PerformanceViewController.h"
#import "Utility.h"
@interface PerformanceViewController ()
{
    /*UILabel* rank;
    UILabel* name;
    UILabel* mony;*/
    
    __block NSDictionary* jsonDic;
    NSString* TheTeamid;
    NSString* TheUserid;
    int Year;
    int Month;
}
@end

@implementation PerformanceViewController

-(void)viewWillAppear:(BOOL)animated
{
    [[Utility sharedInstance] setLayerView:_topView borderW:2 borderColor:[UIColor redColor] radius:5];
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewDidLoad {
    //消除多余空白行
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_tableview setTableFooterView:view];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    //获取当前月份
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
     Year = [dateComponent year];
     Month = [dateComponent month];
   TheTeamid = [[NSUserDefaults standardUserDefaults] objectForKey:@"dep_id"];
   TheUserid=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    [self btnFirstClick:_btnFirst];
    
        [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[jsonDic objectForKey:@"list"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identif=@"cell";
    
    UITableViewCell* cell=[_tableview dequeueReusableCellWithIdentifier:identif];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identif];
        //排名
        UILabel* rank;
        rank=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, 100, 15)];
        rank.tag=110;
        rank.textColor=[UIColor darkGrayColor];
        rank.font=[UIFont systemFontOfSize:14];
        rank.textAlignment=NSTextAlignmentCenter;
        [cell.contentView addSubview:rank];
        //姓名
        UILabel* name;
        name=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, 100, 15)];
        name.center=cell.center;
        name.tag=111;
        name.textColor=[UIColor darkGrayColor];
        name.font=[UIFont systemFontOfSize:14];
        name.textAlignment=NSTextAlignmentCenter;
        [cell.contentView addSubview:name];
        //业绩
        UILabel* mony;
        mony=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-100, 15, 100, 15)];
        mony.tag=112;
        mony.textColor=[UIColor darkGrayColor];
        mony.font=[UIFont systemFontOfSize:14];
        mony.textAlignment=NSTextAlignmentCenter;
        [cell.contentView addSubview:mony];
    }
    
    UILabel* label1=(UILabel*)[cell.contentView viewWithTag:110];
    label1.text=[NSString stringWithFormat:@"第%d名",[indexPath row]+1];
    UILabel* label2=(UILabel*)[cell.contentView viewWithTag:111];
    label2.text=[[[jsonDic objectForKey:@"list"] objectAtIndex:[indexPath row]] objectForKey:@"staffname"];
    UILabel* label3=(UILabel*)[cell.contentView viewWithTag:112];
    label3.text=[[[jsonDic objectForKey:@"list"] objectAtIndex:[indexPath row]] objectForKey:@"rate"];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnFirstClick:(id)sender {
    _btnFirst.backgroundColor=[UIColor redColor];
    [_btnFirst setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _btnSecond.backgroundColor=[UIColor clearColor];
    [_btnSecond setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self getteamDataByYear:[NSString stringWithFormat:@"%d",Year] beginMonth:[NSString stringWithFormat:@"%d",Month] endMonth:[NSString stringWithFormat:@"%d",Month] teamId:TheTeamid userId:TheUserid];
}

- (IBAction)btnSecondClick:(id)sender {
    _btnSecond.backgroundColor=[UIColor redColor];
    [_btnSecond setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _btnFirst.backgroundColor=[UIColor clearColor];
    [_btnFirst setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self getteamDataByYear:[NSString stringWithFormat:@"%d",Year] beginMonth:@"1" endMonth:@"12" teamId:TheTeamid userId:TheUserid];
}

-(void)getteamDataByYear:(NSString*)year beginMonth:(NSString*)bengin endMonth:(NSString*)end teamId:(NSString*)teamid userId:(NSString*)userid
{
    NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
    [parDic setValue:year forKey:@"year"];
    [parDic setValue:bengin forKey:@"monthS"];
    [parDic setValue:end forKey:@"monthE"];
    [parDic setValue:teamid forKey:@"depid"];
    [parDic setValue:userid forKey:@"userid"];
    [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingPathComponent:@"yd/getDepStaffList.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        jsonDic = (NSDictionary*)responseObject;
       
       // int curfeat=((NSNumber*)[jsonDic objectForKey:@"curfeat"]).intValue;
        _labSelf.text=[[jsonDic objectForKey:@"curfeat"] stringByAppendingString:@"￥"];
        
        int ranking=((NSNumber*)[jsonDic objectForKey:@"ranking"]).intValue;
        _labRank.text=[NSString stringWithFormat:@"%d",ranking];
        [_tableview reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self qq_performSVHUDBlock:^{
            [SVProgressHUD showErrorWithStatus:@"数据请求错误，请检查网络！"];
        }];
        
    }];
}


@end
