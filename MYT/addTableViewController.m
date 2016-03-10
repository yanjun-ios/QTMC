//
//  addTableViewController.m
//  MYT
//
//  Created by 熊凯 on 15/12/8.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import "addTableViewController.h"
#import "Z_NetRequestManager.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
@interface addTableViewController ()
{
    UIButton* btnSelected;
    NSString* lati;
    NSString* longi;
    NSMutableDictionary* addcusjson;
    NSDictionary* dic;
     UIAlertView *alert ;
    int qiyeorperson;
    NSDictionary* locationCodeDic;
}
@end

@implementation addTableViewController

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

-(void)viewWillAppear:(BOOL)animated
{

    if(currentVersion>=7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

}

- (void)viewDidLoad {
    //消除多余空白行
    qiyeorperson=1;
    addcusjson=[[NSMutableDictionary alloc]init];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    //设置背景颜色
    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    //设置各个输入框代理方法
    _TF_CusCode.delegate=self;
    _TF_CusName.delegate=self;
    _TF_CusTtName.delegate=self;
    _TF_MobilePhone.delegate=self;
    _TF_Phone.delegate=self;
    _TF_website.delegate=self;
    btnSelected=_btn_qiye;//默认为企业
  
    alert = [[UIAlertView alloc] initWithTitle:@"定位提示"
                                       message:@"客户在你当前位置吗?"
                                      delegate:self
                             cancelButtonTitle:@"NO"
                             otherButtonTitles:@"YES",nil];
    alert.delegate=self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Getlocation:) name:@"coordinate"  object:nil];
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
       [self performSegueWithIdentifier:@"getlocation" sender:self];
        NSLog(@"你点击了取消");
        
    }else if (buttonIndex==1){
        [[Z_NetRequestManager sharedInstance]getlongandlati];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            
            NSDictionary *location=[[Z_NetRequestManager sharedInstance] getlongla];
            lati=[location objectForKey:@"lati"];
            longi=[location objectForKey:@"longi"];
            NSLog(@"%@,%@",lati,longi);
            _locati.text=[NSString stringWithFormat:@"纬度%@，经度%@",lati,longi];
            [SVProgressHUD showSuccessWithStatus:@"获取位置成功"];
            
            
        });
               NSLog(@"你点击了确定");
        
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[textField convertRect:textField.bounds toView:window];
    float y1=rect.origin.y;
    
    if(y1>216)
    {
        self.tableView.frame=CGRectMake(0, -216, ScreenWidth, ScreenHeight);
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.tableView.frame=CGRectMake(0, 60, ScreenWidth, ScreenHeight-50);
}
-(void)Getlocation:(NSNotification *)aNoti
 {
    // 通知传值
    NSDictionary *location = [aNoti userInfo];
     lati=[location objectForKey:@"lati"];
     longi=[location objectForKey:@"longi"];
     NSLog(@"%@,%@",lati,longi);
     _locati.text=[NSString stringWithFormat:@"纬度%@，经度%@",lati,longi];
     [SVProgressHUD showSuccessWithStatus:@"获取位置成功"];
    
}
- (IBAction)Click_GetLocation:(id)sender {
    [alert  show];
   /* [[Z_NetRequestManager sharedInstance]getlongandlati];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        
        NSDictionary *location=[[Z_NetRequestManager sharedInstance] getlongla];
        lati=[location objectForKey:@"lati"];
        longi=[location objectForKey:@"longi"];
        NSLog(@"%@,%@",lati,longi);
        [SVProgressHUD showSuccessWithStatus:@"获取位置成功"];
        
        
    });//得到经纬度得时间会有延迟 详情见map方法
*/
   // [self performSegueWithIdentifier:@"getlocation" sender:self];
    
    //
}

- (IBAction)click_qiye:(id)sender {
    qiyeorperson=1;
    btnSelected.selected=NO;
    [btnSelected setImage:[UIImage imageNamed:@"个体户"] forState:UIControlStateNormal];
    _btn_qiye.selected=YES;
    btnSelected=_btn_qiye;
    
    [btnSelected setImage:[UIImage imageNamed:@"企业"] forState:UIControlStateSelected];
}

- (IBAction)click_finish:(id)sender {
    //这儿得改text有值
    NSLog(@"%lu",_TF_CusName.text.length);
    if (_TF_CusName.text.length!=0&&_TF_CusTtName.text.length!=0&&_TF_MobilePhone.text.length!=0&&lati&&longi&&_TF_website.text.length!=0&&_TF_CusCode.text.length!=0&&_TF_Phone.text.length!=0) {
        [addcusjson setObject:_TF_CusName.text forKey:@"cusName"];
        [addcusjson setObject:_TF_CusCode.text forKey:@"cusCode"];
        [addcusjson setObject:_TF_MobilePhone.text forKey:@"cusTtName"];
       [addcusjson setObject:_TF_MobilePhone.text forKey:@"mobilePhone"];
         [addcusjson setObject:_TF_Phone.text forKey:@"phone"];
        [addcusjson setObject:longi forKey:@"longitude"];//经度
        [addcusjson setObject:lati forKey:@"latitude"];//纬度
        [addcusjson setObject:[locationCodeDic objectForKey:@"provinceCode"] forKey:@"province"];
        //[locationCodeDic objectForKey:@"provinceCode"]
        [addcusjson setObject:[locationCodeDic objectForKey:@"cityCode"] forKey:@"city"];
        //[locationCodeDic objectForKey:@"cityCode"]
        [addcusjson setObject:[locationCodeDic objectForKey:@"regionCode"] forKey:@"district"];
        //[locationCodeDic objectForKey:@"regioncode"]
        [addcusjson setObject:_TF_website.text forKey:@"website"];
        if (qiyeorperson==1) {
            [addcusjson setObject:@"1" forKey:@"type"];
        }
        else
        {
             [addcusjson setObject:@"0" forKey:@"type"];
        }
        //[addcusjson setObject:@"0" forKey:@"remark"];
        //[addcusjson setObject:@"0" forKey:@"memcCode"];
    //[addcusjson setObject:@"0" forKey:@"address"];
    //[addcusjson setObject:@"0" forKey:@"bank"];
    //[addcusjson setObject:@"0" forKey:@"account"];
        //有数据时SET这个[[NSUserDefaults standardUserDefaults]objectForKey:@"username"]
    [addcusjson setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];
     
             NSData *data = [NSJSONSerialization dataWithJSONObject:addcusjson options:NSJSONWritingPrettyPrinted error:nil];
        NSString*  datastr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
           // dic=[[NSDictionary alloc]initWithObjectsAndKeys:datastr,@"paraMap", nil];
    NSMutableDictionary *pir=[[NSMutableDictionary alloc]init];
    [pir setObject:datastr forKey:@"paraMap"];
    
        [[QQRequestManager sharedRequestManager] POST:[SEVER_URL stringByAppendingString:@"yd/addCus.action"] parameters:pir showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",datastr);
            [self qq_performSVHUDBlock:^{
                [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
            }];
            if([responseObject objectForKey:@"status"])
            {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:NO];
                // 2秒后异步执行这里的代码...
                
            });
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            
            [self qq_performSVHUDBlock:^{
                [SVProgressHUD showErrorWithStatus:@"添加失败"];
            }];
        }];
       
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"请填写完信息再提交"];
    }
    
}
-(void)passLovation:(NSDictionary *)locationDic
{
    UILabel* lab=(UILabel*)[self.view viewWithTag:1234];
    lab.text=[[[locationDic objectForKey:@"provinceName"] stringByAppendingString:[locationDic objectForKey:@"cityName"]] stringByAppendingString:[locationDic objectForKey:@"regionName"]];
    locationCodeDic=locationDic;
     NSLog(@"%@",locationDic);
}
- (IBAction)click_person:(id)sender {
    qiyeorperson=0;
    btnSelected.selected=NO;
    [btnSelected setImage:[UIImage imageNamed:@"个体户"] forState:UIControlStateNormal];
    _btn_person.selected=YES;
    btnSelected=_btn_person;
    
    [btnSelected setImage:[UIImage imageNamed:@"企业"] forState:UIControlStateSelected];
}

@end
