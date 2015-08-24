//
//  CouponLogoView.h
//  SpringCare
//
//  Created by LiuZach on 15/5/30.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponLogoView : UIView
{
    UIImageView *_logoBgView;
    UILabel *_lbValue;
}

- (void) SetCouponValue:(NSInteger) value;

@end
