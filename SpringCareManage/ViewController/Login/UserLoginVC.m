//
//  UserLoginVC.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserLoginVC.h"
#import "define.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UserModel.h"

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

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [_tfPhoneNum resignFirstResponder];
    [_tfPwd resignFirstResponder];
    [_btnSubmit resignFirstResponder];
}

- (void) HandleTapGestureRecognizer
{
    [_tfPhoneNum resignFirstResponder];
    [_tfPwd resignFirstResponder];
    [_btnSubmit resignFirstResponder];
}

- (void) initSubviews
{
    UITapGestureRecognizer * tapOnce=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HandleTapGestureRecognizer)];
    tapOnce.numberOfTapsRequired=1;
    tapOnce.numberOfTouchesRequired=1;
    
    [self.ContentView addGestureRecognizer:tapOnce];
    
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_scrollview];
    _scrollview.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollview addGestureRecognizer:tapOnce];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectZero];
    [_scrollview addSubview:line];
    line.backgroundColor = _COLOR(225, 225, 225);
    line.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    [_scrollview addSubview:title];
    title.font = _FONT(18);
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = _COLOR(0x66, 0x66, 0x66);
    title.text = @"春风陪护，陪护师";
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.backgroundColor = [UIColor whiteColor];
    
    _tfPhoneNum = [[UITextField alloc] initWithFrame:CGRectZero];
    [_scrollview addSubview:_tfPhoneNum];
    _tfPhoneNum.translatesAutoresizingMaskIntoConstraints = NO;
    _tfPhoneNum.placeholder = @"手机号";
    _tfPhoneNum.font = _FONT(16);
    _tfPhoneNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
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
    _tfPwd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _tfPwd.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 0)];
    _tfPwd.leftViewMode = UITextFieldViewModeAlways;
    _tfPwd.layer.cornerRadius = 5;
    _tfPwd.layer.borderWidth = 1;
    _tfPwd.layer.borderColor = _COLOR(0x99, 0x99, 0x99).CGColor;
    _tfPwd.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _tfPwd.textColor = _COLOR(0x22, 0x22, 0x22);
    _tfPwd.secureTextEntry = YES;
    
    _btnSubmit = [[UIButton alloc] initWithFrame:CGRectZero];
    [_scrollview addSubview:_btnSubmit];
    _btnSubmit.translatesAutoresizingMaskIntoConstraints = NO;
//    _btnSubmit.backgroundColor = Abled_Color;
    [_btnSubmit setBackgroundImage:[Util imageWithColor:Abled_Color size:CGSizeMake(5, 5)] forState:UIControlStateNormal];
    _btnSubmit.layer.cornerRadius = 5;
    _btnSubmit.clipsToBounds = YES;
    [_btnSubmit setTitle:@"登录" forState:UIControlStateNormal];
    [_btnSubmit addTarget:self action:@selector(ActionToLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tfPwd, _tfPhoneNum, _btnSubmit, _scrollview, line, title);
    
    NSString *lineHFormat = [NSString stringWithFormat:@"H:|-0-[line(%f)]-0-|", ScreenWidth];
    [_scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lineHFormat options:0 metrics:nil views:views]];
    [_scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-52-[line(0.8)]->=10-|" options:0 metrics:nil views:views]];
    
    [_scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[title(200)]->=0-|" options:0 metrics:nil views:views]];
    [_scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[title(20)]->=0-|" options:0 metrics:nil views:views]];
    [_scrollview addConstraint:[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:line attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [_scrollview addConstraint:[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:line attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    NSString *format = [NSString stringWithFormat:@"H:|-20-[_tfPhoneNum(%f)]-20-|", ScreenWidth - 40];
    [_scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
    [_scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_tfPwd]-20-|" options:0 metrics:nil views:views]];
    [_scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_btnSubmit]-20-|" options:0 metrics:nil views:views]];
    [_scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[title(20)]-37-[_tfPhoneNum(40)]-20-[_tfPwd(40)]-20-[_btnSubmit(40)]->=0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_scrollview]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_scrollview]-0-|" options:0 metrics:nil views:views]];
    
    UIImageView *_imgLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_imgLogo];
    _imgLogo.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage *image = [UIImage imageNamed:@"aboutUsLogo@2x.jpeg"];
    _imgLogo.image = image;
    
    UIButton *_btnHotLine = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_btnHotLine];
    _btnHotLine.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnHotLine setTitleColor:_COLOR(70, 160, 132) forState:UIControlStateNormal];
    _btnHotLine.titleLabel.font = _FONT(16);
//    _btnHotLine.imageEdgeInsets = UIEdgeInsetsMake(4, 0, 6, 0);
    [_btnHotLine setImage:[UIImage imageNamed:@"logotel"] forState:UIControlStateNormal];
    [_btnHotLine setTitle:@"400-626-8787" forState:UIControlStateNormal];
    [_btnHotLine addTarget:self action:@selector(btnRingClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:view1];
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:view2];
    view2.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSDictionary *footViews = NSDictionaryOfVariableBindings(_imgLogo, _btnHotLine, view1, view2);
    

    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_imgLogo(35)]-40-|" options:0 metrics:nil views:footViews]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnHotLine(32)]-40-|" options:0 metrics:nil views:footViews]];
    NSString *footFormat = [NSString stringWithFormat:@"H:|-0-[view1]-0-[_imgLogo(93)]-10-[_btnHotLine]-0-[view2]-0-|"];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:footFormat options:0 metrics:nil views:footViews]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnHotLine attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_imgLogo attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
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
    
    __weak UserLoginVC *weakSelf = self;
    [AVUser logInWithMobilePhoneNumberInBackground:userName password:pwd block:^(AVUser *user, NSError *error) {
        if(error == nil){
           [[UserModel sharedUserInfo] modifyInfo];
            AVInstallation *currentInstallation = [AVInstallation currentInstallation];
            UserModel *user = [UserModel sharedUserInfo];
            [currentInstallation addUniqueObject:@"careUser" forKey:@"channels"];
            if(user.careType != nil)
                [currentInstallation addUniqueObject:user.careType forKey:@"channels"];
            [currentInstallation addUniqueObject:[UserModel sharedUserInfo].userId forKey:@"channels"];
            [currentInstallation saveInBackground];
            if(user.userStatus)
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            else{
                [Util showAlertMessage:@"该账户被禁用，请与管理员联系"];
                [weakSelf RestTextField];
            }
        }
        else{
            
            long code = [[error.userInfo objectForKey:@"code"] longValue];
            if(code == 210){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"密码输入错误！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else if (code == 211){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"账户手机号错误！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else{
            
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络错误，请稍候在试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }];
}

- (void)RestTextField
{
    _tfPhoneNum.text = @"";
    _tfPwd.text = @"";
}

- (void)btnRingClicked{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您确定要拨打电话吗?" message:@"4006268787" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView setTag:12];
    [alertView show];
}

#pragma alertdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 12) {
        if (buttonIndex==0) {
            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"4006268787"]];
            [[UIApplication sharedApplication] openURL:phoneURL];
        }
    }
}

//键盘监控事件
- (void) keyboardWillShow:(NSNotification *) notify
{
    EnDeviceType type = [NSStrUtil GetCurrentDeviceType];
    if(type == EnumValueTypeiPhone4S){
        [UIView animateWithDuration:0.25 animations:^{
            _scrollview.contentOffset = CGPointMake(0, 74);
        }];
    }
    else if (type == EnumValueTypeiPhone5){
        [UIView animateWithDuration:0.25 animations:^{
            _scrollview.contentOffset = CGPointMake(0, 22);
        }];
    }
}

- (void) keyboardWillHide:(NSNotification *)notify
{
    [UIView animateWithDuration:0.25 animations:^{
        _scrollview.contentOffset = CGPointMake(0, 0);
    }];
}

@end
