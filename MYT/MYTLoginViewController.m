//
//  MYTLoginViewController.m
//  MYT
//
//  Created by 熊凯 on 15/12/7.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import "MYTLoginViewController.h"
#import "Utility.h"
#import "QQRequestManager.h"
#import "UIViewController+Helper.h"
#import "IIViewDeckController.h"
#import <SVProgressHUD.h>
#import "MoreViewController.h"
#import "BaseDB.h"
#import "NetRequestManager.h"
@interface MYTLoginViewController ()
{
    NSString *name;
    NSString *profess;
}

@end

@implementation MYTLoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    _layCon.constant=160;
    _btnLogin.alpha=0.0f;
    _ViewForm.alpha=0.0f;
    [UIView animateWithDuration:2.0f animations:^{
        _layCon.constant=40;
        _btnLogin.alpha=1.0f;
        _ViewForm.alpha=1.0f;
    }];
    NSLog(@"path1:%@", NSHomeDirectory());
    
}

- (void)viewDidLoad {
    //取消侧拉
    [self.viewDeckController setPanningMode:IIViewDeckNoPanning];
    
    [[Utility sharedInstance] setLayerView:_ViewForm borderW:1 borderColor:[UIColor lightGrayColor] radius:3];
    _TF_UserName.delegate=self;
    _TF_Password.delegate=self;
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"username"])
    {
        _TF_UserName.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
        _TF_Password.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_TF_UserName resignFirstResponder];
    [_TF_Password resignFirstResponder];
    return YES;
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

- (IBAction)loginInto:(id)sender {
   
    [_TF_UserName resignFirstResponder];
    [_TF_Password resignFirstResponder];
    NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
    [parDic setValue:_TF_UserName.text forKey:@"usercode"];
    [parDic setValue:_TF_Password.text forKey:@"password"];
    [[NSUserDefaults standardUserDefaults ]setObject:_TF_UserName.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults ]setObject:_TF_Password.text forKey:@"password"];
    [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingString:@"yd/appLogin.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
       
        NSLog(@"%@",responseObject);
        NSNumber* status=[responseObject objectForKey:@"status"];
        int statusint = [status intValue];
        if (statusint==1) {
            NSDictionary *user=[responseObject objectForKey:@"user"];
            NSString *user_id=[user objectForKey:@"user_id"];
            //保存用户id 部门id 职位级别
             [[NSUserDefaults standardUserDefaults ]setObject:user_id  forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults ]setObject:[user objectForKey:@"dep_id"]  forKey:@"dep_id"];
            [[NSUserDefaults standardUserDefaults ]setObject:[user objectForKey:@"profess_state"]  forKey:@"profess_state"];
             NSString *dep_id=[user objectForKey:@"dep_id"];
             NSString *user_name=[user objectForKey:@"user_name"];
            name=user_name;
            NSString *gender=[user objectForKey:@"gender"];
             NSString *professional=[user objectForKey:@"professional"];
            profess=professional;
            NSString *profess_state=[user objectForKey:@"profess_state"];
            NSString *fileName=[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.sqlite",_TF_UserName.text];//数据库名字
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:fileName]) {
                BaseDB *db=[[BaseDB alloc] init];
                //创建表
                NSString *dbCreate=[NSString stringWithFormat:@"create table %@( user_id text primary key,dep_id test,user_name test,gender test,professional test,profess_state test)",_TF_UserName.text];//表名字及字段
                NSString *dbName=[NSString stringWithFormat:@"%@.sqlite",_TF_UserName.text];//文件名字为
                [db createTable:dbCreate dataBaseName:dbName];
                //此处还应添信息
                NSString *insertTable=[NSString stringWithFormat:@"insert into %@(user_id,dep_id,user_name,gender,professional,profess_state) values (?,?,?,?,?,?)",_TF_UserName.text];
                NSArray  *insertParmas=@[user_id,dep_id,user_name,gender,professional,profess_state];
                 [db execSql:insertTable parmas:insertParmas dataBaseName:dbName];
            }

            [self performSegueWithIdentifier:@"mainPage" sender:self];
            [[NetRequestManager sharedInstance] getArelist];
        }
        else if(statusint==0)
        {
            [self qq_performSVHUDBlock:^{
                [SVProgressHUD showErrorWithStatus:@"账号不存在"];
            }];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        [self qq_performSVHUDBlock:^{
            [SVProgressHUD showErrorWithStatus:@"账号或密码错误"];
        }];
    }];
}
@end
