//
//  RecoderAndPlayer.m
//
//  Created by forrestlee 2015

//

#import "RecoderAndPlayer.h"
#include <stdio.h>
#import "define.h"
#import "VoiceConverter.h"

#define WAVE_UPDATE_FREQUENCY   0.05
@implementation RecoderAndPlayer

@synthesize recorder;
@synthesize player;
@synthesize delegate;
@synthesize aSeconds;

+ (id)sharedRecoderAndPlayer {
    static RecoderAndPlayer* recoderAndPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        recoderAndPlayer = [[RecoderAndPlayer alloc] init];
    });
    return recoderAndPlayer;
}

- (id)init {
    if (self = [super init]) {
        //存放目录
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:chat_VoiceCache_path]) {
            [fm createDirectoryAtPath:chat_VoiceCache_path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

//格式化录制文件名称

- (NSString*) generatFilename
{
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}

- (NSString*)getPathByFileName:(NSString *)_fileName ofType:(NSString *)_type
{
    NSString* fileDirectory = [[chat_VoiceCache_path stringByAppendingPathComponent:_fileName]stringByAppendingPathExtension:_type];
    return fileDirectory;
}

//录音
-(BOOL)record
{
	NSError *error;
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
	[settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
	[settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    recordName=[self generatFilename];
    self.recordWavPath = [self getPathByFileName:recordName ofType:@"wav"];
	self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:self.recordWavPath] settings:settings error:&error];
	if (!self.recorder)
	{
		return NO;
	}
	self.recorder.delegate = self;
	if (![self.recorder prepareToRecord])
	{
		return NO;
	}
    self.recorder.meteringEnabled = YES; //允许波形
 
    //开始录音
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
	if (![self.recorder record])
	{
		return NO;
	}
    [self LoudSpeakerRecorder:YES];
	return YES;
  }

//删除临时文件
- (void)removeTempfile:(NSString *)_filepath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:_filepath error:nil];
}




- (void) play
{
	if (self.player) [self.player play];
  
}


//录音计时
-(void)countTime{
    if (self.aSeconds>=SpeechMaxTime) {
        self.aSeconds = SpeechMaxTime;
       [self stopRecording];
    }else {
        aSeconds+= WAVE_UPDATE_FREQUENCY;
        /*  发送TimePromptAction代理来刷新平均和峰值功率。
         *  此计数是以对数刻度计量的，-160表示完全安静，
         *  0表示最大输入值
         */
        if (self.recorder) {
            [self.recorder updateMeters];
        }
        
        float peakPower = [self.recorder averagePowerForChannel:0];
        double ALPHA = 0.05;
        double peakPowerForChannel = pow(10, (ALPHA * peakPower));
        if ([delegate respondsToSelector:@selector(TimePromptAction:peakPower:)]) {
            [delegate TimePromptAction:self.aSeconds peakPower:peakPowerForChannel];
        }
    }
}

/**
 @Brief 开始录音
 **/
-(void)startRecording{
    if (player) {
        [player stop];
    }
    //录制
    isPlay = NO;
    self.aSeconds=0;
    [self record];
    timer = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(countTime) userInfo:nil repeats:YES];
}


/**
 @Brief 停止录音
 **/
-(void)stopRecording{
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
    self.recorder = nil;
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}


/**
 @Brief 播放录音
 **/
-(void)startPlaying:(NSString *)amrFile{
    if (player) {
        [player stop];
    }
   // NSData *amrData ;
    amrFile = [amrFile stringByDeletingPathExtension];
    self.recordAmrPath = [self getPathByFileName:amrFile ofType:@"amr"];
      NSLog(@"%@",self.recordAmrPath);
     NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath: self.recordAmrPath]) {
          self.recordWavPath = [self getPathByFileName:amrFile ofType:@"wav"];
         if (![fileManager fileExistsAtPath:  self.recordWavPath]) {
          [VoiceConverter amrToWav:self.recordAmrPath wavSavePath:self.recordWavPath];
           }
       [self LoudSpeakerPlay:YES];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.recordWavPath] error:nil];
        [player stop];
         player.delegate =self;
         player.meteringEnabled = YES;
        [player prepareToPlay];
        [player setVolume:1.0];
        [self performSelectorOnMainThread:@selector(play) withObject:nil waitUntilDone:NO];
    }
}

/**
 @Brief 停止播放
 **/
- (void)stopPlaying {
    if (player) {
        [player stop];
        player.delegate = nil;
    }
}

//打开扬声器--录音
-(bool) LoudSpeakerRecorder:(bool)bOpen
{
	//播放的时候设置play ，录音时候设置recorder
	
    UInt32 route;   
    UInt32 sessionCategory =  kAudioSessionCategory_PlayAndRecord; // 1
    
    AudioSessionSetProperty (
                                     kAudioSessionProperty_AudioCategory,                        // 2
                                     sizeof (sessionCategory),                                   // 3
                                     &sessionCategory                                            // 4
                                     );
    
    route = bOpen?kAudioSessionOverrideAudioRoute_Speaker:kAudioSessionOverrideAudioRoute_None;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
    return true;
}

//打开扬声器--播放
-(bool) LoudSpeakerPlay:(bool)bOpen
{
	//播放的时候设置play ，录音时候设置recorder
	
	//return false;
    UInt32 route;
    //OSStatus error;    
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;// kAudioSessionCategory_PlayAndRecord;//kAudioSessionCategory_RecordAudio;//kAudioSessionCategory_PlayAndRecord;    // 1
    
     AudioSessionSetProperty (
                                     kAudioSessionProperty_AudioCategory,                        // 2
                                     sizeof (sessionCategory),                                   // 3
                                     &sessionCategory                                            // 4
                                     );
    
    route = bOpen?kAudioSessionOverrideAudioRoute_Speaker:kAudioSessionOverrideAudioRoute_None;
     AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
    return true;
}


#pragma mark -
#pragma mark AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (self.aSeconds>=2) {
       // adata = [self encodeToAMR:adata voiceName:recordAmrName];
        self.recordAmrPath = [self getPathByFileName:recordName ofType:@"amr"];
        //音频转码
        [VoiceConverter wavToAmr:self.recordWavPath amrSavePath:self.recordAmrPath];
        NSData *adata = [NSData dataWithContentsOfFile:self.recordAmrPath];
          //删除临时wav文件
        //[self removeTempfile:self.recordWavPath];
        if ([delegate respondsToSelector:@selector(recordAndSendAudioFile:duration:fileName:)]) {
            [delegate recordAndSendAudioFile:adata duration:(int)self.aSeconds fileName:recordName];
        }
    }
  
   }

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    isPlay = NO;
    //播放完成回调
    if ([delegate respondsToSelector:@selector(playingFinishWithVoice:)]) {
        [delegate playingFinishWithVoice:YES];
    }
}

@end
