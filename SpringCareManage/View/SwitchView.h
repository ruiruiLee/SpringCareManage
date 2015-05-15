//
//  SwitchView.h
//  SpringCareManage
//
//  Created by LiuZach on 15/5/15.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EnumWorkStatusFree,
    EnumWorkStatusWorking,
    EnumWorkStatusHoliday,
} EnumWorkStatus;

@interface SwitchView : UIView
{
    UIButton *_btnLeft;
    UIButton *_btnRight;
    UILabel *_lbStatus;
}

- (void) SetCurrentWorkStatus:(EnumWorkStatus) status;

@end
