//
//  ViewController.m
//  MYT
//
//  Created by Qingqing on 15/12/7.
//  Copyright (c) 2015年 YunRui. All rights reserved.
//

#import "ViewController.h"
#import"QQRequestManager.h"
#import "UIViewController+Helper.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
//    NSDictionary* paradic=@{@"username":@"yanjun",@"password":@"123456"};
//    QQRequestManager* request =  [QQRequestManager sharedRequestManager];
//    [request GET:@"http://115.28.189.220/iclass/login" parameters:paradic showHUD:YES
//    success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"task:%@ responseObject:%@",task,responseObject);
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
    [self qq_performSVHUDBlock:^{
        //[SVProgressHUD show];
        //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
         //[SVProgressHUD showInfoWithStatus:@"你好！"];
         //[SVProgressHUD showWithStatus:@"加载中。。。"];
        //[SVProgressHUD showErrorWithStatus:@"登陆错误登陆错误登陆错误登陆错误登陆错误登陆错误登陆错误登陆错误！"];
        [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
    }];
   
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
