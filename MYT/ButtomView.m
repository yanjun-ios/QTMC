//
//  ButtomView.m
//  MYT
//
//  Created by 熊凯 on 15/12/11.
//  Copyright © 2015年 YunRui. All rights reserved.
//

#import "ButtomView.h"
#import "MainViewController.h"
#import "MoreViewController.h"
@implementation ButtomView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIButton* btn1=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 50)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"btnHome"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(goToMain) forControlEvents: UIControlEventTouchUpInside];
    UIButton* btn2=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2,0, ScreenWidth/2, 50)];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"btnMore"] forState:UIControlStateNormal];
     [btn2 addTarget:self action:@selector(goToMore) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview:btn1];
    [self addSubview:btn2];
    

}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


-(void)goToMain
{
    UINavigationController* Nv = [self viewController].navigationController;
    
    for (UIViewController *vcHome in Nv.viewControllers) {
        if ([vcHome isKindOfClass:[MainViewController class]]) {
            [Nv popToViewController:vcHome animated:YES];
        }
    }

}

-(void)goToMore
{
    UINavigationController* Nv = [self viewController].navigationController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
      UIViewController *moreVC= (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"moreVC"];
    [Nv pushViewController:moreVC animated:YES];
    
   
}

@end
