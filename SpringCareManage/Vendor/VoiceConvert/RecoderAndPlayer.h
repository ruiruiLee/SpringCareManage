//
//  RecoderAndPlayer.h
//  shareApp
//
//  Created by share02 on 12-9-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>


@protocol RecoderAndPlayerDelegate <NSObject>

@optional
//录制的音频文件包，时长
-(void)recordAndSendAudioFile:(NSData *)fileData duration:(int)timelength fileName:(NSString*)fileName;
//计时更新
-(void)TimePromptAction:(float)sencond peakPower:(double)peakPower;

//播放完成回调
-(void)playingFinishWithVoice:(BOOL)isFinish;

@end

@interface RecoderAndPlayer : NSObject <
AVAudioRecorderDelegate,
AVAudioPlayerDelegate>
{
	NSTimer *timer;
    BOOL isPlay;
    NSString *recordName;
}

@property (retain,nonatomic) AVAudioRecorder *recorder;
@property (retain,nonatomic) AVAudioPlayer *player;
@property (retain,nonatomic) NSString *recordWavPath;
@property (retain,nonatomic) NSString *recordAmrPath;
@property (assign,nonatomic) id <RecoderAndPlayerDelegate> delegate;
@property (assign,nonatomic) float aSeconds;

+ (id)sharedRecoderAndPlayer;

//开始录音
-(void)startRecording;

//停止录音
-(void)stopRecording;

//开始播放
-(void)startPlaying:(NSString *)amrFile;

//停止播放
- (void)stopPlaying;
@end
