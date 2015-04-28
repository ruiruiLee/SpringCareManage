//
//  LCVoiceHud.h
//  LCVoiceHud
// 语音说话音频振动提示图
//  modify by forrestlee
//  Copyright (c) 2013年 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCVoiceHud : UIView

@property(nonatomic) float progress;
@property(nonatomic,copy) NSString *displaytext;
-(void) show;
-(void) hide;

@end
