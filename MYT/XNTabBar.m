//
//  XNTabBar.m
//  CustomTabbar
//
//  Created by 熊凯 on 15/11/28.
//  Copyright © 2015年 YanJun. All rights reserved.
//

#import "XNTabBar.h"
#import "XNTabBarButton.h"

@interface XNTabBar()
//设置之前选中的按钮
@property(nonatomic,weak)UIButton* selectedBtn;

@end

@implementation XNTabBar

/**
*  在这个方法里写控件初始化的东西, 调用init方法时会调用
*/
//- (id)initWithFrame:(CGRect)frame {
//  if (self = [super initWithFrame:frame]) {
//      //添加按钮
//      for (int i = 0; i < 5; i++) { //取消掉特定的数字
//          //UIButton *btn = [[UIButton alloc] init];
//          XNTabBarButton *btn = [[XNTabBarButton alloc] init];
//
//          NSString *imageName = [NSString stringWithFormat:@"TabBar%d", i + 1];
//          NSString *imageNameSel = [NSString stringWithFormat:@"TabBar%dSel", i + 1];
//
//          [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//          [btn setImage:[UIImage imageNamed:imageNameSel] forState:UIControlStateSelected];
//
//          [self addSubview:btn];
//
//          btn.tag = i; //设置按钮的标记, 方便来索引当前的按钮,并跳转到相应的视图
//
//          //带参数的监听方法记得加"冒号"
//          [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
//
//          if (0 == i) {
//              [self clickBtn:btn];
//          }
//      }
//  }
//  return self;
//}

- (void)addButtonWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    UIButton *btn = [[UIButton alloc] init];

    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selectedImage forState:UIControlStateSelected];

    [self addSubview:btn];

    //带参数的监听方法记得加"冒号"
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];

    //如果是第一个按钮, 则选中(按顺序一个个添加)
    if (self.subviews.count == 1) {
        [self clickBtn:btn];
    }
}

/**专门用来布局子视图, 别忘了调用super方法*/
- (void)layoutSubviews {
    [super layoutSubviews];

    int count = (int)self.subviews.count;
    int btncount=0;
    for(int k=0;k<count;k++)
    {
         if([self.subviews[k] isKindOfClass:[UIButton class]])
         {
             btncount++;
         }
    }
    for (int i = 0; i < btncount; i++) {
        
        if([self.subviews[i] isKindOfClass:[UIButton class]])
        {
            //取得按钮
            UIButton *btn = self.subviews[i];
            
            btn.tag = i; //设置按钮的标记, 方便来索引当前的按钮,并跳转到相应的视图
            
            CGFloat x = i * self.bounds.size.width / btncount;
            CGFloat y = 0;
            CGFloat width = self.bounds.size.width / btncount;
            CGFloat height = self.bounds.size.height;
            btn.frame = CGRectMake(x, y, width, height);
            
            if (btn.tag==_myindex&&_myindex!=0) {
                [self clickBtn:btn];
            }

        }
           }
}

/**
*  自定义TabBar的按钮点击事件
*/
- (void)clickBtn:(UIButton *)button {
    //1.先将之前选中的按钮设置为未选中
    self.selectedBtn.selected = NO;
    //2.再将当前按钮设置为选中
    button.selected = YES;
    //3.最后把当前按钮赋值为之前选中的按钮
    self.selectedBtn = button;

    //却换视图控制器的事情,应该交给controller来做
    //最好这样写, 先判断该代理方法是否实现
    if ([self.delegate respondsToSelector:@selector(tabBar:selectedFrom:to:)]) {
        [self.delegate tabBar:self selectedFrom:self.selectedBtn.tag to:button.tag];
    }

    //4.跳转到相应的视图控制器. (通过selectIndex参数来设置选中了那个控制器)
    //self.selectedIndex = button.tag;
}

@end
