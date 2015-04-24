//
//  UserLoginVC.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserLoginVC.h"
#import "define.h"
#import "IQKeyboardReturnKeyHandler.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>
#import "UserModel.h"

@interface UserLoginVC ()

@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;

@end

@implementation UserLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"登录";
    self.NavigationBar.btnLeft.hidden = YES;
    [self initSubviews];
    
//    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
//    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyNext;
//    self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubviews
{
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_scrollview];
    _scrollview.translatesAutoresizingMaskIntoConstraints = NO;
    
    _tfPhoneNum = [[UITextField alloc] initWithFrame:CGRectZero];
    [_scrollview addSubview:_tfPhoneNum];
    _tfPhoneNum.translatesAutoresizingMaskIntoConstraints = NO;
    _tfPhoneNum.placeholder = @"手机号";
    _tfPhoneNum.font = _FONT(16);
    _tfPhoneNum.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _tfPhoneNum.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 0)];
    _tfPhoneNum.leftViewMode = UITextFieldViewModeAlways;
    _tfPhoneNum.layer.cornerRadius = 5;
    _tfPhoneNum.layer.borderWidth = 1;
    _tfPhoneNum.layer.borderColor = _COLOR(0x99, 0x99, 0x99).CGColor;
    _tfPhoneNum.keyboardType = UIKeyboardTypeNumberPad;
    _tfPhoneNum.textColor = _COLOR(0x22, 0x22, 0x22);
    
    _tfPwd = [[UITextField alloc] initWithFrame:CGRectZero];
    [_scrollview addSubview:_tfPwd];
    _tfPwd.translatesAutoresizingMaskIntoConstraints = NO;
    _tfPwd.placeholder = @"请输入6-14位密码";
    _tfPwd.font = _FONT(16);
    _tfPwd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _tfPwd.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 0)];
    _tfPwd.leftViewMode = UITextFieldViewModeAlways;
    _tfPwd.layer.cornerRadius = 5;
    _tfPwd.layer.borderWidth = 1;
    _tfPwd.layer.borderColor = _COLOR(0x99, 0x99, 0x99).CGColor;
    _tfPwd.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _tfPwd.textColor = _COLOR(0x22, 0x22, 0x22);
    
    _btnSubmit = [[UIButton alloc] initWithFrame:CGRectZero];
    [_scrollview addSubview:_btnSubmit];
    _btnSubmit.translatesAutoresizingMaskIntoConstraints = NO;
    _btnSubmit.backgroundColor = Abled_Color;
    _btnSubmit.layer.cornerRadius = 5;
    [_btnSubmit setTitle:@"登录" forState:UIControlStateNormal];
    [_btnSubmit addTarget:self action:@selector(ActionToLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tfPwd, _tfPhoneNum, _btnSubmit, _scrollview);
    
    NSString *format = [NSString stringWithFormat:@"H:|-20-[_tfPhoneNum(%f)]-20-|", ScreenWidth - 40];
    [_scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
    [_scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_tfPwd]-20-|" options:0 metrics:nil views:views]];
    [_scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_btnSubmit]-20-|" options:0 metrics:nil views:views]];
    [_scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-21-[_tfPhoneNum(40)]-20-[_tfPwd(40)]-20-[_btnSubmit(40)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_scrollview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_scrollview]-0-|" options:0 metrics:nil views:views]];
}

//键盘监控事件
- (void) keyboardWillShow:(NSNotification *) notify
{
    EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
    if(type == EnumValueTypeiPhone4S){
        [UIView animateWithDuration:0.25 animations:^{
            _scrollview.contentOffset = CGPointMake(0, 20);
        }];
    }
}

//ACTION
- (void) ActionToLogin:(UIButton *) sender
{
    NSString *userName = _tfPhoneNum.text;
    if(![NSStrUtil isMobileNumber:userName]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码有误！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSString *pwd = _tfPwd.text;
    if([pwd length] < 6 || [pwd length] > 14){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [AVUser logInWithMobilePhoneNumberInBackground:userName password:pwd block:^(AVUser *user, NSError *error) {
        if(error == nil){
            UserModel *model = [UserModel sharedUserInfo];
            
            model.userId = user.objectId;
            model.userName = user.username;
            model.phone = user.mobilePhoneNumber;
            model.chineseName = [user objectForKey:@"chinese_name"];
            model.isNew = user.isNew;
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

@end
