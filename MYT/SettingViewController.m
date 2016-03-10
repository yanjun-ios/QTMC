//
//  SettingViewController.m
//  MYT
//
//  Created by 熊凯 on 15/12/11.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import "SettingViewController.h"
#import "ButtomView.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //消除多余空白行
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView  setTableFooterView:view];
    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* identif=@"cell";
    
    UITableViewCell* cell=[self.tableView dequeueReusableCellWithIdentifier:identif];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
    }
    UISwitch* swich;
    if(swich==nil)
    {
        swich=[[UISwitch alloc]initWithFrame:CGRectMake(cell.frame.size.width, 0, 50, 25)];
        swich.center=CGPointMake(swich.center.x, cell.center.y);
        [swich setOn:YES];
    }
    swich.tag=indexPath.row;
    [cell.contentView addSubview:swich];
    
    [swich addTarget:self action:@selector(clickSwich:) forControlEvents:UIControlEventTouchUpInside];
    if(indexPath.row==0)
    {
        cell.textLabel.text=@"系统通知";
    }else if (indexPath.row==1)
    {
        cell.textLabel.text=@"入库提醒";
    }else if(indexPath.row==2)
    {
        cell.textLabel.text=@"通知公告";
    }
    else if(indexPath.row==3)
    {
        cell.textLabel.text=@"清空缓存";
        [swich removeFromSuperview];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.textColor=[UIColor darkGrayColor];
    cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor=[UIColor clearColor];
    return cell;
    
}

-(void)clickSwich:(UISwitch*)swich
{
    
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
