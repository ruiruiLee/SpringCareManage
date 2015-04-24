//
//  LCBaseVC.h
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "define.h"
#import "LCNavigationbar.h"

@interface LCBaseVC : UIViewController<LCNavigationbarDelegate>

@property (nonatomic, strong) UIView *ContentView;
@property (nonatomic, strong) LCNavigationbar *NavigationBar;

//监控键盘事件
- (void) keyboardWillShow:(NSNotification *) notify;

- (void) keyboardWillHide:(NSNotification *)notify;

@end
