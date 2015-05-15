//
//  UserCenterVC.m
//  SpringCareManage
//
//  Created by LiuZach on 15/5/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserCenterVC.h"
#import "UserSettingTableCell.h"
#import "define.h"
#import "WebContentVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "HomePageVC.h"
#import "QuickmarkVC.h"
#import "UserModel.h"
#import "ModifyPwdVC.h"
#import "UserLoginVC.h"

@interface UserCenterVC ()

@end

@implementation UserCenterVC
@synthesize tableview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"设置";
    
    [self initSubViews];
}

- (void) initSubViews
{
    tableview = [[UITableView alloc] initWithFrame:CGRectZero];
    tableview.dataSource = self;
    tableview.delegate = self;
    [self.ContentView addSubview:tableview];
    tableview.translatesAutoresizingMaskIntoConstraints = NO;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = TableBackGroundColor;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectZero];
    btnCancel.translatesAutoresizingMaskIntoConstraints = NO;
    btnCancel.layer.cornerRadius = 5;
    [btnCancel setTitleColor:_COLOR(0xff, 0xff, 0xff) forState:UIControlStateNormal];
    [btnCancel setTitle:@"退 出" forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[Util GetBtnBackgroundImage] forState:UIControlStateNormal];
    btnCancel.clipsToBounds = YES;
    [footView addSubview:btnCancel];
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-28-[btnCancel]-28-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btnCancel)]];
    [footView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-26-[btnCancel]-13-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btnCancel)]];
    [btnCancel addTarget:self action:@selector(btnCancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
    if(type == EnumValueTypeiPhone4S){
        footView.frame = CGRectMake(0, 0, ScreenWidth, 80);
        btnCancel.titleLabel.font = _FONT(17);
    }
    else if (type == EnumValueTypeiPhone5){
        footView.frame = CGRectMake(0, 0, ScreenWidth, 80);
        btnCancel.titleLabel.font = _FONT(17);
    }
    else if (type == EnumValueTypeiPhone6){
        footView.frame = CGRectMake(0, 0, ScreenWidth, 90);
        btnCancel.titleLabel.font = _FONT(18);
    }
    else if (type == EnumValueTypeiPhone6P){
        footView.frame = CGRectMake(0, 0, ScreenWidth, 100);
        btnCancel.titleLabel.font = _FONT(20);
    }else{
        footView.frame = CGRectMake(0, 0, ScreenWidth, 80);
        btnCancel.titleLabel.font = _FONT(17);
    }
    
    tableview.tableFooterView = footView;
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableview)]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableview)]];
    
    
}

- (void) btnCancelPressed:(id)sender
{
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation removeObject:[UserModel sharedUserInfo].userId forKey:@"channels"];
    [currentInstallation saveInBackground];
    [AVUser logOut];  //清除缓存用户对象
    [UserModel sharedUserInfo].userId = nil;
    //[[UserModel sharedUserInfo] modifyInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_Register_Logout object:nil];
    
    UserLoginVC *vc = [[UserLoginVC alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0 || section == 1)
        return 1;
    else if (section == 2)
        return 2;
    else
        return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        // 版本更新
        [Util  updateVersion:^(NSArray *info) {
            NSDictionary *releaseInfo = [info objectAtIndex:0];
            NSString  *appVersion  = [releaseInfo objectForKey:@"version"];
            _appDownUrl = [releaseInfo objectForKey:@"trackViewUrl"]; // 获取 更新用滴 URL
            if ([[Util getCurrentVersion] floatValue] < [appVersion floatValue])
            {
                UIAlertView * updateAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"升级到新版本%@", appVersion]
                                                                       message:[releaseInfo objectForKey:@"releaseNotes"] delegate:self
                                                             cancelButtonTitle:@"取消"
                                                             otherButtonTitles:@"升级", nil];
                updateAlert.tag=512;
                updateAlert.delegate = self;
                [updateAlert show];
                
            }
            
        }];
    }
    if(indexPath.section == 1){
        ModifyPwdVC *vc = [[ModifyPwdVC alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(indexPath.section == 2){
        if(indexPath.row == 0)
        {
            // 告诉朋友
            QuickmarkVC *vc = [[QuickmarkVC alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if(indexPath.row == 1){
            // 给app好评
            NSString *url = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",KEY_APPLE_ID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
    if(indexPath.section == 3){
        if(indexPath.row == 0)
        {
            NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, Service_Methord, About_Us];
            WebContentVC *vc = [[WebContentVC alloc] initWithTitle:@"关于我们" url:url];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSString *url = [NSString stringWithFormat:@"%@%@%@", SERVER_ADDRESS, Service_Methord, Care_Agreement];
            WebContentVC *vc = [[WebContentVC alloc] initWithTitle:@"护工协议" url:url];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserSettingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UserSettingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = TableSectionBackgroundColor;
    }
    
    if(indexPath.section == 0)
    {
        cell._lbTitle.text = @"版本检测";
        cell._lbContent.text = [Util getCurrentVersion];
        cell._lbContent.hidden = NO;
        cell._imgFold.hidden = YES;
    }else if (indexPath.section == 1){
        cell._lbTitle.text = @"修改密码";
        cell._lbContent.hidden = YES;
        cell._imgFold.hidden = NO;
    }
    else if (indexPath.section == 2)
    {
        if(indexPath.row == 0){
            cell._lbTitle.text = @"告诉朋友";
            cell._lbContent.hidden = YES;
            cell._imgFold.hidden = NO;
        }
        else if(indexPath.row == 1){
            cell._lbTitle.text = @"给我们好评";
            cell._lbContent.hidden = YES;
            cell._imgFold.hidden = NO;
        }else{
            cell._lbTitle.text = @"邀请码";
            cell._lbContent.hidden = YES;
            cell._imgFold.hidden = NO;
        }
    }
    else if (indexPath.section == 3)
    {
        if(indexPath.row == 0){
            cell._lbTitle.text = @"关于我们";
            cell._lbContent.hidden = YES;
            cell._imgFold.hidden = NO;
        }
        else{
            cell._lbTitle.text = @"护工协议";
            cell._lbContent.hidden = YES;
            cell._imgFold.hidden = NO;
        }
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 17.5f;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = TableSectionBackgroundColor;
    return view;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==512 && buttonIndex > 0) // 升级版本
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_appDownUrl]];
    }
}

@end
