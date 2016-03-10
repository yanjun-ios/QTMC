//
//  AddRemarksViewController.m
//  MYT
//
//  Created by 熊凯 on 15/12/9.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import "AddRemarksViewController.h"
#import "NetRequestManager.h"
#import "QQRequestManager.h"
@interface AddRemarksViewController ()

@end

@implementation AddRemarksViewController

-(void)viewWillAppear:(BOOL)animated
{
    _textView.delegate=self;

    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                 
                                 initWithTitle:@"完成"
                                 
                                 style:UIBarButtonItemStyleDone
                                 
                                 target:self
                                 
                                 action:@selector(finishclick)];
    self.tabBarController.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)viewDidLoad {
  
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)finishclick
{

   NSString*  Userid= [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    NSString* Clientid=[NetRequestManager sharedInstance].clientId;
    NSString* Content=_textView.text;
    if (Content.length==0) {
        [self qq_performSVHUDBlock:^{
            [SVProgressHUD showErrorWithStatus:@"请输入备注内容！"];
        }];
    }
    else
    {
        NSMutableDictionary* pardic=[[NSMutableDictionary alloc]init];
        [pardic setValue:Userid forKey:@"userid"];
        [pardic setValue:Clientid forKey:@"cusid"];
        [pardic setValue:Content forKey:@"cont"];
       //NSString* parStr=[[NetRequestManager sharedInstance] DataToJsonString:pardic];
        NSMutableDictionary* paramapDic=[[NSMutableDictionary alloc]init];
        NSData *data = [NSJSONSerialization dataWithJSONObject:pardic options:NSJSONWritingPrettyPrinted error:nil];
        NSString*  datastr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [paramapDic setObject:datastr forKey:@"paraMap"];
        [[QQRequestManager sharedRequestManager] POST:[SEVER_URL stringByAppendingString:@"yd/addCusRemark.action"] parameters:paramapDic success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary* dic=responseObject;
            int status=((NSNumber*)[dic objectForKey:@"status"]).intValue;
            if (status==1) {
                [self qq_performSVHUDBlock:^{
                    [SVProgressHUD showSuccessWithStatus:[dic objectForKey:@"message"]];
                }];
            }else
            {
                [self qq_performSVHUDBlock:^{
                    [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"message"]];
                }];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self qq_performSVHUDBlock:^{
                [SVProgressHUD showErrorWithStatus:@"网络请求错误，请检查网络!"];
            }];

        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger bytes= [textView.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if (bytes>=150) {
        [self qq_performSVHUDBlock:^{
            [SVProgressHUD showInfoWithStatus:@"文字输入太长，无法提交！"];
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
