//
//  MainViewController.m
//  MYT
//
//  Created by 熊凯 on 15/12/10.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import "MainViewController.h"
#import "ButtomView.h"
#import "RemindViewController.h"
#import "CilentViewController.h"
#import "TreeViewController.h"
#import "Node.h"
@interface MainViewController ()
{
    NSArray *init;
    NSMutableArray *nodear;
    __block  NSMutableArray  *typear;//存类型为T的物料类别
    __block  NSMutableArray  *wular;//存类型为W的物料类别
    int totlepage;
}

@end

@implementation MainViewController


-(void)viewWillAppear:(BOOL)animated
{
    [self getstock];
    self.navigationController.navigationBarHidden=NO;
}



- (void)viewDidLoad {
    
    nodear=[[NSMutableArray alloc]init];
    typear=[[NSMutableArray alloc]init];
    wular=[[NSMutableArray alloc]init];

    [self.navigationItem setHidesBackButton:YES];
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
    //添加底部菜单栏
    ButtomView* BtmV=[[ButtomView alloc]initWithFrame:CGRectMake(0, ScreenHeight-50, ScreenWidth, 50)];
    [self.view addSubview:BtmV];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)click_put:(id)sender {
    [self performSegueWithIdentifier:@"cilentmanage" sender:self];
}
-(void)getstock
{
    
    [nodear removeAllObjects];
    [typear removeAllObjects];
    [wular removeAllObjects];
    NSLog(@"%@",nodear);
    NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
    [parDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]);
    [parDic setValue:@"null" forKey:@"parentid"];
    [parDic setValue:@"1" forKey:@"pageNum"];
    [parDic setValue:@"5" forKey:@"pageSize"];//先请求1页中5个
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   
        dispatch_sync(concurrentQueue, ^{
            [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingString:@"yd/getMatTree.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                
                totlepage=((NSNumber*)[responseObject objectForKey:@"totlePage"]).intValue;
                [nodear removeAllObjects];
                init=[responseObject objectForKey:@"list"];
                for (NSDictionary *dic in init) {
                    if ([[dic objectForKey:@"tw"] isEqualToString:@"T"]) {
                        [typear addObject:dic];
                    }
                    else
                    {
                        [wular addObject:dic];
                    }
                }
                for (int i=0; i<typear.count; i++) {
                    NSDictionary * typeinfo=[typear objectAtIndex:i];
                    NSString* nodeid=[typeinfo objectForKey:@"typeid"];
                    int counts=((NSNumber*)[typeinfo objectForKey:@"counts"]).intValue;
                    int matecounts=((NSNumber*)[typeinfo objectForKey:@"matecounts"]).intValue;
                    Node * node=[[Node alloc]initWithParentId:@"-1" nodeId:nodeid name:[typeinfo objectForKey:@"typename"] depth:0 expand:YES child:YES matid:@"-1" counts:counts matecounts:matecounts];
                    [nodear addObject:node];
                }
                for (int i=0; i<wular.count; i++) {
                    NSDictionary * wulinfo=[wular objectAtIndex:i];
                    NSString* nodeid=[wulinfo objectForKey:@"matid"];
                    int counts=((NSNumber*)[wulinfo objectForKey:@"counts"]).intValue;
                    int matecounts=((NSNumber*)[wulinfo objectForKey:@"matecounts"]).intValue;
                    Node * node=[[Node alloc]initWithParentId:@"-1" nodeId:nodeid name:[wulinfo objectForKey:@"mattername"] depth:0 expand:YES child:NO matid:nodeid counts:counts matecounts:matecounts];
                    [nodear addObject:node];
                    
                }
                NSLog(@"%@",nodear);
               
                                //将请求到的第一层数据分类
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                
                [self qq_performSVHUDBlock:^{
                    [SVProgressHUD showErrorWithStatus:@"请求数据失败"];
                }];
            }];
           
            /*download the image here*/
            
        });
    
}
- (IBAction)click_tocompany:(id)sender {
            //请求完第一层数据进入
    
           if (nodear.count) {
                 [self performSegueWithIdentifier:@"company" sender:self];
            }
            else
                [SVProgressHUD showErrorWithStatus:@"请求数据失败"];
            /*show the image to the user here on the main queue*/
    

  
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"company"]) {
      TreeViewController * stock=segue.destinationViewController;
     stock.nodearr=nodear;
     stock.totlePage=totlepage;
    }
    /*else if ([segue.identifier isEqual:@"cilentmanage"]) {
        CilentViewController * stock=segue.destinationViewController;
        stock.nodearr=nodear;
    }*/

}
@end
