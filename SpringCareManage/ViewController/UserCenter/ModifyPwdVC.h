//
//  ModifyPwdVC.h
//  SpringCareManage
//
//  Created by LiuZach on 15/5/14.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"

@interface ModifyPwdVC : LCBaseVC<UITextFieldDelegate>
{
    UITextField *_tfPwd;
    UITextField *_tfRePwd;
    UITextField *_tfOldPwd;
}
@property (nonatomic, strong)UIScrollView *scrollview;

@end
