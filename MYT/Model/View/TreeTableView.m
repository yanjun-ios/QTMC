//
//  TreeTableView.m
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "TreeTableView.h"
#import "Node.h"

@interface TreeTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *arr;
   
}

@property (nonatomic , strong) NSArray *data;//传递过来已经组织好的数据（全量数据）
@property (nonatomic , strong) NSMutableArray *tempData;//用于存储数据源（部分数据）


@end

@implementation TreeTableView
//加载第一层时候用
-(instancetype)initWithFrame:(CGRect)frame withData : (NSArray *)data{
  
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        _data =data;
        _tempData = [self createTempData:data];
        
        //消除多余空白行
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [self setTableFooterView:view];
    }
    return self;
}
//第2层，第3层用
-(void)replacedata:(NSArray *)data
{
    [_tempData removeAllObjects];
    _data =data;
    _tempData = [self repalceTempData:data];
}
-(NSMutableArray *)repalceTempData : (NSArray *)data{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<data.count; i++) {
        Node *node = [_data objectAtIndex:i];
        
            [tempArray addObject:node];
        
    }
    return tempArray;
}
/**
 * 初始化数据源
 */
-(NSMutableArray *)createTempData : (NSArray *)data{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<data.count; i++) {
        Node *node = [_data objectAtIndex:i];
        if (node.expand) {
            [tempArray addObject:node];
        }
    }
    return tempArray;
}


#pragma mark - UITableViewDataSource

#pragma mark - Required

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tempData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     Node *node = [_tempData objectAtIndex:indexPath.row];
    
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
    UITableViewCell *cell=cell = [tableView dequeueReusableCellWithIdentifier:NODE_CELL_ID];
    if (!cell) {
        
        if (node.depth==0||node.depth==1) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
            //数量
            UILabel* count;
            count=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, 50, 15)];
            count.center=cell.center;
            count.tag=11;
            count.textColor=[UIColor redColor];
            count.font=[UIFont systemFontOfSize:14];
            count.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:count];
            
            //匹配客户
            UILabel* men;
            men=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-80, 15, 80, 15)];
            men.tag=12;
            men.textColor=[UIColor greenColor];
            men.font=[UIFont systemFontOfSize:14];
            men.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:men];
            
            UIImageView *image=[[UIImageView alloc] init];
            image.tag=13;
            //if(node.child)
            // {
            
                if (node.depth==0) {
                    image.frame=CGRectMake(2, 16,8, 8);
                }
                
                else
                    image.frame=CGRectMake(25, 16,8, 8);
            
            
           
            //image.image=[UIImage imageNamed:@"left"];
            [cell.contentView addSubview:image];
        }
       /* else if(node.depth==1)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
            //数量
            UILabel* count;
            count=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, 50, 15)];
            count.center=cell.center;
            count.tag=11;
            count.textColor=[UIColor redColor];
            count.font=[UIFont systemFontOfSize:14];
            count.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:count];
            
            //匹配客户
            UILabel* men;
            men=[[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-80, 15, 80, 15)];
            men.tag=12;
            men.textColor=[UIColor greenColor];
            men.font=[UIFont systemFontOfSize:14];
            men.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:men];
            
            UIImageView *image=[[UIImageView alloc] init];
            image.tag=13;
            //if(node.child)
            // {
            if (node.child) {
                
                //image.frame=CGRectMake(0, 12,15, 15);
                
                image.frame=CGRectMake(25, 15,15, 15);
            }
            
            
            //image.image=[UIImage imageNamed:@"left"];
            [cell.contentView addSubview:image];
        }*/
        else if (node.depth==2)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
                    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 130, 30)];
                     text.borderStyle = UITextBorderStyleRoundedRect;
                    text.text=@"1";
                    [cell.contentView addSubview:text];
                    //设置边框样式，只有设置了才会显示边框样式
                    
                    text.borderStyle = UITextBorderStyleRoundedRect;
        }
       
           // if (node.depth==0) {
        
            // [cell.contentView addSubview:image];
            //}
        
            //else if (node.depth==1)
           // {
          // image.frame=CGRectMake(25, 15,15, 15);
            //[cell.contentView addSubview:image];
          //  }
      //  }
     
//
    }
//    else
//    {  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NODE_CELL_ID];
//        UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 130, 30)];
//         text.borderStyle = UITextBorderStyleRoundedRect;
//        text.text=@"1";
//        [cell.contentView addSubview:text];
//        
//        
//        //设置边框样式，只有设置了才会显示边框样式
//        
//        text.borderStyle = UITextBorderStyleRoundedRect;
//    }
    //
   
    UILabel* label2=(UILabel*)[cell.contentView viewWithTag:11];
    label2.text=node.name;

    UILabel* label3=(UILabel*)[cell.contentView viewWithTag:12];
    label3.text=node.name;
 
        UIImageView *image=(UIImageView*)[cell.contentView viewWithTag:13];
        image.image=[UIImage imageNamed:@"公司库存向右"];
    
  
  
   //
    // cell有缩进的方法
    cell.indentationLevel = node.depth; // 缩进级别
    cell.indentationWidth = 30.f; // 每个缩进级别的距离

    
//    NSMutableString *name = [NSMutableString string];
//    for (int i=0; i<node.depth; i++) {
//        [name appendString:@"     "];
//    }
    
//    [name appendString:node.name];
    cell.textLabel.font=[UIFont systemFontOfSize:12];
    cell.textLabel.text = node.name;
    
    return cell;
}

#pragma mark - Optional
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - UITableViewDelegate

#pragma mark - Optional
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //先修改数据源
    
    Node *parentNode = [_tempData objectAtIndex:indexPath.row];
    if (_treeTableCellDelegate && [_treeTableCellDelegate respondsToSelector:@selector(cellClick:)]) {
        [_treeTableCellDelegate cellClick:parentNode];
    }
    NSLog(@"%d,%hhd",parentNode.depth,parentNode.child);
    UITableViewCell* cell=[tableView cellForRowAtIndexPath:indexPath];
    NSUInteger startPosition = indexPath.row+1;
    NSUInteger endPosition = startPosition;
    BOOL expand = NO;
    for (int i=0; i<_data.count; i++) {
        Node *node = [_data objectAtIndex:i];
        NSLog(@"%d,%d",node.parentId,parentNode.nodeId);
        if (node.parentId == parentNode.nodeId) {
            node.expand = !node.expand;
            if (node.expand) {
                [_tempData insertObject:node atIndex:endPosition];
                expand = YES;
                endPosition++;
                UIImageView *image=[cell.contentView viewWithTag:13];
                
                    image.image=[UIImage imageNamed:@"公司库存向下"];
                
                
                
    
                
            }else{
                expand = NO;
                endPosition = [self removeAllNodesAtParentNode:parentNode];
                UIImageView *image=[cell.contentView viewWithTag:13];
                
                    image.image=[UIImage imageNamed:@"公司库存向右"];
                
                
                
                
                break;
               
             
            }
        }
    }
   
    //获得需要修正的indexPath
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (NSUInteger i=startPosition; i<endPosition; i++) {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPathArray addObject:tempIndexPath];
    }
    
    //插入或者删除相关节点
    if (expand) {
        [self insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [self deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    }
}

/**
 *  删除该父节点下的所有子节点（包括孙子节点）
 *
 *  @param parentNode 父节点
 *
 *  @return 该父节点下一个相邻的统一级别的节点的位置
 */
-(NSUInteger)removeAllNodesAtParentNode : (Node *)parentNode{
    NSUInteger startPosition = [_tempData indexOfObject:parentNode];
    NSUInteger endPosition = startPosition;
    for (NSUInteger i=startPosition+1; i<_tempData.count; i++) {
        Node *node = [_tempData objectAtIndex:i];
        endPosition++;
        if (node.depth <= parentNode.depth) {
            break;
        }
        if(endPosition == _tempData.count-1){
            endPosition++;
            node.expand = NO;
            break;
        }
        node.expand = NO;
    }
    if (endPosition>startPosition) {
        [_tempData removeObjectsInRange:NSMakeRange(startPosition+1, endPosition-startPosition-1)];
    }
    return endPosition;
}

@end
