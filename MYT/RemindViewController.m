//
//  RemindViewController.m
//  MYT
//
//  Created by YUNRUIMAC on 15/12/8.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import "RemindViewController.h"
#import "MateclientViewController.h"
#import "MateProjectViewController.h"
#import "ButtomView.h"
#import "QQRequestManager.h"
#import "MJRefresh.h"
@interface RemindViewController ()
{
    int num;
   __block NSMutableArray* jsonarry;
    NSString* rmdidToRight;//传本次提醒的id参数给详情页面
    NSString* cusIdToRight;//传递客户id给详情页面
}
@end

@implementation RemindViewController

- (void)viewDidLoad {
    jsonarry=[[NSMutableArray alloc]init];
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftItemsSupplementBackButton=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if (currentVersion <= 6.1) {
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    } else {
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        CGRect statusRe = [[UIApplication sharedApplication] statusBarFrame];
        UIView* status=[[UIView alloc]initWithFrame:CGRectMake(0, -20, statusRe.size.width, statusRe.size.height)];
        status.backgroundColor=[UIColor whiteColor];
        [self.navigationController.navigationBar addSubview:status];
    }
    
    ButtomView* BtmV=[[ButtomView alloc]initWithFrame:CGRectMake(0, ScreenHeight-114, ScreenWidth, 50)];
    [self.view addSubview:BtmV];
    
    //消除多余空白行
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_tableview setTableFooterView:view];
    
    //设置刷新
    num=1;
    _tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loaData)];
    _tableview.mj_footer.automaticallyHidden = NO;
    [_tableview.mj_footer beginRefreshing];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // return 4;
    return (int)([[[jsonarry objectAtIndex:section] objectForKey:@"follows"] count])+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{return  25;}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [jsonarry count];
   // return 2;
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{//这儿改的时候根据section integer
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableview.frame.size.width, 25)];
    UILabel *remindtime=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _tableview.frame.size.width,20)];
    
    //remindtime.text=@"2015年8月14日入库";
   remindtime.text=[[jsonarry objectAtIndex:section] objectForKey:@"rmdtime"];
    remindtime.font=[UIFont fontWithName:@"ArialMT" size:14];
    remindtime.textAlignment=NSTextAlignmentCenter;
    remindtime.textColor=[UIColor orangeColor];//入库时间
    
    /*UIView *kindofpro=[[UIView alloc]initWithFrame:CGRectMake(0,25, _tableview.frame.size.width, 35)];
    kindofpro.backgroundColor=[UIColor whiteColor];//产品种类等
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    [kindofpro addGestureRecognizer:tapGesture];//添加view的点击事件
    
    UILabel *countofkind=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, _tableview.frame.size.width/5, 20)];
    countofkind.textColor=[UIColor grayColor];
    countofkind.text=@"产品种类";
    countofkind.font=[UIFont fontWithName:@"ArialMT" size:14];
    UILabel* count1=[[UILabel alloc]initWithFrame:CGRectMake(20+_tableview.frame.size.width/6, 5, _tableview.frame.size.width/6, 20)];
    count1.textColor=[UIColor blackColor];
    count1.text=@"20";
    count1.font=[UIFont fontWithName:@"ArialMT" size:18];
    
    UILabel *countofmatch=[[UILabel alloc]initWithFrame:CGRectMake(10+_tableview.frame.size.width/3, 5, _tableview.frame.size.width/6, 20)];
    countofmatch.textColor=[UIColor grayColor];
    countofmatch.text=@"匹配数";
    countofmatch.font=[UIFont fontWithName:@"ArialMT" size:14];
    UILabel* count2=[[UILabel alloc]initWithFrame:CGRectMake(10+_tableview.frame.size.width/2, 5, _tableview.frame.size.width/6, 20)];
    count2.textColor=[UIColor blackColor];
    count2.text=@"50";
    count2.font=[UIFont fontWithName:@"ArialMT" size:18];
    
    UILabel *unfollowed=[[UILabel alloc]initWithFrame:CGRectMake(_tableview.frame.size.width*2/3, 5, _tableview.frame.size.width/5, 20)];
    unfollowed.textColor=[UIColor grayColor];
    unfollowed.text=@"未跟进数";
    unfollowed.font=[UIFont fontWithName:@"ArialMT" size:14];
    UILabel* count3=[[UILabel alloc]initWithFrame:CGRectMake(10+_tableview.frame.size.width*5/6, 5, _tableview.frame.size.width/6, 20)];
    count3.textColor=[UIColor blackColor];
    count3.text=@"20";
    count3.font=[UIFont fontWithName:@"ArialMT" size:18];
    
    [kindofpro addSubview:count3];
    [kindofpro addSubview:unfollowed];
    [kindofpro addSubview:count2];
    [kindofpro addSubview:countofmatch];
    [kindofpro addSubview:count1];
    [kindofpro addSubview:countofkind];
    [view addSubview:kindofpro];*/
    [view addSubview:remindtime];
    return view;
}
-(void)Actiondo:(id)sender
{
    [self performSegueWithIdentifier:@"toclient" sender:self];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        rmdidToRight=[[jsonarry objectAtIndex:indexPath.section] objectForKey:@"rmdid"];

        [self performSegueWithIdentifier:@"toclient" sender:self];
        }
    else{
        NSArray* follows=[[jsonarry objectAtIndex:indexPath.section] objectForKey:@"follows"];
        NSDictionary* DIc=[follows objectAtIndex:indexPath.row-1];
        cusIdToRight=[DIc objectForKey:@"dtlid"];
    [self performSegueWithIdentifier:@"tomate" sender:self];
        
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toclient"]) {
        MateclientViewController* destination=[segue destinationViewController];
        destination.rmdid=rmdidToRight;
    }
    else if ([segue.identifier isEqualToString:@"tomate"])
    {
        MateProjectViewController* destination=[segue destinationViewController];
        destination.cusId=cusIdToRight;
    }
}//有数据传参数
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        UITableViewCell *cell=[_tableview dequeueReusableCellWithIdentifier:@"cell3"];
        if(!cell)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
            cell.contentView.backgroundColor=[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0];
            //设置产品种类
            UILabel* productType=[[UILabel alloc]initWithFrame:CGRectMake(20, 12, 150, 20)];
            productType.font=[UIFont systemFontOfSize:14];
            productType.textColor=[UIColor darkGrayColor];
            productType.tag=1000;
            productType.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:productType];

            //设置产品匹配数
            UILabel* mateNum=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
            mateNum.center=CGPointMake(ScreenWidth/2, 22);
            mateNum.font=[UIFont systemFontOfSize:14];
            mateNum.textColor=[UIColor darkGrayColor];
            mateNum.tag=1001;
            mateNum.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:mateNum];
            
            //设置未跟进数
            UILabel* NotFollow=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-170, 12, 150, 20)];
            NotFollow.font=[UIFont systemFontOfSize:14];
            NotFollow.textColor=[UIColor darkGrayColor];
            NotFollow.tag=1002;
            NotFollow.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:NotFollow];
        }
//        ((UILabel*)[cell.contentView viewWithTag:1000]).text=[NSString stringWithFormat:@"产品种类 20"];
//        ((UILabel*)[cell.contentView viewWithTag:1001]).text=[NSString stringWithFormat:@"匹配数 20"];
//        ((UILabel*)[cell.contentView viewWithTag:1002]).text=[NSString stringWithFormat:@"未跟进数 20"];
        NSDictionary* follows=[jsonarry objectAtIndex:[indexPath section]];
        
        ((UILabel*)[cell.contentView viewWithTag:1000]).text=[NSString stringWithFormat:@"产品数 %@",[follows objectForKey:@"ctmat"]];
        ((UILabel*)[cell.contentView viewWithTag:1001]).text=[NSString stringWithFormat:@"匹配数 %@",[follows objectForKey:@"ctmatch"]];
        ((UILabel*)[cell.contentView viewWithTag:1002]).text=[NSString stringWithFormat:@"未跟进数 %@",[follows objectForKey:@"ctun"]];
        return cell;
    }
    else
    {
        UITableViewCell *cell1=[_tableview dequeueReusableCellWithIdentifier:@"cell4"];
        if(!cell1)
        {
            cell1=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
            //公司名
            UILabel* company=[[UILabel alloc]initWithFrame:CGRectMake(20, 12, 150, 20)];
            company.font=[UIFont systemFontOfSize:14];
            company.textColor=[UIColor darkGrayColor];
            company.tag=10000;
            [cell1.contentView addSubview:company];
            
            //设置产品种类匹配数
            UILabel* mateNum=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-80, 12, 40, 20)];
            mateNum.font=[UIFont systemFontOfSize:14];
            mateNum.textColor=[UIColor redColor];
            mateNum.tag=10001;
            mateNum.textAlignment=NSTextAlignmentCenter;
            [cell1.contentView addSubview:mateNum];
            
            //设置向右边的箭头
            UIImageView* rightImg=[[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-20, 14, 10, 15)];
            [rightImg setImage:[UIImage imageNamed:@"向右"]];
            [cell1.contentView addSubview:rightImg];
        }
        NSArray* follows=[[jsonarry objectAtIndex:[indexPath section]] objectForKey:@"follows"];
        NSDictionary* cus= [follows objectAtIndex:[indexPath row]-1];
        ((UILabel*)[cell1.contentView viewWithTag:10000]).text=[cus objectForKey:@"cusname"];
        ((UILabel*)[cell1.contentView viewWithTag:10001]).text=((NSNumber*)[cus objectForKey:@"ctcusmatch"]).stringValue;
//        ((UILabel*)[cell1.contentView viewWithTag:10000]).text=@"huadenumye";
//        ((UILabel*)[cell1.contentView viewWithTag:10001]).text=@"30";
        return cell1;
    }
}

-(void)loaData
{
   NSString* userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSMutableDictionary* parDic=[[NSMutableDictionary alloc]init];
    [parDic setValue:[NSString stringWithFormat:@"%d",num] forKey:@"pageNum"];
    [parDic setValue:@"3" forKey:@"pageSize"];
     [parDic setValue:userid forKey:@"userid"];
    [[QQRequestManager sharedRequestManager]GET:[SEVER_URL stringByAppendingString:@"yd/getPushInfo.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        num++;
        NSArray* arr=[(NSDictionary*)responseObject objectForKey:@"list"];
        [jsonarry addObjectsFromArray:arr];
        
        [_tableview reloadData];
        [_tableview.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self qq_performSVHUDBlock:^{
            [SVProgressHUD showErrorWithStatus:@"数据请求错误！"];
            [_tableview.mj_footer endRefreshing];
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
