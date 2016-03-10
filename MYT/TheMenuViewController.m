//
//  TheMenuViewController.m
//  MYT
//
//  Created by 熊凯 on 16/1/18.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import "TheMenuViewController.h"
#import "Utility.h"
#import "IIViewDeckController.h"
#import "ProvinceTableViewController.h"
#import "NetRequestManager.h"

@interface TheMenuViewController ()
{
    NSDictionary* locationCodeDic;
}

@end

@implementation TheMenuViewController

- (void)viewDidLoad {
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

- (IBAction)clickLocation:(id)sender {
        [self.viewDeckController closeRightViewBouncing:^(IIViewDeckController *controller) {
            [NetRequestManager sharedInstance].FROMDECK=1;
            UINavigationController * navVC = (UINavigationController *) self.viewDeckController.centerController;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITableViewController *ProvinceContro= (UITableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Province"];
            [navVC pushViewController:ProvinceContro animated:YES];
    
        }];

}
@end
