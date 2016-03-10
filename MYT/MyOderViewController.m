//
//  MyOderViewController.m
//  MYT
//
//  Created by 熊凯 on 15/12/11.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import "MyOderViewController.h"
#import "MainViewController.h"
#import "ButtomView.h"
#import "MJRefresh.h"
#import "Utility.h"
#import "Z_NetRequestManager.h"
#import "QuartzCore/QuartzCore.h"
@interface MyOderViewController ()
{
    NSMutableArray * orderdata;
    NSArray *orderlist;
    NIDropDown *dropDown;
}
@end

@implementation MyOderViewController
@synthesize btn_year;
-(void)viewDidAppear:(BOOL)animated
{
    [_mytableview reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSString* year = [NSString stringWithFormat:@"%ld",(long)[dateComponent year]];
    NSString* month =[NSString stringWithFormat:@"%ld",(long)[dateComponent month]];
    [btn_year setTitle:[NSString stringWithFormat:@"%@年",year] forState:0];
    [_btn_FirstMonth setTitle:[NSString stringWithFormat:@"%@月",month] forState:0];
    [_btn_endMonth setTitle:[NSString stringWithFormat:@"%@月",month] forState:0];
    [self Getmyorder:year beginmonth:month endmonth:month];
}
- (void)viewDidLoad {
    //消除多余空白行
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_mytableview setTableFooterView:view];
    
    
    orderdata=[[NSMutableArray alloc]init];
    _mytableview.delegate=self;
    _mytableview.dataSource=self;
    [super viewDidLoad];
    //添加底部菜单栏
    ButtomView* BtmV=[[ButtomView alloc]initWithFrame:CGRectMake(0, ScreenHeight-50, ScreenWidth, 50)];
    [self.view addSubview:BtmV];
    
    //设置年月下拉按钮
    [[Utility sharedInstance]setLayerView:btn_year borderW:1 borderColor:[UIColor redColor] radius:3];
    [[Utility sharedInstance]setLayerView:_btn_FirstMonth borderW:1 borderColor:[UIColor redColor] radius:3];
    [[Utility sharedInstance]setLayerView:_btn_endMonth borderW:1 borderColor:[UIColor redColor] radius:3];
    [btn_year addTarget:self action:@selector(clickBtnYear:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_FirstMonth addTarget:self action:@selector(clickBtnYear:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_endMonth addTarget:self action:@selector(clickBtnYear:) forControlEvents:UIControlEventTouchUpInside];
   
}
- (void)viewDidUnload {
    //    [btnSelect release];
    btn_year = nil;
    [super viewDidUnload];
}
-(void)Getmyorder:(NSString *)year beginmonth:(NSString*)begin endmonth:(NSString*)end
{
//   NSDictionary *dic=[[Z_NetRequestManager sharedInstance]getoderDataByYear:year beginMonth:begin endMonth:end userId:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]];//获取到数据
//    orderlist=[dic objectForKey:@"list"];
    [self getoderDataByYear:year beginMonth:begin endMonth:end userId:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]];
    
}

-(void)clickBtnYear:(UIButton*)sender
{
    NSArray * arr = [[NSArray alloc] init];
    if(sender.tag==120)
    {
        arr = [NSArray arrayWithObjects:@"2015年", @"2016年", @"2017年", @"2018年", @"2019年", @"2020年", @"2021年", @"2022年", @"2023年", @"2024年",nil];
    }else
    {
        arr = [NSArray arrayWithObjects:@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月",@"11月",@"12月",nil];
    }
   
        if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
        }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
   
    [self rel];
    NSString* selectedStr=sender.setcetedStr;
    UIButton* btn=sender.btnSender;
    NSString* firStr = _btn_FirstMonth.titleLabel.text;
    NSString* twostr =  _btn_endMonth.titleLabel.text;
    NSString* yearStr=btn_year.titleLabel.text;
    
    if (btn.tag==120) {
        [self Getmyorder:[selectedStr substringToIndex:(selectedStr.length-1)] beginmonth:[firStr substringToIndex:(firStr.length-1)] endmonth:[twostr substringToIndex:(twostr.length-1)]];
        //点击了年
    }else if(btn.tag==121)
    {
        //点击了第一个月份
        int begin_month=[selectedStr substringToIndex:(selectedStr.length-1)].intValue;
        int end_month= [twostr substringToIndex:(twostr.length-1)].intValue;
        if (begin_month>end_month) {
            //将结束月份的值改为与歧视月份相同
            [_btn_endMonth setTitle:selectedStr forState:UIControlStateNormal];
            twostr=selectedStr;
        }
          [self Getmyorder:[yearStr substringToIndex:(yearStr.length-1)] beginmonth:[selectedStr substringToIndex:(selectedStr.length-1)] endmonth:[twostr substringToIndex:(twostr.length-1)] ];
    }else if(btn.tag==122)
    {
        //点击了第二个月
        int end_month=[selectedStr substringToIndex:(selectedStr.length-1)].intValue;
        int begin_month= [firStr substringToIndex:(firStr.length-1)].intValue;
        if (begin_month>end_month) {
            //将结束月份的值改为与歧视月份相同
            [_btn_FirstMonth setTitle:selectedStr forState:UIControlStateNormal];
            firStr=selectedStr;
        }
         [self Getmyorder:[yearStr substringToIndex:(yearStr.length-1)] beginmonth:[firStr substringToIndex:(firStr.length-1)] endmonth:[selectedStr substringToIndex:(selectedStr.length-1)] ];
        
    }
    

}
-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
-(void)getorderinfor
{
    NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
    [parDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]);
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
        
        NSLog(@"%@",responseObject);
        NSArray *init=[responseObject objectForKey:@"list"];
        for (int i = 0; i<init.count; i++) {
            [data addObject:[init objectAtIndex:i]];
        }
        // [_tableview reloadData];
        NSLog(@"%@",data);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        [self qq_performSVHUDBlock:^{
            [SVProgressHUD showErrorWithStatus:@"账号或密码错误"];
        }];
    }];

}*/
#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return orderlist.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identif=@"cell1";
    UITableViewCell* cell=[_mytableview dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
        //客户名：
        UILabel* name=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 75, 20)];
        name.text=@"客户名称：";
        name.textAlignment=NSTextAlignmentRight;
        name.font=[UIFont systemFontOfSize:14];
        name.textColor=[UIColor darkGrayColor];
        [cell.contentView addSubview:name];
        
        //客户
        UILabel* cusName=[[UILabel alloc]initWithFrame:CGRectMake(90, 10, ScreenWidth-80, 20)];
        cusName.textAlignment=NSTextAlignmentLeft;
        cusName.font=[UIFont systemFontOfSize:14];
        cusName.textColor=[UIColor lightGrayColor];
        cusName.tag=100;
        [cell.contentView addSubview:cusName];
        
        //交易时间：
        UILabel* time=[[UILabel alloc]initWithFrame:CGRectMake(15, 40, 75, 20)];
        time.text=@"交易时间：";
        time.textAlignment=NSTextAlignmentRight;
        time.font=[UIFont systemFontOfSize:14];
        time.textColor=[UIColor darkGrayColor];
        [cell.contentView addSubview:time];
        
        //交易时间
        UILabel* tradTime=[[UILabel alloc]initWithFrame:CGRectMake(90, 40, ScreenWidth-80, 20)];
        tradTime.textAlignment=NSTextAlignmentLeft;
        tradTime.font=[UIFont systemFontOfSize:14];
        tradTime.textColor=[UIColor lightGrayColor];
        tradTime.tag=101;
        [cell.contentView addSubview:tradTime];
        
        //订单编码：
        UILabel* code=[[UILabel alloc]initWithFrame:CGRectMake(15, 70, 75, 20)];
        code.text=@"订单编码：";
        code.textAlignment=NSTextAlignmentRight;
        code.font=[UIFont systemFontOfSize:14];
        code.textColor=[UIColor darkGrayColor];
        [cell.contentView addSubview:code];
        //订单编码
        UILabel* tradCode=[[UILabel alloc]initWithFrame:CGRectMake(90, 70, ScreenWidth-80, 20)];
        tradCode.textAlignment=NSTextAlignmentLeft;
        tradCode.font=[UIFont systemFontOfSize:14];
        tradCode.textColor=[UIColor lightGrayColor];
        tradCode.tag=102;
        [cell.contentView addSubview:tradCode];
        
        //交易金额：
        UILabel* mony=[[UILabel alloc]initWithFrame:CGRectMake(15, 100, 75, 20)];
        mony.text=@"交易金额：";
        mony.textAlignment=NSTextAlignmentRight;
        mony.font=[UIFont systemFontOfSize:14];
        mony.textColor=[UIColor darkGrayColor];
        [cell.contentView addSubview:mony];
        //交易金额
        UILabel* tradMony=[[UILabel alloc]initWithFrame:CGRectMake(90, 100, ScreenWidth-80, 20)];
        tradMony.textAlignment=NSTextAlignmentLeft;
        tradMony.font=[UIFont systemFontOfSize:14];
        tradMony.textColor=[UIColor redColor];
        tradMony.tag=103;
        [cell.contentView addSubview:tradMony];
        
    }
    NSDictionary* dic=[orderlist objectAtIndex:[indexPath section]];
    
    //客户名称
    ((UILabel*)[cell.contentView viewWithTag:100]).text=[dic objectForKey:@"cusname"];
    ((UILabel*)[cell.contentView viewWithTag:101]).text=[dic objectForKey:@"dlvdate"];
     ((UILabel*)[cell.contentView viewWithTag:102]).text=[dic objectForKey:@"obdcode"];
    ((UILabel*)[cell.contentView viewWithTag:103]).text= [NSString stringWithFormat:@"%d￥",[(NSNumber*)[dic objectForKey:@"money"] intValue]];;
    
//    NSString *obdcode=[dic objectForKey:@"obdcode"];//订单编号
//    NSString* cusname=[dic objectForKey:@"cusname"];//客户名称
//    NSString* custtname=[dic objectForKey:@"custtname"];//客户全名
//    NSString *dlydate=[dic objectForKey:@"dlydate"];//订单时间
//    NSString *money=[dic objectForKey:@"money"];
//    ((UILabel*)[cell.contentView viewWithTag:101]).text=cusname;
//     ((UILabel*)[cell.contentView viewWithTag:103]).text=obdcode;
//     ((UILabel*)[cell.contentView viewWithTag:104]).text=dlydate;
//     ((UILabel*)[cell.contentView viewWithTag:105]).text=money;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


-(void)getoderDataByYear:(NSString *)year beginMonth:(NSString *)bengin endMonth:(NSString *)end  userId:(NSString *)userid
{
    NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
    [parDic setValue:year forKey:@"year"];
    [parDic setValue:bengin forKey:@"monthS"];
    [parDic setValue:end forKey:@"monthE"];
    [parDic setValue:userid forKey:@"userid"];
    __block NSDictionary* jsonDic;
    [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingPathComponent:@"yd/getMyOrders.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        jsonDic = (NSDictionary*)responseObject;
        orderlist=[jsonDic objectForKey:@"list"];
        [_mytableview reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.superclass qq_performSVHUDBlock:^{
            [SVProgressHUD showErrorWithStatus:@"数据请求错误，请检查网络！"];
        }];
        
    }];
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
