//
//  WebContentVC.m
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "WebContentVC.h"

@interface WebContentVC ()

@end

@implementation WebContentVC

- (id) initWithTitle:(NSString*)title url:(NSString*)url
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        titleString = title;
        urlPath = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.NavigationBar.Title = titleString;
    
    _webview = [[UIWebView alloc] initWithFrame:CGRectZero];
    _webview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.ContentView addSubview:_webview];
    
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_webview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webview)]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_webview]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webview)]];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(urlPath != nil){
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlPath]];
        [_webview loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadInfoFromUrl:(NSString*) url
{
    urlPath = url;
    if(urlPath != nil){
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlPath]];
        [_webview loadRequest:request];
    }
}

@end
