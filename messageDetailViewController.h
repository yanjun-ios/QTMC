//
//  messageDetailViewController.h
//  MYT
//
//  Created by 熊凯 on 16/1/14.
//  Copyright © 2016年 YunRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface messageDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *TF_show;
@property(nonatomic,retain)NSString* getMessageDetail;
@end
