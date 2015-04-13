//
//  PublishInfoVC.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "PlaceholderTextView.h"

typedef enum : NSUInteger {
    EnumWorkSummary,
    EnumEscortTime,
} PublishContentType;

@interface PublishInfoVC : LCBaseVC
{
    UIView *_bgView;
    PlaceholderTextView *_tvContent;
    UIButton *_btnRecord;
    UIButton *_btnTargetSelect;
    UILabel *_line;
}

@property (nonatomic, assign) PublishContentType contentType;

@end
