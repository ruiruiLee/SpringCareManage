//
//  PublishInfoVC.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "PlaceholderTextView.h"
//#import "MessagePhotoView.h"
#import "PickImgScrollView.h"
#import "LCVoiceHud.h"
#import "RecoderAndPlayer.h"
typedef enum : NSUInteger {
    EnumWorkSummary,
    EnumEscortTime,
} PublishContentType;

@interface PublishInfoVC : LCBaseVC <RecoderAndPlayerDelegate> //<MessagePhotoViewDelegate>
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
}

//@property (nonatomic,strong) MessagePhotoView *photoView;

@property (nonatomic, assign) PublishContentType contentType;

@end
