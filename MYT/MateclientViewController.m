//
//  MateclientViewController.m
//  MYT
//
//  Created by YUNRUIMAC on 15/12/9.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import "MateclientViewController.h"
#import "MateProjectViewController.h"
#import "ButtomView.h"
#import "QQRequestManager.h"
#import "MJRefresh.h"
#import "ContactsTableViewController.h"
@interface MateclientViewController ()
{
    int num;
    __block NSMutableArray* jsonarry;
    __block NSDictionary* jsondic;
    NSString* dtlid;
    NSString* cusid;
}
@end

@implementation MateclientViewController

- (void)viewDidLoad {
    jsonarry=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftItemsSupplementBackButton=NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
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
    
    //设置刷新
    num=1;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [jsonarry count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        UITableViewCell *cell=[_tableview dequeueReusableCellWithIdentifier:@"cell3"];
        if(!cell)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
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
        
        ((UILabel*)[cell.contentView viewWithTag:1000]).text=[NSString stringWithFormat:@"产品种类 %@",[jsondic objectForKey:@"ctmat"]];
        ((UILabel*)[cell.contentView viewWithTag:1001]).text=[NSString stringWithFormat:@"匹配数 %@",[jsondic objectForKey:@"ctmatch"]];
        ((UILabel*)[cell.contentView viewWithTag:1002]).text=[NSString stringWithFormat:@"未跟进数 %@",[jsondic objectForKey:@"ctun"]];
        return cell;
    }
    else
    {
        UITableViewCell *cell1=[_tableview dequeueReusableCellWithIdentifier:@"cell4"];
        if(!cell1)
        {
            cell1=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
            //跟进对勾标志
            UIImageView* duigou=[[UIImageView alloc]initWithFrame:CGRectMake(20, 14, 10, 15)];
            duigou.tag=10000;
            //[duigou setImage:[UIImage imageNamed:@"对号20-20"]];
            [cell1.contentView addSubview:duigou];
            //公司名
            UILabel* company=[[UILabel alloc]initWithFrame:CGRectMake(40, 12, 150, 20)];
            company.font=[UIFont systemFontOfSize:14];
            company.textColor=[UIColor darkGrayColor];
            company.tag=10001;
            //company.text=@"青岛画的木业公司";
            [cell1.contentView addSubview:company];
            
            //设置产品种类匹配数
            UILabel* mateNum=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2+20, 12, 40, 20)];
            mateNum.font=[UIFont systemFontOfSize:14];
            mateNum.textColor=[UIColor redColor];
            mateNum.tag=10002;
            //mateNum.textAlignment=NSTextAlignmentCenter;
            //mateNum.text=@"30";
            [cell1.contentView addSubview:mateNum];
            
            //设置电话按钮
            UIButton* btnPhone=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-90, 7, 30, 30)];
            [btnPhone setImage:[UIImage imageNamed:@"电话小"] forState:0];
            [cell1.contentView addSubview:btnPhone];
            btnPhone.tag=10003;
            //设置放弃按钮
            UIButton* abandon=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-50, 7, 30, 30)];
            [abandon setTitle:@"放弃" forState:UIControlStateNormal];
            [abandon setTitleColor:[UIColor darkGrayColor] forState:0];
            abandon.titleLabel.font=[UIFont systemFontOfSize:12];
            abandon.tag=10004;
            [cell1.contentView addSubview:abandon];
        }
        
        NSDictionary* cus= [jsonarry objectAtIndex:[indexPath row]-1];
        int status=((NSNumber*)[cus objectForKey:@"status"]).intValue;
         UIImageView* genjin= (UIImageView*)[cell1.contentView viewWithTag:10000];
        
        //电话按钮
        UIButton* btnPhon=(UIButton*)[cell1.contentView viewWithTag:10003];
        btnPhon.tag=100000+[indexPath row];
        [btnPhon addTarget:self action:@selector(clickPhone:) forControlEvents:UIControlEventTouchUpInside];
        //放弃按钮
        UIButton* aband=(UIButton*)[cell1.contentView viewWithTag:10004];
        aband.tag=100000+[indexPath row];
        [aband addTarget:self action:@selector(clickaband:) forControlEvents:UIControlEventTouchUpInside];
        switch (status) {
            case 0:
                //未跟进
                break;
            case 1:
                //已跟进
                genjin.image=[UIImage imageNamed:@"对号20-20"];
                
                break;
            case 2:
                //已放弃
                aband.enabled=NO;
                break;
                
            default:
                break;
        }
        
        ((UILabel*)[cell1.contentView viewWithTag:10001]).text=[cus objectForKey:@"cusname"];
        ((UILabel*)[cell1.contentView viewWithTag:10002]).text=[((NSNumber*)[cus objectForKey:@"ctcusmatch"]) stringValue];
        
        return cell1;
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0,0, _tableview.frame.size.width, 25)];
    UILabel *remindtime=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, _tableview.frame.size.width,20)];
    remindtime.text=[jsondic objectForKey:@"rmdtime"];
    remindtime.font=[UIFont fontWithName:@"ArialMT" size:14];
    remindtime.textAlignment=NSTextAlignmentCenter;
    remindtime.textColor=[UIColor orangeColor];//入库时间
    
    [view addSubview:remindtime];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{return  26;}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0) {
        dtlid=[[jsonarry objectAtIndex:indexPath.row-1] objectForKey:@"dtlid"];
        [self performSegueWithIdentifier:@"detail" sender:self];
    }
    
   
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detail"]) {
        MateProjectViewController* destination=[segue destinationViewController];
        destination.cusId=dtlid;
    }
    if ([segue.identifier isEqualToString:@"toContact"]) {
        ContactsTableViewController* destination=[segue destinationViewController];
        destination.cusid=cusid;
        destination.dtlid=dtlid;
    }

}

-(void)loaData
{
    NSString* userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSMutableDictionary* parDic=[[NSMutableDictionary alloc]init];
    [parDic setValue:[NSString stringWithFormat:@"%d",num] forKey:@"pageNum"];
    [parDic setValue:@"10" forKey:@"pageSize"];
    [parDic setValue:userid forKey:@"userid"];
    [parDic setValue:_rmdid forKey:@"rmdid"];
    [[QQRequestManager sharedRequestManager]GET:[SEVER_URL stringByAppendingString:@"yd/getMatchInfo.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        num++;
        jsondic=(NSDictionary*)responseObject;
        NSArray* arr=[jsondic objectForKey:@"follows"];
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

//打电话按钮
-(void)clickPhone:(UIButton*)btn
{
    //跳转到客户资料的通讯录
    int index=btn.tag-100000;
  dtlid=  [[jsonarry objectAtIndex:index-1] objectForKey:@"dtlid"];
   cusid= [[jsonarry objectAtIndex:index-1] objectForKey:@"cusid"];
    [self performSegueWithIdentifier:@"toContact" sender:self];
}

//放弃按钮
-(void)clickaband:(UIButton*)btn
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"请输入放弃理由"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    // 基本输入框，显示实际输入的内容
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //设置输入框的键盘类型
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeDefault;
   // NSString* text = tf.text;
   int index=  btn.tag-100000;
    dtlid=[[jsonarry objectAtIndex:index-1] objectForKey:@"dtlid"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSString* text = ((UITextField*)[alertView textFieldAtIndex:0]).text;
        NSString* userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
        NSMutableDictionary* parDic=[[NSMutableDictionary alloc]init];
        [parDic setValue:dtlid forKey:@"dtlid"];
        [parDic setValue:userid forKey:@"userid"];
        [parDic setValue:text forKey:@"gpReason"];
        [[QQRequestManager sharedRequestManager]GET:[SEVER_URL stringByAppendingString:@"yd/giveupCall.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            int status= ((NSNumber*)[responseObject objectForKey:@"status"]).intValue;
            if (status==1) {
                [self qq_performSVHUDBlock:^{
                    [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
                    [_tableview.mj_footer endRefreshing];
                }];
            }else
            {
                [self qq_performSVHUDBlock:^{
                    [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
                    [_tableview.mj_footer endRefreshing];
                }];
            }
            

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self qq_performSVHUDBlock:^{
                [SVProgressHUD showErrorWithStatus:@"数据请求错误！"];
                [_tableview.mj_footer endRefreshing];
            }];
        }];
    }
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
