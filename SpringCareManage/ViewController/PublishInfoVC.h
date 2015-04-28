//
//  PublishInfoVC.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "PlaceholderTextView.h"
#import "LCVoiceHud.h"
#import "PickImgScrollView.h"
#import "RecoderAndPlayer.h"
typedef enum : NSUInteger {
    EnumWorkSummary = 1,
    EnumEscortTime,
    EnumPublishContentTypeUnown,
} PublishContentType;

@interface PublishInfoVC : LCBaseVC
{
    UIView *_bgView;
    PlaceholderTextView *_tvContent;
    PickImgScrollView *imageScrollView;
    UIButton *_btnRecord;
    UIButton *_btnVoice;
    UIButton *_btnTargetSelect;
    UILabel *_line;
    LCVoiceHud  * _voiceHud;
    RecoderAndPlayer *_recoderAndPlayer;
    NSString * voiceName;
    NSData * voiceData ;
    NSInteger voiceSecconds;
    NSMutableString *fileString;
}

@property (nonatomic, assign) PublishContentType contentType;
@property (nonatomic, assign) NSString* loverId;

@end
