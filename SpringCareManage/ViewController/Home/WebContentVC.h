//
//  WebContentVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"

@interface WebContentVC : LCBaseVC
{
    UIWebView *_webview;
    
    NSString *urlPath;
    NSString *titleString;
}

- (id) initWithTitle:(NSString*)title url:(NSString*)url;

- (void) loadInfoFromUrl:(NSString*) url;

@end
