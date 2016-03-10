//
//  Node.h
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  每个节点类型
 */
@interface Node : NSObject

@property (nonatomic , copy) NSString* parentId;//父节点的id，如果为-1表示该节点为根节点

@property (nonatomic , copy) NSString* nodeId;//本节点的id

@property (nonatomic , strong) NSString *name;//本节点的名称

@property (nonatomic , assign) int depth;//该节点的深度

@property (nonatomic , assign) BOOL expand;//该节点是否处于展开状态

@property (nonatomic , assign) BOOL child;//该节点是否有孩子

@property (nonatomic , assign)NSString* matid;//物料id
@property (nonatomic , assign)int counts;//库存量
@property (nonatomic , assign)int matecounts;//匹配到的客户数量
/**
 *快速实例化该对象模型
 */
- (instancetype)initWithParentId : (NSString*)parentId nodeId : (NSString*)nodeId name : (NSString *)name depth : (int)depth expand : (BOOL)expand child:(BOOL)child matid:(NSString*)matid counts:(int)counts matecounts:(int)matecounts;

@end
