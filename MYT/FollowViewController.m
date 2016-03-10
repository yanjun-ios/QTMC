//
//  FollowViewController.m
//  MYT
//
//  Created by 熊凯 on 16/1/14.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import "FollowViewController.h"
#import "QQRequestManager.h"
#import "MJRefresh.h"
@interface FollowViewController ()
{
    UIButton* btnSelected;
    int pageNum;
    int btnHasSelectd;
    NSMutableArray* calledList;
    NSMutableArray* notCalledList;
    NSMutableArray* abandonList;
    
    NSArray* tableArry;
}
@end

@implementation FollowViewController

-(void)viewWillAppear:(BOOL)animated
{
     calledList=[[NSMutableArray alloc]init];
    notCalledList=[[NSMutableArray alloc]init];
     abandonList=[[NSMutableArray alloc]init];

    
    self.navigationController.navigationBarHidden=NO;
    [btnSelected setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnSelected setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//    UIView* line=[[UIView alloc]initWithFrame:CGRectMake(20, 38, 60, 2)];
//    line.backgroundColor=[UIColor redColor];
//    [_topView addSubview:line];
}

- (void)viewDidLoad {
    pageNum=1;
    btnHasSelectd=100;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    /*if(currentVersion>=7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }*/
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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifi=@"cell";
    UITableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:identifi];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
        //姓名
        UILabel* name=[[UILabel alloc]init];
        name.frame=CGRectMake(15, 12, ScreenWidth-120, 20);
        name.font=[UIFont systemFontOfSize:16];
        name.textColor=[UIColor darkGrayColor];
        name.tag=1000;
        [cell.contentView addSubview:name];

        //电话
        UILabel* phoneNum=[[UILabel alloc]init];
        phoneNum.frame=CGRectMake(ScreenWidth-110, 12, 110, 20);
        phoneNum.font=[UIFont systemFontOfSize:16];
        phoneNum.textColor=[UIColor darkGrayColor];
        phoneNum.tag=1001;
        [cell.contentView addSubview:phoneNum];
        //时间
        UILabel* time=[[UILabel alloc]init];
        time.frame=CGRectMake(15, 42, 200, 40);
        time.font=[UIFont systemFontOfSize:14];
        time.textColor=[UIColor darkGrayColor];
        time.lineBreakMode=NSLineBreakByWordWrapping;
        time.numberOfLines=0;
        time.tag=1002;
        [cell.contentView addSubview:time];
    }
    
    UILabel* lab=(UILabel*)[cell.contentView viewWithTag:1002];
    switch (btnHasSelectd) {
        case 100:
            ((UILabel*)[cell.contentView viewWithTag:1000]).font=[UIFont systemFontOfSize:16];
            ((UILabel*)[cell.contentView viewWithTag:1000]).text=[[tableArry objectAtIndex:indexPath.row] objectForKey:@"contactsname"];
            ((UILabel*)[cell.contentView viewWithTag:1001]).text=[[tableArry objectAtIndex:indexPath.row] objectForKey:@"mobilephone"];
            lab.textColor=[UIColor greenColor];
            lab.text=[[tableArry objectAtIndex:indexPath.row] objectForKey:@"time"];
            break;
        case 101:
            ((UILabel*)[cell.contentView viewWithTag:1000]).text=[[tableArry objectAtIndex:indexPath.row] objectForKey:@"custtname"];
            ((UILabel*)[cell.contentView viewWithTag:1000]).font=[UIFont systemFontOfSize:14];
            //((UILabel*)[cell.contentView viewWithTag:1001]).text=[[tableArry objectAtIndex:indexPath.row] objectForKey:@"mobilephone"];
            lab.textColor=[UIColor redColor];
            lab.text=@"未拨打";
            break;
        case 102:
            ((UILabel*)[cell.contentView viewWithTag:1000]).font=[UIFont systemFontOfSize:14];
            ((UILabel*)[cell.contentView viewWithTag:1000]).text=[[tableArry objectAtIndex:indexPath.row] objectForKey:@"custtname"];
           // ((UILabel*)[cell.contentView viewWithTag:1001]).text=[[tableArry objectAtIndex:indexPath.row] objectForKey:@"mobilephone"];
            lab.textColor=[UIColor orangeColor];
            lab.text=[[tableArry objectAtIndex:indexPath.row] objectForKey:@"gpreason"];
            break;
        default:
            break;
    }
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableArry count];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)loaData
{
    [_parDic setValue:@"10" forKey:@"pageSize"];
    [_parDic setValue:[NSString stringWithFormat:@"%d",pageNum] forKey:@"pageNum"];
    [[QQRequestManager sharedRequestManager]GET:[SEVER_URL stringByAppendingString:@"yd/getFollowInfo.action"] parameters:_parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        pageNum++;
      NSDictionary* jsonDic=(NSDictionary*)responseObject;
        [calledList addObjectsFromArray:[[jsonDic objectForKey:@"hasCalled"] objectForKey:@"list"]];
        [notCalledList addObjectsFromArray:[[jsonDic objectForKey:@"notCalled"] objectForKey:@"list"]];
        [abandonList addObjectsFromArray:[[jsonDic objectForKey:@"abandon"] objectForKey:@"list"]];
        
        switch (btnHasSelectd) {
            case 100:
                [self btnChooseClick:_btn_hasCalled];
                break;
            case 101:
                [self btnChooseClick:_btn_notCalled];
                break;
            case 102:
                [self btnChooseClick:_btn_abandon];
                break;

            default:
                break;
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


- (IBAction)btnChooseClick:(id)sender {
    btnSelected.selected=NO;
    btnSelected=(UIButton*)sender;
    btnSelected.selected=YES;
    int btntag=((UIButton*)sender).tag;
    btnHasSelectd=btntag;
    switch (btntag) {
        case 100:
            tableArry=calledList;
            [_tableview reloadData];
            break;
        case 101:
            tableArry=notCalledList;
            [_tableview reloadData];
            break;
        case 102:
            tableArry=abandonList;
            [_tableview reloadData];
            break;
            
        default:
            break;
    }

    [_tableview.mj_footer endRefreshing];
}
@end
