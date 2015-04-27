//
//  UserLoginVC.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"

@interface UserLoginVC : LCBaseVC
{
    UIScrollView *_scrollview;
    UITextField *_tfPhoneNum;
    UITextField *_tfPwd;
    UIButton *_btnSubmit;
}

@end
