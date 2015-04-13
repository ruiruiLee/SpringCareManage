//
//  UserLoginVC.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserLoginVC.h"
#import "define.h"

@interface UserLoginVC ()

@end

@implementation UserLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"登录";
    self.NavigationBar.btnLeft.hidden = YES;
    [self initSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubviews
{
    _tfPhoneNum = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_tfPhoneNum];
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
    [self.ContentView addSubview:_tfPwd];
    _tfPwd.translatesAutoresizingMaskIntoConstraints = NO;
    _tfPwd.placeholder = @"密码";
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
    [self.ContentView addSubview:_btnSubmit];
    _btnSubmit.translatesAutoresizingMaskIntoConstraints = NO;
    _btnSubmit.backgroundColor = Abled_Color;
    _btnSubmit.layer.cornerRadius = 5;
    [_btnSubmit setTitle:@"登录" forState:UIControlStateNormal];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tfPwd, _tfPhoneNum, _btnSubmit);
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_tfPhoneNum]-20-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_tfPwd]-20-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_btnSubmit]-20-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-21-[_tfPhoneNum(40)]-20-[_tfPwd(40)]-20-[_btnSubmit(40)]->=0-|" options:0 metrics:nil views:views]];
}


@end
