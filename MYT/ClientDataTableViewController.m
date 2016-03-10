//
//  ClientDataTableViewController.m
//  MYT
//
//  Created by 熊凯 on 15/12/9.
//  Copyright © 2015年 YunRui. All rights reserved.
//
#import "CilentplaceViewController.h"
#import "ClientDataTableViewController.h"
#import "NetRequestManager.h"
#import "QQRequestManager.h"
#import "ContactsTableViewController.h"

@interface ClientDataTableViewController ()
{
    NSDictionary* dataDic;
    __block NSString * longi;
    __block NSString * lati;
   
}
@end

@implementation ClientDataTableViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                 
                                 initWithImage:[UIImage imageNamed:@"客户资料右上角"]
                                 style:UIBarButtonItemStyleDone
                                 
                                 target:self
                                 
                                 action:@selector(updateclick)];
    //barbtn.image=searchimage;
    //self.navigationItem.rightBarButtonItem=barbtn;
    self.tabBarController.navigationItem.rightBarButtonItem = rightBtn;
}
- (void)viewDidLoad {
    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                 
                                 initWithImage:[UIImage imageNamed:@"客户资料右上角"]
                                 style:UIBarButtonItemStyleDone
                                 
                                 target:self
                                 
                                 action:@selector(updateclick)];
    //barbtn.image=searchimage;
    //self.navigationItem.rightBarButtonItem=barbtn;
    self.tabBarController.navigationItem.rightBarButtonItem = rightBtn;
   _clientId= [NetRequestManager sharedInstance].clientId;
 if(currentVersion>=7)
 {
    self.edgesForExtendedLayout = UIRectEdgeNone;
 }
    
    //设置背景颜色
    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [super viewDidLoad];
    
    [self loadData:_clientId];
}


-(void)loadData:(NSString*)clientId
{
    NSString* cusid=clientId;
    NSMutableDictionary* pardic=[[NSMutableDictionary alloc]initWithCapacity:10];
    [pardic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];
    [pardic setObject:cusid forKey:@"cusid"];
    [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingString:@"yd/getCusInfo.action"] parameters:pardic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSLog(@"%@",responseObject);
        
        dataDic=(NSDictionary*)responseObject ;
        lati=[dataDic objectForKey:@"latitude"];
        longi=[dataDic objectForKey:@"longitude"];
        _lab_custtname.text=[dataDic objectForKey:@"custtname"];
        _lab_cusname.text=[dataDic objectForKey:@"cusname"];
        _lab_telephone.text=[dataDic objectForKey:@"phone"];
        //_lab_creatTime.text=[dataDic objectForKey:@""];//创建时间后台没有返回
        
        //交易记录
        _lab_dlvdate.text=[[dataDic objectForKey:@"trading_record"] objectForKey:@"trading_dlvdate"];
        _lab_code.text=[[dataDic objectForKey:@"trading_record"] objectForKey:@"trading_obdcode"];
        _lab_money.text=[[[dataDic objectForKey:@"trading_record"] objectForKey:@"trading_money"] stringByAppendingString:@"元"];
        
        //业务日志
        _lab_visite_time.text=[[dataDic objectForKey:@"businessLog"] objectForKey:@"visite_time"];
         _lab_receiver.text=[[dataDic objectForKey:@"businessLog"] objectForKey:@"receiver"];
        
        //通话记录
        _lab_contactsname.text=[[dataDic objectForKey:@"call_log"] objectForKey:@"contactsname"];
         _lab_call_phone.text=[[dataDic objectForKey:@"call_log"] objectForKey:@"call_phone"];
        _lab_call_time.text=[[dataDic objectForKey:@"call_log"] objectForKey:@"call_time"];
        _lab_talk_time.text=[[[dataDic objectForKey:@"call_log"] objectForKey:@"talk_time"] stringByAppendingString:@"分钟"];
        
        //备注说明
        _lab_remark.text=[[dataDic objectForKey:@"cus_remark"] objectForKey:@"remark"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self qq_performSVHUDBlock:^{
            [SVProgressHUD showErrorWithStatus:@"网络请求错误！"];
        }];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateclick
{
     [self performSegueWithIdentifier:@"contacts" sender:self];
}
- (IBAction)clickLocation:(id)sender {
     [self performSegueWithIdentifier:@"cplace" sender:self];
    //这里直接跳转到地图的页面上面去
//    //获取经度
//    float latitude=((NSNumber*)[dataDic objectForKey:@"latitude"]).floatValue;
//    //获取纬度
//     float longitude=((NSNumber*)[dataDic objectForKey:@"longitude"]).floatValue;
//    [self performSegueWithIdentifier:@"tomap" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"contacts"]) {
        ContactsTableViewController* destination=[segue destinationViewController];
        destination.cusid=[NSString stringWithFormat:@"%@",_clientId];
    }
    else if ([segue.identifier isEqualToString:@"cplace"])
    {
        CilentplaceViewController *des=segue.destinationViewController;
        des.lati=lati;
        des.longi=longi;
    }
}
- (IBAction)contactClick:(id)sender {
    
   
}
@end
