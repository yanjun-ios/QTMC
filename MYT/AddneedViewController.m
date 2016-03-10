//
//  AddneedViewController.m
//  MYT
//
//  Created by YUNRUIMAC on 16/1/16.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import "AddneedViewController.h"
#import "Node1.h"
#import "NetRequestManager.h"
#import "QQRequestManager.h"
#import "MJRefresh.h"
@interface AddneedViewController ()
{
    NSArray *init;
    int mat;//物料id
    NSMutableArray *nodear;//所有node数据
    NSMutableArray *_tempedata;//要显示的所有数据
    __block  NSMutableArray  *typearr;//存类型为T的物料类别
    __block  NSMutableArray  *wularr;//存类型为W的物料类别
    NSMutableArray * typjson;
    NSMutableArray*  wuljson;
    UIAlertView *alert ;
    NSMutableArray *typea;
    NSMutableArray *wula;
    NSMutableArray *ndone;
    int zf;
    BOOL iffindtext;
    BOOL findclick;
}

@end
@implementation AddneedViewController
-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden=NO;
    findclick=NO;
}
- (void)viewDidLoad {
   
    //消除多余空白行
    _findview.hidden=YES;
    _findtext.delegate=self;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    zf=1;
    iffindtext=NO;
   _clientId= [NetRequestManager sharedInstance].clientId;
   self.tableView.delegate=self;
    self.tableView.dataSource=self;
    _tempedata=[[NSMutableArray alloc]init];
    nodear=[[NSMutableArray alloc] init];
    typearr=[[NSMutableArray alloc]init];
    wularr=[[NSMutableArray alloc]init];
    nodear=[[NSMutableArray alloc]init];
    typjson=[[NSMutableArray alloc]init];
    wuljson=[[NSMutableArray alloc]init];
    ndone=[[NSMutableArray alloc]init];
    typea=[[NSMutableArray alloc]init];
    wula=[[NSMutableArray alloc]init];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _stocksearch.delegate=self;
    NSLog(@"%@",_nodearr);
    for(int i=0;i<_nodearr.count;i++)
    {
        NSMutableArray *nodea=[[NSMutableArray alloc]init];//创建每行
        [nodea addObject:[_nodearr objectAtIndex:i]];//将第一层的node分别加入不同的可变数组
        
        [nodear addObject:nodea];
    }
    [self initwithnodear];
    NSLog(@"%@",nodear);
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    zf=1;
    NSString *find=[searchText stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *findtext = [find stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([findtext  isEqualToString:@""]) {
        iffindtext=NO;
    }
    else
        iffindtext=YES;
    [nodear removeAllObjects];
    [ndone removeAllObjects];
    [typea removeAllObjects];
    [wula removeAllObjects];
    NSLog(@"%@",ndone);
    NSString *pagenum=[NSString stringWithFormat:@"%d",zf];
    NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
    [parDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]);
    [parDic setValue:@"null" forKey:@"parentid"];
    [parDic setValue:pagenum forKey:@"pageNum"];
    if (iffindtext) {
        [parDic setValue:findtext forKey:@"search"];
    }
    [parDic setValue:@"5" forKey:@"pageSize"];//依次请求
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(concurrentQueue, ^{
        [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingString:@"yd/getMatTree.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            
            _totlePage=((NSNumber*)[responseObject objectForKey:@"totlePage"]).intValue;
            init=[responseObject objectForKey:@"list"];
            for (NSDictionary *dic in init) {
                if ([[dic objectForKey:@"tw"] isEqualToString:@"T"]) {
                    [typea addObject:dic];
                }
                else
                {
                    [wula addObject:dic];
                }
            }
            for (int i=0; i<typea.count; i++) {
                NSDictionary * typeinfo=[typea objectAtIndex:i];
                NSString* nodeid=[typeinfo objectForKey:@"typeid"];
                int counts=((NSNumber*)[typeinfo objectForKey:@"counts"]).intValue;
            
                Node1 * node=[[Node1 alloc]initWithParentId:@"-1" nodeId:nodeid name:[typeinfo objectForKey:@"typename"] depth:0 expand:YES child:YES matid:@"-1" typid:nodeid needcount:counts];
                [ndone addObject:node];
            }
            for (int i=0; i<wula.count; i++) {
                NSDictionary * wulinfo=[wula objectAtIndex:i];
                NSString* nodeid=[wulinfo objectForKey:@"matid"];
                int counts=((NSNumber*)[wulinfo objectForKey:@"counts"]).intValue;
                Node1 * node=[[Node1 alloc]initWithParentId:@"-1" nodeId:nodeid name:[wulinfo objectForKey:@"mattername"] depth:0 expand:YES child:NO matid:nodeid  typid:@"-1" needcount:counts];
                [ndone addObject:node];
                
            }
            NSLog(@"%@",ndone);
            for(int i=0;i<ndone.count;i++)
            {
                NSMutableArray *nodea=[[NSMutableArray alloc]init];//创建每行
                [nodea addObject:[_nodearr objectAtIndex:i]];//将第一层的node分别加入不同的可变数组
                
                [nodear addObject:nodea];
            }
            
            [self initwithnodear];
            [_tableView reloadData];
            //将请求到的第一层数据分类
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            
            [self qq_performSVHUDBlock:^{
                [SVProgressHUD showErrorWithStatus:@"请求数据失败"];
            }];
        }];
        
        /*download the image here*/
        
    });
}

- (void)loadMoreData
{
    NSString *find=[_stocksearch.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *findtext = [find stringByReplacingOccurrencesOfString:@" " withString:@""];
    // 1.添加假数据
    if (zf<_totlePage+1) {
        zf++;
        [ndone removeAllObjects];
        [typea removeAllObjects];
        [wula removeAllObjects];
        NSLog(@"%@",ndone);
        NSString *pagenum=[NSString stringWithFormat:@"%d",zf];
        NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
        [parDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]);
        if (iffindtext) {
            [parDic setValue:findtext forKey:@"search"];
        }
        [parDic setValue:@"null" forKey:@"parentid"];
        [parDic setValue:pagenum forKey:@"pageNum"];
        [parDic setValue:@"5" forKey:@"pageSize"];//依次请求
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_sync(concurrentQueue, ^{
            [[QQRequestManager sharedRequestManager] GET:[SEVER_URL stringByAppendingString:@"yd/getMatTree.action"] parameters:parDic showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
                
                
                init=[responseObject objectForKey:@"list"];
                for (NSDictionary *dic in init) {
                    if ([[dic objectForKey:@"tw"] isEqualToString:@"T"]) {
                        [typea addObject:dic];
                    }
                    else
                    {
                        [wula addObject:dic];
                    }
                }
                for (int i=0; i<typea.count; i++) {
                    NSDictionary * typeinfo=[typea objectAtIndex:i];
                    NSString* nodeid=[typeinfo objectForKey:@"typeid"];
                    int counts=((NSNumber*)[typeinfo objectForKey:@"counts"]).intValue;
                   
                    Node1 * node=[[Node1 alloc]initWithParentId:@"-1" nodeId:nodeid name:[typeinfo objectForKey:@"typename"] depth:0 expand:YES child:YES matid:@"-1" typid:nodeid needcount:counts];
                    [ndone addObject:node];
                }
                for (int i=0; i<wula.count; i++) {
                    NSDictionary * wulinfo=[wula objectAtIndex:i];
                    NSString* nodeid=[wulinfo objectForKey:@"matid"];
                    int counts=((NSNumber*)[wulinfo objectForKey:@"counts"]).intValue;
                   
                    Node1 * node=[[Node1 alloc]initWithParentId:@"-1" nodeId:nodeid name:[wulinfo objectForKey:@"mattername"] depth:0 expand:YES child:NO matid:nodeid  typid:@"-1" needcount:counts];
                    [ndone addObject:node];
                    
                }
                NSLog(@"%@",ndone);
                for(int i=0;i<ndone.count;i++)
                {
                    NSMutableArray *nodea=[[NSMutableArray alloc]init];//创建每行
                    [nodea addObject:[ndone objectAtIndex:i]];//将第一层的node分别加入不同的可变数组
                    
                    [nodear addObject:nodea];
                }
                [self initwithnodear];
                [_tableView reloadData];
                //将请求到的第一层数据分类
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                
                [self qq_performSVHUDBlock:^{
                    [SVProgressHUD showErrorWithStatus:@"请求数据失败"];
                }];
            }];
            
            /*download the image here*/
            
        });
        zf++;
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"已经到底啦"];
    }
    
    
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    
    // 刷新表格
    
    
    // 拿到当前的上拉刷新控件，结束刷新状态
    [_tableView.mj_footer endRefreshing];
    
}

-(void)initwithnodear
{
    [_tempedata removeAllObjects];
    for (int i=0; i<nodear.count; i++) {
        for (int j=0; j<((NSMutableArray*)[nodear objectAtIndex:i]).count; j++) {
            [_tempedata addObject:(Node1*)[(NSMutableArray*)[nodear objectAtIndex:i] objectAtIndex:j]];
        }
    }//暂时测试2级
    // [_tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tempedata.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Node1 *node = [_tempedata objectAtIndex:indexPath.row];
    NSLog(@"%@",node.nodeId);
    static NSString *NODE_CELL_ID ;
    if (node.depth==0||node.depth==1) {
        NODE_CELL_ID = @"node_cell_id0";
        
        
        
    }
    /*else if(node.depth==1)
     {
     NODE_CELL_ID = @"node_cell_id1";
     }*/
    else if(node.depth==2)
    {
        NODE_CELL_ID = @"node_cell_id2";
    }
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
    if (!cell) {
        if (node.depth==0||node.depth==1) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
            //数量
            UILabel* count;
            count=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-40, 15, 80, 15)];
            
            count.tag=11;
            count.textColor=[UIColor redColor];
            count.font=[UIFont systemFontOfSize:14];
            count.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:count];
            
            //需求量输入框
            UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-80, 8, 80, 30)];
            text.borderStyle = UITextBorderStyleRoundedRect;
           
            
            text.text=@"";
            text.tag=1000;
            [cell.contentView addSubview:text];
            UIImageView *image=[[UIImageView alloc] init];
            image.tag=13;
            //if(node.child)
            // {
           
            
            
            
            //image.image=[UIImage imageNamed:@"left"];
            [cell.contentView addSubview:image];
        }
        else if (node.depth==2)
        {
              cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
            UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-80, 8, 80, 30)];
            text.borderStyle = UITextBorderStyleRoundedRect;
           
            //数量
            UILabel* count;
            count=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-40, 15, 80, 15)];
            
            count.tag=11;
            count.textColor=[UIColor redColor];
            count.font=[UIFont systemFontOfSize:14];
            count.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:count];
            text.text=@"";
            text.tag=1000;
            [cell.contentView addSubview:text];
            //设置边框样式，只有设置了才会显示边框样式
            
              text.borderStyle = UITextBorderStyleRoundedRect;
        }
        
    }
    UILabel* label2=(UILabel*)[cell.contentView viewWithTag:11];
    label2.font=[UIFont systemFontOfSize:14];
    label2.text=[NSString stringWithFormat:@"%@",node.nodeId];
    
    //输入框
    UITextField* textfield=(UITextField*)[cell.contentView viewWithTag:1000];
    textfield.delegate=self;
    textfield.text=@"";
    textfield.tag=1000;
    NSLog(@"%ld",(long)textfield.tag);

    
    UIImageView *image=(UIImageView*)[cell.contentView viewWithTag:13];
    if (node.depth==0) {
        NSLog(@"%@",node.name);
        image.frame=CGRectMake(2, 16,8, 8);
    }
    
    else if(node.depth==1)
    {
        NSLog(@"%@",node.name);
        image.frame=CGRectMake(25, 16,8, 8);
        //image.frame=CGRectMake(2, 16,8, 8);
    }
    image.image=[UIImage imageNamed:@"公司库存向右"];
    
    
    
    //
    // cell有缩进的方法
    cell.indentationLevel = node.depth; // 缩进级别
    cell.indentationWidth = 20.f; // 每个缩进级别的距离
    
    
    //    NSMutableString *name = [NSMutableString string];
    //    for (int i=0; i<node.depth; i++) {
    //        [name appendString:@"     "];
    //    }
    
    //    [name appendString:node.name];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.textLabel.text = node.name;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    Node1 *parentNode = [_tempedata objectAtIndex:indexPath.row];
    NSLog(@"%hd",parentNode.child);
    NSLog(@"%hd",parentNode.expand);
    NSLog(@"%@",nodear);
    __block  NSUInteger startPosition = indexPath.row+1;
    __block  NSUInteger endPosition = startPosition;
    
    if(parentNode.depth==0&&parentNode.child)
    {
        NSMutableArray * arr=[[NSMutableArray alloc]init];
        __block int j;
        for (int i=0;i<_nodearr.count;i++) {
            if (((Node1*)[_nodearr objectAtIndex:i]).nodeId==parentNode.nodeId) {
                arr=(NSMutableArray*)[nodear objectAtIndex:i];
                j=i;
            }
        }
        
        NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
        [parDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]);
        NSString *nodeid=[NSString stringWithFormat:@"%@",parentNode.nodeId];
        [parDic setValue:nodeid forKey:@"parentid"];
        [parDic setValue:@"1" forKey:@"pageNum"];
        [parDic setValue:@"10000" forKey:@"pageSize"];
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
                NSString* nodeid=[typeinfo objectForKey:@"typeid"];
                int counts=((NSNumber*)[typeinfo objectForKey:@"counts"]).intValue;
                
                Node1 * node1=[[Node1 alloc]initWithParentId:parentNode.nodeId nodeId:nodeid name:[typeinfo objectForKey:@"typename"] depth:1 expand:YES child:YES matid:@"-1" typid:nodeid needcount:counts];
                
                if (parentNode.expand) {
                    NSLog(@"%@",[nodear objectAtIndex:j]);
                    [(NSMutableArray*)[nodear objectAtIndex:j] addObject:node1];//增加
                    NSLog(@"%@",node1.nodeId);
                    endPosition++;
                    
                    
                }
                
            }
            
            for (int i=0; i<wularr.count; i++) {
                NSDictionary * wulinfo=[wularr objectAtIndex:i];
                NSString* nodeid=[wulinfo objectForKey:@"matid"];
                int counts=((NSNumber*)[wulinfo objectForKey:@"counts"]).intValue;
                Node1 * node1=[[Node1 alloc]initWithParentId:parentNode.nodeId nodeId:nodeid name:[wulinfo objectForKey:@"mattername"] depth:1 expand:NO child:NO matid:nodeid typid:@"-1" needcount:counts];
                if(parentNode.expand)
                {
                    [(NSMutableArray*)[nodear objectAtIndex:j] addObject:node1];
                    endPosition++;
                }
            }
            if (!parentNode.expand) {
                NSLog(@"%@",(NSMutableArray*)[nodear objectAtIndex:j]);
                NSLog(@"%lu",(unsigned long)((NSMutableArray*)[nodear objectAtIndex:j]).count);
                int numj=((NSMutableArray*)[nodear objectAtIndex:j]).count;
                for (int i=1; i<numj; i++) {
                    Node1 * nod=[(NSMutableArray*)[nodear objectAtIndex:j] objectAtIndex:1];
                    
                    [(NSMutableArray*)[nodear objectAtIndex:j] removeObject:nod];//移除
                    NSLog(@"%@",(NSMutableArray*)[nodear objectAtIndex:j]);
                }
            }
            
            if (!parentNode.expand) {
                endPosition = [self removeAllNodesAtParentNode:parentNode];
            }
            
            NSLog(@"%@",nodear);
            
            [typearr removeAllObjects];
            [wularr removeAllObjects];
            [self initwithnodear];
            
            NSMutableArray *indexPathArray = [NSMutableArray array];
            //修正indexpath
            for (NSUInteger i=startPosition; i<endPosition; i++) {
                NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPathArray addObject:tempIndexPath];
            }
            if (parentNode.expand) {
                [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            }
            
            parentNode.expand=!parentNode.expand;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            
            [self qq_performSVHUDBlock:^{
                [SVProgressHUD showErrorWithStatus:@"账号或密码错误"];
            }];
        }];
        
        //  }
        // else
        // {
        
        // }
        
    }//第2级可能有物料规格可能有物料
    else if (parentNode.depth==1&&parentNode.child)
    {
        NSMutableArray * arr=[[NSMutableArray alloc]init];
        NSMutableArray* insertdic=[[NSMutableArray alloc]init];
        
        __block int j;
        __block int k;
        NSLog(@"%@",nodear);
        for (int i=0;i<nodear.count;i++) {
            
            for (int z=0; z<((NSMutableArray*)[nodear objectAtIndex:i]).count; z++) {
                arr=(NSMutableArray*)[nodear objectAtIndex:i];//获取第2层全部
                NSLog(@"%@he%@",((Node1*)[arr objectAtIndex:z]).nodeId,parentNode.nodeId);
                if ([((Node1*)[arr objectAtIndex:z]).nodeId isEqual:parentNode.nodeId]) {
                    j=z;//获得第2层的插入位置
                    k=i;//获取在nodear中相对于哪一个数组
                }
            }
            // if (((Node*)[_nodearr objectAtIndex:i]).nodeId==parentNode.nodeId) {
            //   arr=(NSMutableArray*)[nodear objectAtIndex:i];
            // j=i;
            //}
        }
        
        NSLog(@"%@",nodear);
        NSMutableDictionary* parDic=[[NSMutableDictionary alloc]initWithCapacity:10];
        [parDic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"] forKey:@"userid"];
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"]);
        NSString *nodeid=[NSString stringWithFormat:@"%@",parentNode.nodeId];
        [parDic setValue:nodeid forKey:@"parentid"];
        [parDic setValue:@"1" forKey:@"pageNum"];
        [parDic setValue:@"10000" forKey:@"pageSize"];
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
            }//第3级默认全部是物料了
            NSLog(@"%hd",parentNode.expand);
            for (int i=0; i<wularr.count; i++) {
                NSDictionary * wulinfo=[wularr objectAtIndex:i];
                NSString* nodeid=[wulinfo objectForKey:@"matid"];
                int counts=((NSNumber*)[wulinfo objectForKey:@"counts"]).intValue;
                Node1 * node1=[[Node1 alloc]initWithParentId:parentNode.nodeId nodeId:nodeid name:[wulinfo objectForKey:@"mattername"] depth:2 expand:NO child:NO matid:nodeid typid:@"-1" needcount:counts];
                NSLog(@"%hd",parentNode.expand);
                if (parentNode.expand) {
                    //  NSLog(@"%@",[nodear objectAtIndex:j]);
                    [(NSMutableArray*)[nodear objectAtIndex:k] insertObject:node1 atIndex:j+i+1];//增加
                    endPosition++;
                    
                    
                }
                else
                {
                    NSLog(@"%@",nodear);
                    for (int i=indexPath.row+1; i<((NSMutableArray*)[nodear objectAtIndex:k]).count; i++) {
                        Node1 * nod=[(NSMutableArray*)[nodear objectAtIndex:k] objectAtIndex:i];
                        if (nod.nodeId==nodeid) {
                            [(NSMutableArray*)[nodear objectAtIndex:k] removeObject:nod];//移除
                        }
                        NSLog(@"%@",nodear);
                        
                    }
                    
                    
                }
                
                
            }
            if (!parentNode.expand) {
                endPosition = [self removeAllNodesAtParentNode:parentNode];
            }
            
            NSLog(@"%@",nodear);
            
            NSLog(@"%@",nodear);
            [typearr removeAllObjects];
            [wularr removeAllObjects];
            [self initwithnodear];
            
            NSMutableArray *indexPathArray = [NSMutableArray array];
            //修正indexpath
            for (NSUInteger i=startPosition; i<endPosition; i++) {
                NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPathArray addObject:tempIndexPath];
            }
            if (parentNode.expand) {
                [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            }
            
            parentNode.expand=!parentNode.expand;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            
            [self qq_performSVHUDBlock:^{
                [SVProgressHUD showErrorWithStatus:@"账号或密码错误"];
            }];
        }];
    }
    
    if(parentNode.expand)
    {
        UIImageView *image=(UIImageView*)[cell.contentView viewWithTag:13];
        image.image=[UIImage imageNamed:@"公司库存向下"];
    }
    else
    {
        UIImageView *image=(UIImageView*)[cell.contentView viewWithTag:13];
        image.image=[UIImage imageNamed:@"公司库存向右"];
    }
}
/**
 *  删除该父节点下的所有子节点（包括孙子节点）
 *
 *  @param parentNode 父节点
 *
 *  @return 该父节点下一个相邻的统一级别的节点的位置
 */
-(NSUInteger)removeAllNodesAtParentNode : (Node1 *)parentNode{
    
    NSUInteger startPosition = [_tempedata indexOfObject:parentNode];
    NSLog(@"%d",parentNode.depth);
    NSLog(@"%d",startPosition);
    NSUInteger endPosition = startPosition;
    for (NSUInteger i=startPosition+1; i<_tempedata.count; i++) {
        Node1 *node = [_tempedata objectAtIndex:i];
        endPosition++;
        if (node.depth <= parentNode.depth) {
            break;
        }
        if(endPosition == _tempedata.count-1){
            endPosition++;
            node.expand = NO;
            break;
        }
        node.expand = NO;
    }
    if (endPosition>startPosition) {
        [_tempedata removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition-1)];
    }
    return endPosition;
}

//-(void)Getfirststock
//{}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)textFieldDidEndEditing:(UITextField *)textField;
//{
  //  textField.text=@"";
   /* NSString *need = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    //int needint=need.intValue;
    int row=textField.tag-1000;
    Node1* node=[_tempedata objectAtIndex:row];
    NSString* nodeid=[NSString stringWithFormat:@"%d",node.nodeId];
    //先判断输入框中是否为空
    alert = [[UIAlertView alloc] initWithTitle:@"确认需求信息"
                                       message:[NSString stringWithFormat:@"%@需求量为%@",node.name,need]
                                      delegate:self
                             cancelButtonTitle:@"NO"
                             otherButtonTitles:@"YES",nil];
    //alert.delegate=self;
    if (![need isEqualToString:@""]) {
      //  [alert show];
       // if (ifs) {
            if (node.typid==node.nodeId) {
                NSDictionary* dic;
                dic=[NSDictionary dictionaryWithObjectsAndKeys:nodeid,@"id",need,@"ct", nil];
                [typjson addObject:dic];
            }//是物料规格
            else if(node.matid==node.nodeId)
            {
                NSDictionary* dic=[[NSDictionary alloc]initWithObjectsAndKeys:nodeid,@"id",need,@"ct", nil];
                [wuljson addObject:dic];
            }//是物料
            
     //  }
        
    }*/
    
   
//}
-(NSIndexPath *)tableView:(UITableView *)tableView
 willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_stocksearch resignFirstResponder];
    [_findtext resignFirstResponder];
    return indexPath;
}
- (IBAction)click_ok:(id)sender {
    NSLog(@"%@",_tempedata);
    for (int i=0; i<_tempedata.count; i++) {
        Node1 *node = [_tempedata objectAtIndex:i];
        NSLog(@"%@",node.nodeId);
        NSIndexPath *pathOne=[NSIndexPath indexPathForRow:i inSection:0];//获取cell的位置
        UITableViewCell *cell=(UITableViewCell *)[_tableView cellForRowAtIndexPath:pathOne];//获取具体位置的cell
        UITextField *textone=[cell.contentView viewWithTag:1000];
        NSString *need = [textone.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"%@",need);
        Node1* node2=(Node1*)[_tempedata objectAtIndex:i];
        //NSString* nodeid=[NSString stringWithFormat:@"%@",node.nodeId];
        if (![need isEqualToString:@""]&&need) {
            //  [alert show];
            // if (ifs) {
            NSLog(@"%@",node2.name);
            NSLog(@"%@he%@",node2.typid,node2.nodeId);
            if ([node2.typid isEqual:node2.nodeId]) {
                NSDictionary* dic;
                dic=[NSDictionary dictionaryWithObjectsAndKeys:node2.nodeId,@"id",need,@"ct", nil];
                [typjson addObject:dic];
            }//是物料规格
            else if([node2.matid isEqual:node2.nodeId])
            {
                NSDictionary* dic=[[NSDictionary alloc]initWithObjectsAndKeys:node2.nodeId,@"id",need,@"ct", nil];
                [wuljson addObject:dic];
            }//是物料
            
            //  }
            
        }
    }
    for (int i=0; i<_tempedata.count; i++) {
        
        NSIndexPath *pathOne=[NSIndexPath indexPathForRow:i inSection:0];//获取cell的位置
        UITableViewCell *cell=(UITableViewCell *)[_tableView cellForRowAtIndexPath:pathOne];//获取具体位置的cell
        UITextField *textone=[cell.contentView viewWithTag:1000];
        textone.text=@"";
    }//清空所有textfield

    if (typjson.count||wuljson.count) {
        NSString *clientidstr=_clientId;
        NSDictionary* jsondic=[[NSDictionary alloc]initWithObjectsAndKeys:typjson,@"T",wuljson,@"W",[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"],@"userid",clientidstr,@"cusid", nil];
        NSString*  datastr=[[NetRequestManager sharedInstance]DataToJsonString:jsondic];
        NSMutableDictionary *pir=[[NSMutableDictionary alloc]init];
        [pir setObject:datastr forKey:@"paraMap"];
        NSLog(@"%@",datastr);
        [[QQRequestManager sharedRequestManager] POST:[SEVER_URL stringByAppendingString:@"yd/addCusMatReq.action"] parameters:pir showHUD:YES success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",datastr);
            [self qq_performSVHUDBlock:^{
                [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
            }];
            [typjson removeAllObjects];
            [wuljson removeAllObjects];
            if([responseObject objectForKey:@"status"])
            {
                /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController popViewControllerAnimated:NO];
                 // 2秒后异步执行这里的代码...
                 
                 });*/
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            
            [self qq_performSVHUDBlock:^{
                [SVProgressHUD showErrorWithStatus:@"添加失败"];
            }];
        }];

    }
    else
        [self qq_performSVHUDBlock:^{
            [SVProgressHUD showErrorWithStatus:@"请输入需求量后再提交"];
        }];
   
}

- (IBAction)click_find:(id)sender {
    NSString *findtext = [_findtext.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([findtext isEqualToString:@""]) {
        [self qq_performSVHUDBlock:^{
            [SVProgressHUD showErrorWithStatus:@"请输入搜索内容"];
        }];
    }//空的话
    else
    {
        NSLog(@"%@",findtext);
        NSLog(@"%@",_tempedata);
        for (int i=0;i<_tempedata.count;i++) {
            Node1 *node=(Node1*)[_tempedata objectAtIndex:i];
            NSLog(@"%@",node.name);
            if ([node.name rangeOfString:findtext].location !=NSNotFound) {
                NSLog(@"找到了");
                NSUInteger sectionCount = [self.tableView numberOfSections];
                if (sectionCount) {
                    NSUInteger rowCount = i;
                    if (rowCount) {
                        NSUInteger ii[2] = {0, i};
                        NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
                        [self.tableView scrollToRowAtIndexPath:indexPath
                                              atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }
                }
            }
        }
    }

}
- (IBAction)find:(id)sender {
    if (!findclick) {
        _findview.hidden=NO;
        findclick=YES;
    }
    else
    {
        findclick=NO;
        _findview.hidden=YES;
    }

}
@end
