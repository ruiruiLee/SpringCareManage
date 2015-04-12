//
//  LCNavigationbar.h
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCNavigationbarDelegate <NSObject>

- (void) NavLeftButtonClickEvent:(UIButton*)sender;
- (void) NavRightButtonClickEvent:(UIButton *)sender;

@end

@interface LCNavigationbar : UIView


@property (nonatomic, strong, readonly) UILabel *lbTitle;
@property (nonatomic, strong) UIButton *btnLeft;
@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, strong) NSString *Title;

@property (nonatomic, weak) id<LCNavigationbarDelegate> delegate;

- (void) HandleLeftButtonClickEvent:(UIButton*)sender;
- (void) HandleRightButtonClickEvent:(UIButton *)sender;

@end
