//
//  AppDelegate.m
//  SpringCareManage
//
//  Created by forrestLee on 4/3/15.
//  Copyright (c) 2015 cmkj. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>
#import "define.h"
#import "LocationManagerObserver.h"
#import "UserModel.h"

#define AVOSCloudAppID  @"26x0xztg3ypms8o4ou42lxgk3gg6hl2rm6z9illft1pkoigh"
#define AVOSCloudAppKey @"0xjxw6o8kk5jtkoqfi8mbl17fxoymrk29fo7b1u6ankirw31"

//#define AVOSCloudAppID  @"mh5gyrc99m482n0bken77doebsr9u3sulj0arpqd172al9ki"
//#define AVOSCloudAppKey @"pdmukojziwgkcgus3rusw5wlao3orf7w0iw41470mrac73de"

@interface AppDelegate ()
{
    RootViewController *rootVC;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //设置AVOSCloud
    [AVOSCloud setApplicationId:AVOSCloudAppID
                      clientKey:AVOSCloudAppKey];
    //统计应用启动情况
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    /* 重要! 注册子类 App生命周期内 只需要执行一次即可*/
    //    [Student registerSubclass];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        // 第一次安装时运行打开推送
#if !TARGET_IPHONE_SIMULATOR
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                                    | UIUserNotificationTypeBadge
                                                    | UIUserNotificationTypeSound
                                                                                     categories:nil];
            [application registerUserNotificationSettings:settings];
            [application registerForRemoteNotifications];
        }
        else{
            [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |
             UIRemoteNotificationTypeAlert |
             UIRemoteNotificationTypeSound];
        }
#endif
        // 引导界面展示
        // [_rootTabController showIntroWithCrossDissolve];
        
    }
    
    //判断程序是不是由推送服务完成的
    if (launchOptions)
    {
        
        NSDictionary* notificationPayload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (notificationPayload)
        {
            [self performSelector:@selector(pushDetailPage:) withObject:notificationPayload afterDelay:1.0];
            [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    rootVC = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    nav.navigationBarHidden = YES;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self performSelector:@selector(openlocation) withObject:nil afterDelay:1.0f];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //推送功能打开时, 注册当前的设备, 同时记录用户活跃, 方便进行有针对的推送
    
    [AVUser logOut];  //清除缓存用户对象
    [UserModel sharedUserInfo].userId = nil;
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.deviceProfile = @"cfphu_nursedevelop";
    //TODO设置使用的推送证书
    [currentInstallation saveInBackground];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    //可选 通过统计功能追踪打开提醒失败, 或者用户不授权本应用推送
    [AVAnalytics event:@"开启推送失败" label:[error description]];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //可选 通过统计功能追踪通过提醒打开应用的行为
    //这儿你可以加入自己的代码 根据推送的数据进行相应处理
    NSLog(@"%@", @"didReceiveRemoteNotification");
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    // 程序在运行中接收到推送
    if (application.applicationState == UIApplicationStateActive)
    {
        [rootVC pushtoController:userInfo];
    }
    else  //程序在后台中接收到推送
    {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
        [self pushDetailPage:userInfo PushType:PushFromBcakground];
    }
}

- (void)openlocation{
    [LcationInstance startUpdateLocation];
}

-(void) pushDetailPage: (id)dic
{
    [self pushDetailPage:dic PushType:PushFromTerminate];
}

-(void) pushDetailPage: (id)dic PushType:(PushType)myPushtype
{
    [rootVC pushtoController:[[dic objectForKey:@"mt"] intValue] PushType:myPushtype];
}

@end
