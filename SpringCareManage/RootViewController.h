//
//  RootViewController.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageVC.h"
#import "EscortTimeVC.h"
#import "WorkSummaryVC.h"
#import "UserCenterVC.h"

@interface RootViewController : UITabBarController

@property (strong, nonatomic) HomePageVC *homeVC;
@property (strong, nonatomic) WorkSummaryVC *summaryVC;
@property (strong, nonatomic) EscortTimeVC *messageListVC;
@property (strong, nonatomic) UserCenterVC *userCenter;

@end
