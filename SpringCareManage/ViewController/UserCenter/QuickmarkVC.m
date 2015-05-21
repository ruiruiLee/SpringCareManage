//
//  QuickmarkVC.m
//  SpringCare
//
//  Created by LiuZach on 15/5/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "QuickmarkVC.h"

@interface QuickmarkVC ()

@end

@implementation QuickmarkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.NavigationBar.Title = @"扫描下载";
    
    UILabel *lbExplain = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:lbExplain];
    lbExplain.translatesAutoresizingMaskIntoConstraints = NO;
    lbExplain.font = _FONT(15);
    lbExplain.textColor = _COLOR(0x99, 0x99, 0x99);
    lbExplain.backgroundColor = [UIColor clearColor];
    lbExplain.text = @"扫描安装 春风陪护 用户版app";
    lbExplain.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.image = ThemeImage(@"Quickmark");
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[imageView(260)]->=0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView, lbExplain)]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[lbExplain(260)]->=0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView, lbExplain)]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[lbExplain]-10-[imageView(260)]->=0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView, lbExplain)]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:lbExplain attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
//    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-80]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
