//
//  StockViewController.m
//  MYT
//
//  Created by YUNRUIMAC on 15/12/13.
//  Copyright © 2015年 YunRui. All rights reserved.
//

/*#import "StockViewController.h"
#import "ButtomView.h"
#import "Node.h"
#import "TreeTableView.h"
#import "ProductdetalViewController.h"
#import "QQRequestManager.h"
#import "TreeTableView.h"
@interface StockViewController ()<TreeTableCellDelegate>
{
    NSString *parent;
    NSString *pparent;
    NSString *child;
    NSArray  *data1;
    NSArray *init;
    NSMutableArray *nodear;//要显示的所有node数据
    BOOL click;//判断是否点开
  __block  NSMutableArray  *typearr;//存类型为T的物料类别
  __block  NSMutableArray  *wularr;//存类型为W的物料类别
    TreeTableView *tableview ;
}
@end

@implementation StockViewController
-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad {
    
    click=YES;
    nodear=[[NSMutableArray alloc] init];
    typearr=[[NSMutableArray alloc]init];
    wularr=[[NSMutableArray alloc]init];
    nodear=[[NSMutableArray alloc]init];
    for(int i=0;i<_nodearr.count;i++)
    {
        NSMutableArray *nodea=[[NSMutableArray alloc]init];//创建每行
        [nodea addObject:[_nodearr objectAtIndex:i]];//将第一层的node分别加入不同的可变数组
        
        [nodear addObject:nodea];
    }
    NSLog(@"%@",_nodearr);
    NSLog(@"%@",nodear);

    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initData];
        // 2秒后异步执行这里的代码...
        
   // });
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    view.backgroundColor=[UIColor lightGrayColor];
    UILabel *nameofpro=[[UILabel alloc]initWithFrame:CGRectMake(14, 0, ScreenWidth/3, 30)];
    nameofpro.text=@"产品名称";
    nameofpro.font=[UIFont fontWithName:@"ArialMT" size:14];
    [view addSubview:nameofpro];
    
    UILabel *count=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/3, 30)];
    count.text=@"产品名称";
    count.font=[UIFont fontWithName:@"ArialMT" size:14];
    count.center=view.center;
    count.textAlignment=NSTextAlignmentCenter;
    [view addSubview:count];
    
    UIButton *mate=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-80, 0, 80, 30)];
    [mate setTitle:@"匹配客户" forState:UIControlStateNormal];
    mate.titleLabel.font=[UIFont fontWithName:@"ArialMT" size:14];
    mate.titleLabel.textAlignment=NSTextAlignmentCenter;
    [mate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mate addTarget:self action:@selector(Actiondo:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:mate];
    
    [self.view addSubview:view];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.leftItemsSupplementBackButton=NO;
    ButtomView* BtmV=[[ButtomView alloc]initWithFrame:CGRectMake(0, ScreenHeight-114, ScreenWidth, 50)];
    [self.view addSubview:BtmV];
     [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)Actiondo:(id)sender
{
    [self performSegueWithIdentifier:@"need" sender:self];
}
-(void)initData{
   
   // NSLog(@"%lu",(unsigned long)nodearr.count);
    
    //第一层的数据
    
    //----------------------------------中国的省地市关系图3,2,1--------------------------------------------
  /*  Node *country1 = [[Node alloc] initWithParentId:-1 nodeId:0 name:@"中国" depth:0 expand:YES child:YES];
    Node *province1 = [[Node alloc] initWithParentId:0 nodeId:1 name:@"江苏" depth:1 expand:NO child:YES];
    Node *city1 = [[Node alloc] initWithParentId:1 nodeId:2 name:@"南通" depth:2 expand:NO child:NO];
    //Node *subCity1 = [[Node alloc] initWithParentId:2 nodeId:100 name:@"通州" depth:3 expand:NO];
    //Node *subCity2 = [[Node alloc] initWithParentId:2 nodeId:101 name:@"如东" depth:3 expand:NO];
    Node *city2 = [[Node alloc] initWithParentId:1 nodeId:3 name:@"南京" depth:2 expand:NO child:NO];
    Node *city3 = [[Node alloc] initWithParentId:1 nodeId:4 name:@"苏州" depth:2 expand:NO child:NO];
    Node *province2 = [[Node alloc] initWithParentId:0 nodeId:5 name:@"广东" depth:1 expand:NO child:YES];
    Node *city4 = [[Node alloc] initWithParentId:5 nodeId:6 name:@"深圳" depth:2 expand:NO child:NO];
    Node *city5 = [[Node alloc] initWithParentId:5 nodeId:7 name:@"广州" depth:2 expand:NO child:NO];
    Node *province3 = [[Node alloc] initWithParentId:0 nodeId:8 name:@"浙江" depth:1 expand:NO child:YES];
    Node *city6 = [[Node alloc] initWithParentId:8 nodeId:9 name:@"杭州" depth:2 expand:NO child:NO];
    //----------------------------------美国的省地市关系图0,1,2--------------------------------------------
    Node *country2 = [[Node alloc] initWithParentId:-1 nodeId:10 name:@"美国" depth:0 expand:YES child:YES];
    Node *province4 = [[Node alloc] initWithParentId:10 nodeId:11 name:@"纽约州" depth:1 expand:NO child:YES];
    Node *province5 = [[Node alloc] initWithParentId:10 nodeId:12 name:@"德州" depth:1 expand:NO child:YES];
    Node *city7 = [[Node alloc] initWithParentId:12 nodeId:13 name:@"休斯顿" depth:2 expand:NO child:NO];
    Node *province6 = [[Node alloc] initWithParentId:10 nodeId:14 name:@"加州" depth:1 expand:NO child:YES];
    Node *city8 = [[Node alloc] initWithParentId:14 nodeId:15 name:@"洛杉矶" depth:2 expand:NO child:NO];
    Node *city9 = [[Node alloc] initWithParentId:14 nodeId:16 name:@"旧金山" depth:2 expand:NO child:NO];
    
    //----------------------------------日本的省地市关系图0,1,2--------------------------------------------
    Node *country3 = [[Node alloc] initWithParentId:-1 nodeId:17 name:@"日本" depth:0 expand:YES child:YES];
    Node *province7 = [[Node alloc] initWithParentId:17 nodeId:18 name:@"东京" depth:1 expand:NO  child:NO];
    Node *province8 = [[Node alloc] initWithParentId:17 nodeId:19 name:@"东京1" depth:1 expand:NO child:NO];
    Node *province9 = [[Node alloc] initWithParentId:17 nodeId:20 name:@"东京2" depth:1 expand:NO child:NO];
    
    //后面数字可采用Node的写法 也可采用dictionary写 可能有点问题，到时再看
    //NSArray *data = [NSArray arrayWithObjects:country1,country2,country3, nil];
    
    //NSArray *data = [NSArray arrayWithObjects:country1,province1,province2,province3,country2,province4,province5,province6,country3, nil];
    
    NSArray *data = [NSArray arrayWithObjects:country1,province1,city1,city2,city3,province2,city4,city5,province3,city6,country2,province4,province5,city7,province6,city8,city9,country3,province7,province8,province9, nil];
    data1=[NSArray arrayWithArray:data];*/
    /*NSArray *data=_nodearr;
    NSLog(@"%@",data);
    tableview = [[TreeTableView alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.view.frame), self.view.frame.size.height-133) withData:data];
    tableview.treeTableCellDelegate = self;
    [self.view addSubview:tableview];
}
//初始化Node
#pragma mark - TreeTableCellDelegate
-(void)cellClick:(Node *)node{
    
    click=!click;
    NSLog(@"%hdd",click);
    NSLog(@"%@",node.name);
    NSLog(@"%d",node.nodeId);
    if(node.depth==0)
    {
        NSMutableArray * arr=[[NSMutableArray alloc]init];
       __block int j;
        for (int i=0;i<_nodearr.count;i++) {
            if (((Node*)[_nodearr objectAtIndex:i]).nodeId==node.nodeId) {
                arr=(NSMutableArray*)[nodear objectAtIndex:i];
                j=i;
            }
        }
        
            NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
            [parDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]);
            NSString *nodeid=[NSString stringWithFormat:@"%d",node.nodeId];
            [parDic setValue:nodeid forKey:@"parentid"];
            [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingString:@"yd/getMatTree.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"%@",responseObject);
                init=[responseObject objectForKey:@"list"];
                for (NSDictionary *dic in init) {
                    if ([[dic objectForKey:@"tw"] isEqualToString:@"T"]) {
                        [typearr addObject:dic];
                    }
                    else
                    {
                        [wularr addObject:dic];
                    }
                }
                for (int i=0; i<typearr.count; i++) {
                    NSDictionary * typeinfo=[typearr objectAtIndex:i];
                    int nodeid=((NSNumber*)[typeinfo objectForKey:@"typeid"]).intValue;
                    Node * node1=[[Node alloc]initWithParentId:node.nodeId nodeId:nodeid name:[typeinfo objectForKey:@"typename"] depth:1 expand:YES child:YES matid:@"-1" counts:0 matecounts:0];
                    if (!click) {
                        NSLog(@"%@",[nodear objectAtIndex:j]);
                        [(NSMutableArray*)[nodear objectAtIndex:j] addObject:node1];//增加
                        
                    }
                    else
                    {
                        for (int i=0; i<((NSMutableArray*)[nodear objectAtIndex:j]).count; i++) {
                            Node * nod=[(NSMutableArray*)[nodear objectAtIndex:j] objectAtIndex:i];
                            if (nod.nodeId==nodeid) {
                                [(NSMutableArray*)[nodear objectAtIndex:j] removeObject:nod];//移除
                            }
                        }
                        
                        
                    }
                    
                }
               
                NSLog(@"%@",nodear);
                for (int i=0; i<wularr.count; i++) {
                    NSDictionary * wulinfo=[wularr objectAtIndex:i];
                    int nodeid=((NSNumber*)[wulinfo objectForKey:@"matid"]).intValue;
                    Node * node1=[[Node alloc]initWithParentId:node.nodeId nodeId:nodeid name:[wulinfo objectForKey:@"mattername"] depth:1 expand:NO child:NO matid:@"-1" counts:0 matecounts:0];
                    [nodear addObject:node1];
                    
                }
                [tableview replacedata:nodear];
                [typearr removeAllObjects];
                [wularr removeAllObjects];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                
                [self qq_performSVHUDBlock:^{
                    [SVProgressHUD showErrorWithStatus:@"账号或密码错误"];
                }];
            }];

      //  }
       // else
       // {
            
       // }
        
}
       if(node.depth==2)
    {
        for(Node *nd in data1)
        {
            if (nd.nodeId==node.parentId) {
                parent=nd.name;
                for (Node *ndd in data1) {
                    if (ndd.nodeId==nd.parentId) {
                        pparent=ndd.name;
                        child=node.name;
                    }
                }
            }
        }
    [self performSegueWithIdentifier:@"product" sender:self];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"product"]) {
        ProductdetalViewController *product=segue.destinationViewController;
        product.depth0=pparent;
        product.depth1=parent;
        product.depth2=child;
        
    }
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

//@end
