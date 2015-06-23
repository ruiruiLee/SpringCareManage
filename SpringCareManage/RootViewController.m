//
//  RootViewController.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "RootViewController.h"
#import "MPNotificationView.h"

#import "MsgListVC.h"
#import "UserModel.h"
#import "UserLoginVC.h"

@interface RootViewController ()

@end

@implementation RootViewController
@synthesize homeVC;
@synthesize summaryVC;
@synthesize messageListVC;
//@synthesize userCenter;

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)NotifyUserForbidden:(NSNotification *)notify
{
    AVUser *user = [AVUser currentUser];
    if(![[user objectForKey:@"status"] boolValue]){
        UserLoginVC *vc = [[UserLoginVC alloc] initWithNibName:nil bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        [Util showAlertMessage:@"该账户被禁用，请与管理员联系"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyUserForbidden:) name:Notify_User_Forbidden object:nil];
    
    homeVC = [[HomePageVC alloc] initWithNibName:nil bundle:nil];
    homeVC.tabBarItem.title=@"工作台";
    homeVC.tabBarItem.image=[UIImage imageNamed:@"tab-home-selected"];
    [homeVC.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    summaryVC = [[WorkSummaryVC alloc] initWithNibName:nil bundle:nil];
    summaryVC.tabBarItem.title=@"护理日志";
    summaryVC.tabBarItem.image=[UIImage imageNamed:@"tab-message"];
    [summaryVC.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:summaryVC];
    
    messageListVC = [[EscortTimeVC alloc] initWithNibName:nil bundle:nil];
    messageListVC.tabBarItem.title=@"陪护时光";
    [messageListVC.tabBarItem setImage:[UIImage imageNamed:@"tab-lovetime"]];
    [messageListVC.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:messageListVC];
    
//    userCenter = [[UserCenterVC alloc] initWithNibName:nil bundle:nil];
//    userCenter.tabBarItem.title=@"个人中心";
//    [userCenter.tabBarItem setImage:[UIImage imageNamed:@"tab-lovetime"]];
//    [userCenter.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
//    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:userCenter];
    
    self.viewControllers=@[nav1, nav3, nav2];
    
    UIColor *normalColor = Disabled_Color;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       normalColor, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = Abled_Color;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateSelected];
    [[UITabBar appearance] setTintColor:Abled_Color];//UITextAttributeFont
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       _FONT(12), UITextAttributeFont,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       _FONT(12), UITextAttributeFont,
                                                       nil] forState:UIControlStateSelected];
    
    UIImageView *tabBarBgView = [[UIImageView alloc] initWithFrame:self.tabBar.bounds];
    tabBarBgView.backgroundColor = _COLOR(0xe5, 0xe4, 0xe5);
    [self.tabBar insertSubview:tabBarBgView atIndex:0];
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

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIPageViewController delegate methods


-(void) pushtoController:(NSInteger)mt PushType:(PushType)curentPushtype{
    switch (mt) {
        case 1:   // 订单
        {
            [homeVC.refreshView startAnimatingWithScrollView:homeVC.tableview];
            [homeVC egoRefreshTableHeaderDidTriggerRefresh:homeVC.refreshView];
            break;
        }
        case 2:   // 陪护时光
        {
            self.selectedIndex = 1;
            break;
            
        }
        case 3:  // 关注
        {
            break;
            
        }
        case 4:{
            MsgListVC *vc = [[MsgListVC alloc] initWithNibName:nil bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
            
    }
}

-(void) pushtoController:(id)dic{
    
    if([[dic objectForKey:@"mt"] intValue] == 1){
        [homeVC.refreshView startAnimatingWithScrollView:homeVC.tableview];
        [homeVC egoRefreshTableHeaderDidTriggerRefresh:homeVC.refreshView];
    }
    
    [MPNotificationView notifyWithText:@"信息提示"
                                detail:[[dic objectForKey:@"aps"] objectForKey:@"alert"]
                                 image:ThemeImage(@"icontitle")
                           andDuration:4.0
                             msgparams:dic];
    
    
}

@end
