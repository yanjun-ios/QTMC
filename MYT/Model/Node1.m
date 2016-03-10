//
//  Node1.m
//  MYT
//
//  Created by YUNRUIMAC on 16/1/17.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import "Node1.h"

@implementation Node1
- (instancetype)initWithParentId : (NSString*)parentId nodeId : (NSString*)nodeId name : (NSString *)name depth : (int)depth expand : (BOOL)expand child:(BOOL)child matid:(NSString*)matid typid:(NSString*)typid needcount:(int)needcount{
    self = [self init];
    if (self) {
        self.parentId = parentId;
        self.nodeId = nodeId;
        self.name = name;
        self.depth = depth;
        self.expand = expand;
        self.child=child;
        self.matid=matid;
        self.typid=typid;
        self.needcount=needcount;
    }
    return self;
}
@end
