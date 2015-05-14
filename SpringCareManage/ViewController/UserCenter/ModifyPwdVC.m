//
//  ModifyPwdVC.m
//  SpringCareManage
//
//  Created by LiuZach on 15/5/14.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "ModifyPwdVC.h"
#import <AVOSCloud/AVOSCloud.h>

@interface ModifyPwdVC ()

@end

@implementation ModifyPwdVC
@synthesize scrollview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = @"修改密码";
    
    [self initSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) HandleTapGestureRecognizer
{
    [_tfOldPwd resignFirstResponder];
    [_tfPwd resignFirstResponder];
    [_tfRePwd resignFirstResponder];
}

- (void) initSubViews
{
    UIColor *bodercolor = _COLOR(0xdd, 0xdd, 0xdd);
    
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.ContentView addSubview:scrollview];
    
    UITapGestureRecognizer * tapOnce=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HandleTapGestureRecognizer)];
    tapOnce.numberOfTapsRequired=1;
    tapOnce.numberOfTouchesRequired=1;
    
    [scrollview addGestureRecognizer:tapOnce];
    
    UILabel *lbOldPwd = [[UILabel alloc] initWithFrame:CGRectZero];
    [scrollview addSubview:lbOldPwd];
    lbOldPwd.translatesAutoresizingMaskIntoConstraints = NO;
    lbOldPwd.font = _FONT(14);
    lbOldPwd.text = @"旧密码：";
    lbOldPwd.textColor = _COLOR(0x66, 0x66, 0x66);
    
    _tfOldPwd = [[UITextField alloc] initWithFrame:CGRectZero];
    [scrollview addSubview:_tfOldPwd];
    _tfOldPwd.translatesAutoresizingMaskIntoConstraints = NO;
    _tfOldPwd.font = _FONT(14);
    _tfOldPwd.clearButtonMode = UITextFieldViewModeAlways;
    _tfOldPwd.clearsOnInsertion = YES;
    _tfOldPwd.secureTextEntry = YES;
    _tfOldPwd.layer.cornerRadius = 4;
    _tfOldPwd.layer.borderWidth = 1;
    _tfOldPwd.layer.borderColor = bodercolor.CGColor;
    _tfOldPwd.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    _tfOldPwd.leftViewMode = UITextFieldViewModeAlways;
    _tfOldPwd.delegate = self;
    _tfOldPwd.returnKeyType = UIReturnKeyNext;
    
    UILabel *lbPwd = [[UILabel alloc] initWithFrame:CGRectZero];
    [scrollview addSubview:lbPwd];
    lbPwd.translatesAutoresizingMaskIntoConstraints = NO;
    lbPwd.font = _FONT(14);
    lbPwd.text = @"新密码：";
    lbPwd.textColor = _COLOR(0x66, 0x66, 0x66);
    
    _tfPwd = [[UITextField alloc] initWithFrame:CGRectZero];
    [scrollview addSubview:_tfPwd];
    _tfPwd.translatesAutoresizingMaskIntoConstraints = NO;
    _tfPwd.font = _FONT(14);
    _tfPwd.clearButtonMode = UITextFieldViewModeAlways;
    _tfPwd.clearsOnInsertion = YES;
    _tfPwd.secureTextEntry = YES;
    _tfPwd.layer.cornerRadius = 4;
    _tfPwd.layer.borderWidth = 1;
    _tfPwd.layer.borderColor = bodercolor.CGColor;
    _tfPwd.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    _tfPwd.leftViewMode = UITextFieldViewModeAlways;
    _tfPwd.delegate = self;
    _tfPwd.returnKeyType = UIReturnKeyNext;
    
    UILabel *lbRePwd = [[UILabel alloc] initWithFrame:CGRectZero];
    [scrollview addSubview:lbRePwd];
    lbRePwd.translatesAutoresizingMaskIntoConstraints = NO;
    lbRePwd.font = _FONT(14);
    lbRePwd.text = @"确认密码：";
    lbRePwd.textColor = _COLOR(0x66, 0x66, 0x66);
    
    _tfRePwd = [[UITextField alloc] initWithFrame:CGRectZero];
    [scrollview addSubview:_tfRePwd];
    _tfRePwd.translatesAutoresizingMaskIntoConstraints = NO;
    _tfRePwd.font = _FONT(14);
    _tfRePwd.clearButtonMode = UITextFieldViewModeAlways;
    _tfRePwd.clearsOnInsertion = YES;
    _tfRePwd.secureTextEntry = YES;
    _tfRePwd.layer.cornerRadius = 4;
    _tfRePwd.layer.borderWidth = 1;
    _tfRePwd.layer.borderColor = bodercolor.CGColor;
    _tfRePwd.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    _tfRePwd.leftViewMode = UITextFieldViewModeAlways;
    _tfRePwd.delegate = self;
    _tfRePwd.returnKeyType = UIReturnKeySend;
    
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectZero];
    [scrollview addSubview:btnSubmit];
    btnSubmit.translatesAutoresizingMaskIntoConstraints = NO;
    btnSubmit.layer.cornerRadius = 5;
    [btnSubmit setBackgroundImage:[Util imageWithColor:Abled_Color size:CGSizeMake(5, 5)] forState:UIControlStateNormal];
    [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    btnSubmit.clipsToBounds = YES;
    [btnSubmit addTarget:self action:@selector(doBtnSubmit:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(lbOldPwd, _tfOldPwd, lbPwd, _tfPwd, lbRePwd, _tfRePwd, btnSubmit, scrollview);
    
    NSString *format = [NSString stringWithFormat:@"H:|-0-[scrollview(%f)]-0-|", ScreenWidth];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scrollview]-0-|" options:0 metrics:nil views:views]];
    
    NSString *btnFormat = [NSString stringWithFormat:@"H:|-18-[btnSubmit(%f)]-18-|", ScreenWidth - 36];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:btnFormat options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[lbPwd]-10-[_tfPwd]-18-|" options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[lbRePwd]-10-[_tfRePwd]-18-|" options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[lbOldPwd]-10-[_tfOldPwd]-18-|" options:0 metrics:nil views:views]];
    
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[lbOldPwd(42)]-16-[lbPwd(42)]-16-[lbRePwd(42)]-30-[btnSubmit(42)]->=10-|" options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_tfOldPwd(42)]->=0-|" options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_tfPwd(42)]->=0-|" options:0 metrics:nil views:views]];
    [scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_tfRePwd(42)]->=0-|" options:0 metrics:nil views:views]];
    [scrollview addConstraint:[NSLayoutConstraint constraintWithItem:_tfOldPwd attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbOldPwd attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [scrollview addConstraint:[NSLayoutConstraint constraintWithItem:_tfPwd attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbPwd attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [scrollview addConstraint:[NSLayoutConstraint constraintWithItem:_tfRePwd attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lbRePwd attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void) doBtnSubmit:(UIButton *)sender
{
    NSString *pwd = [_tfOldPwd text];
    NSString *newpwd = [_tfPwd text];
    NSString *renewpwd = [_tfRePwd text];
    if([pwd length] < 5 || [pwd length] > 16){
        [Util showAlertMessage:@"旧密码是5-16位!"];
        return;
    }
    if([newpwd length] < 5 || [newpwd length] > 16){
        [Util showAlertMessage:@"新密码是5-16位!"];
        return;
    }
    if([renewpwd length] < 5 || [renewpwd length] > 16){
        [Util showAlertMessage:@"确认密码是5-16位!"];
        return;
    }
    if(![newpwd isEqualToString:renewpwd]){
        [Util showAlertMessage:@"确认密码不正确!"];
        return;
    }
    
    
    [[AVUser currentUser] updatePassword:pwd newPassword:newpwd block:^(id object, NSError *error) {
        if(error == nil){
            [Util showAlertMessage:@"密码更新成功!"];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [Util showAlertMessage:error.localizedDescription];
        }
    }];
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _tfOldPwd)
        [_tfPwd becomeFirstResponder];
    else if (textField == _tfPwd)
        [_tfRePwd becomeFirstResponder];
    else
        [self doBtnSubmit:nil];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
    
    if(type == EnumValueTypeiPhone4S){
        __weak ModifyPwdVC *weakSelf = self;
        
        if(textField == _tfOldPwd){
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.scrollview.contentOffset = CGPointMake(0, 0);
            }];
        }
        else if (textField == _tfPwd)
        {
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.scrollview.contentOffset = CGPointMake(0, 10);
            }];
        }
        else
        {
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.scrollview.contentOffset = CGPointMake(0, 60);
            }];
        }
    }
}

- (void) keyboardWillHide:(NSNotification *)notify
{
    __weak ModifyPwdVC *weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.scrollview.contentOffset = CGPointMake(0, 0);
    }];
}

@end
