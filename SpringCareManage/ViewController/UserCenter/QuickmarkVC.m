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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.image = ThemeImage(@"Quickmark");
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[imageView(260)]->=0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[imageView(260)]->=0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
    
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.ContentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-80]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
