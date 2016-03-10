//
//  RegionsTableViewController.m
//  MYT
//
//  Created by 熊凯 on 16/1/17.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import "RegionsTableViewController.h"
#import "NetRequestManager.h"
#import "addTableViewController.h"
#import "CilentViewController.h"
@interface RegionsTableViewController ()
{
    NSMutableDictionary* locationSelected;
    NSArray* arelist;
}
@end

@implementation RegionsTableViewController

- (void)viewDidLoad {
    locationSelected=[[NSMutableDictionary alloc]init];
    arelist=[[[NetRequestManager sharedInstance] AREALIST] objectForKey:@"china"];
    //保存区域
    [locationSelected setValue:@"" forKey:@"regionName"];
    [locationSelected setValue:@"" forKey:@"regionCode"];
    if ([_regionsList count]==0) {
        [self initAlertView:@""];
    }
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)initAlertView:(NSString*)region
{
    NSString* sheng= [[arelist objectAtIndex:_provinceIndex] objectForKey:@"provinceName"];
    NSString* shi= [[[[arelist objectAtIndex:_provinceIndex] objectForKey:@"citys"] objectAtIndex:_citysIndex] objectForKey:@"cityName"] ;
    NSString* str=[[sheng stringByAppendingString:shi] stringByAppendingString:region];
    
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"您选择了:%@",str] delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"确认", nil];
    [alert show];
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
    return [_regionsList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    
    // Configure the cell...
    cell.textLabel.text=[[_regionsList objectAtIndex:indexPath.row] objectForKey:@"regionName"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //保存区域
    [locationSelected setValue:[[_regionsList objectAtIndex:indexPath.row] objectForKey:@"regionName"] forKey:@"regionName"];
    [locationSelected setValue:[[_regionsList objectAtIndex:indexPath.row] objectForKey:@"regionCode"] forKey:@"regionCode"];
    [self initAlertView:[[_regionsList objectAtIndex:indexPath.row] objectForKey:@"regionName"]];
    
    //[self.navigationController popToViewController:[[self.navigationController.viewControllers objectAtIndex:3] ani];
   
}

-(void)mixData
{
    //保存省
    [locationSelected setValue:[[arelist objectAtIndex:_provinceIndex] objectForKey:@"provinceName"] forKey:@"provinceName"];
    [locationSelected setValue:[[arelist objectAtIndex:_provinceIndex] objectForKey:@"provinceCode"] forKey:@"provinceCode"];
    
    //保存市
    [locationSelected setValue:[[[[arelist objectAtIndex:_provinceIndex] objectForKey:@"citys"] objectAtIndex:_citysIndex] objectForKey:@"cityName"] forKey:@"cityName"];
    [locationSelected setValue:[[[[arelist objectAtIndex:_provinceIndex] objectForKey:@"citys"] objectAtIndex:_citysIndex] objectForKey:@"cityCode"] forKey:@"cityCode"];
    if ([NetRequestManager sharedInstance].FROMDECK==1) {
        CilentViewController* contro=[self.navigationController.viewControllers objectAtIndex:2];
        self.LocationDelegate=contro;
        [self.LocationDelegate passLovation:locationSelected];
        [self.navigationController popToViewController:contro animated:YES];
        [NetRequestManager sharedInstance].FROMDECK=0;
    }else
    {
        addTableViewController* contro=[self.navigationController.viewControllers objectAtIndex:3];
        self.LocationDelegate=contro;
        [self.LocationDelegate passLovation:locationSelected];
        [self.navigationController popToViewController:contro animated:YES];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0)
{
    if(buttonIndex==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self mixData];
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
