//
//  SwitchView.m
//  SpringCareManage
//
//  Created by LiuZach on 15/5/15.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "SwitchView.h"
#import "define.h"
#import "UserModel.h"

@implementation SwitchView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.cornerRadius = 18;
        self.layer.borderWidth = 1;
        self.layer.borderColor = _COLOR(0xdd, 0xdd, 0xdd).CGColor;
        self.clipsToBounds = YES;
        
        [self initSubviews];
    }
    
    return self;
}

- (void) initSubviews
{
    UIImage *imageNormal = [Util imageWithColor:[UIColor clearColor] size:CGSizeMake(5, 5)];
    UIImage *imageSelect = [Util imageWithColor:Abled_Color size:CGSizeMake(5, 5)];
    
    _btnLeft = [[UIButton alloc] initWithFrame:CGRectZero];
    [self addSubview:_btnLeft];
    _btnLeft.translatesAutoresizingMaskIntoConstraints = YES;
    _btnLeft.titleLabel.font = _FONT(16);
    [_btnLeft setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [_btnLeft setBackgroundImage:imageSelect forState:UIControlStateSelected];
    [_btnLeft addTarget:self action:@selector(doBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_btnLeft setTitle:@"空闲" forState:UIControlStateNormal];
    [_btnLeft setTitleColor:_COLOR(0x66, 0x66, 0x66) forState:UIControlStateNormal];
    
    _btnRight = [[UIButton alloc] initWithFrame:CGRectZero];
    [self addSubview:_btnRight];
    _btnRight.translatesAutoresizingMaskIntoConstraints = YES;
    _btnRight.titleLabel.font = _FONT(16);
    [_btnRight setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [_btnRight setBackgroundImage:imageSelect forState:UIControlStateSelected];
    [_btnRight addTarget:self action:@selector(doBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_btnRight setTitle:@"休假" forState:UIControlStateNormal];
    [_btnRight setTitleColor:_COLOR(0x66, 0x66, 0x66) forState:UIControlStateNormal];
    
    _lbStatus = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_lbStatus];
    _lbStatus.textColor = _COLOR(0x66, 0x66, 0x66);
    _lbStatus.font = _FONT(16);
    _lbStatus.backgroundColor = [UIColor clearColor];
    _lbStatus.text = @"工作中";
    _lbStatus.translatesAutoresizingMaskIntoConstraints = NO;
    _lbStatus.textAlignment = NSTextAlignmentCenter;
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_btnLeft, _btnRight, _lbStatus);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_btnLeft]-0-[_btnRight]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_btnLeft]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_btnRight]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_lbStatus]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_lbStatus]-0-|" options:0 metrics:nil views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_btnLeft attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_btnRight attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
}

- (void) awakeFromNib
{
    
}

- (void) doBtnSelected:(UIButton *)sender
{
    if(sender.selected == YES)
        return;
    _btnLeft.selected = NO;
    _btnRight.selected = NO;
    
    sender.selected = YES;
    
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setObject:[UserModel sharedUserInfo].userId forKey:@"careId"];
    if(sender == _btnLeft)
        [parmas setObject:@"0" forKey:@"workStatus"];//空闲
    else
        [parmas setObject:@"2" forKey:@"workStatus"];//休假
    
    [LCNetWorkBase postWithMethod:@"api/care/setStatus" Params:parmas Completion:^(int code, id content) {
        if(code){
            if([content objectForKey:@"code"] == nil){
                
            }else{
                _btnLeft.selected = YES;
                _btnRight.selected = YES;
                sender.selected = NO;
                [Util showAlertMessage:[content objectForKey:@"msg"]];
            }
        }
    }];
}

- (void) SetCurrentWorkStatus:(EnumWorkStatus) status
{
    if(status == EnumWorkStatusFree){
        _lbStatus.hidden = YES;
        _btnLeft.hidden = NO;
        _btnRight.hidden = NO;
    }
    else if (status == EnumWorkStatusHoliday){
        _lbStatus.hidden = YES;
        _btnLeft.hidden = NO;
        _btnRight.hidden = NO;
    }
    else{
        _lbStatus.hidden = NO;
        _btnLeft.hidden = YES;
        _btnRight.hidden = YES;
    }
}

@end
