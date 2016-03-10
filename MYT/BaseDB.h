//
//  BaseDB.h
//  myLCourse
//
//  Created by YUNRUIMAC on 15/4/16.
//  Copyright (c) 2015年 云瑞信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
@interface BaseDB : NSObject
/**
 *  创建一个表
 *  sql:执行的SQL语句
 *  dataName:数据库名称
 */

-(void) createTable:(NSString*)sql dataBaseName:(NSString*) dataName;
/**
 *  执行SQL语句，主要完成增加、修改、删除
 *  sql:执行的SQL语句
 *  params:SQL语句中的参数
 *  dataName:数据库名称
 */
-(BOOL) execSql:(NSString*)sql parmas:(NSArray*) params dataBaseName:(NSString*)dataName;
/**
 *  选择数据
 *  sql:查询的SQL语句
 *  params:查询SQL语句中的参数
 *  dataName:查询数据库名称
 */

-(NSMutableArray*) selectSql:(NSString*)sql parmas:(NSArray*) params dataBaseName:(NSString*)dataName;




@end
