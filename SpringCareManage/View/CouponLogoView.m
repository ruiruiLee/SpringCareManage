//
//  CouponLogoView.m
//  SpringCare
//
//  Created by LiuZach on 15/5/30.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "CouponLogoView.h"
#import "define.h"

@implementation CouponLogoView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _logoBgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_logoBgView];
        _logoBgView.translatesAutoresizingMaskIntoConstraints = NO;
        _logoBgView.clipsToBounds = NO;
        _logoBgView.image = ThemeImage(@"couponbg");
        
        _lbValue = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_lbValue];
        _lbValue.translatesAutoresizingMaskIntoConstraints = NO;
        _lbValue.textColor = _COLOR(0xf1, 0x15, 0x39);
        _lbValue.font = _FONT(12);
        _lbValue.textAlignment = NSTextAlignmentCenter;
        _lbValue.backgroundColor = [UIColor clearColor];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_logoBgView, _lbValue);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_logoBgView]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_logoBgView]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[_lbValue]-8-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_lbValue]-0-|" options:0 metrics:nil views:views]];
    }
    
    return self;
}

- (void) SetCouponValue:(NSInteger) value
{
    _lbValue.text = [NSString stringWithFormat:@"%d", value];
}

@end
