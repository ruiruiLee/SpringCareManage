//
//  PublishInfoVC.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "PublishInfoVC.h"
#import "define.h"
#define kMaxVoiceImageWidth 160.0
#define kMinVoiceImageWidth 40.0
@interface PublishInfoVC ()

@end

@implementation PublishInfoVC
@synthesize contentType;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        contentType = EnumPublishContentTypeUnown;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.NavigationBar.btnRight setImage:[UIImage imageNamed:@"submit"] forState:UIControlStateNormal];
    [self initSubviews];
     [_tvContent becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubviews
{
    _bgView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_bgView];
    _bgView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _tvContent = [[PlaceholderTextView alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_tvContent];
    _tvContent.translatesAutoresizingMaskIntoConstraints = NO;
    _tvContent.placeholder = @"写下你的记录......";
    
    _btnRecord = [[UIButton alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_btnRecord];
    _btnRecord.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnRecord setImage:[UIImage imageNamed:@"recording"] forState:UIControlStateNormal];
    //添加长按手势
    UILongPressGestureRecognizer *longPrees = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(recordBtnLongPressed:)];
    longPrees.delegate = (id)self;
    [_btnRecord addGestureRecognizer:longPrees];
    
    
    
    
    _btnTargetSelect = [[UIButton alloc] initWithFrame:CGRectZero];
     [_bgView addSubview:_btnTargetSelect];
    _btnTargetSelect.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnTargetSelect setTitle:@"同时发布到我的护理日志" forState:UIControlStateNormal];
    [_btnTargetSelect setImage:[UIImage imageNamed:@"paytypenoselect"] forState:UIControlStateNormal];
    [_btnTargetSelect setImage:[UIImage imageNamed:@"paytypeselected"] forState:UIControlStateSelected];
    [_btnTargetSelect addTarget:self action:@selector(doBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_btnTargetSelect setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    _btnTargetSelect.titleLabel.font = _FONT(15);
    
    _line = [[UILabel alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_line];
    _line.translatesAutoresizingMaskIntoConstraints = NO;
    _line.backgroundColor = SeparatorLineColor;
    
  imageScrollView = [[PickImgScrollView alloc]initWithFrame:CGRectMake(0.0f,
                                                                       CGRectGetHeight(_tvContent.frame),
                                                                       CGRectGetWidth(self.view.frame), 50)];
    [self.ContentView addSubview:imageScrollView];
    imageScrollView.parentController=self;
    imageScrollView.delegate=(id)self;
    imageScrollView.translatesAutoresizingMaskIntoConstraints = NO;
//
    NSDictionary *views = NSDictionaryOfVariableBindings(_bgView, _tvContent, _btnTargetSelect, _btnRecord, _line, imageScrollView);
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bgView]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bgView]-0-[imageScrollView]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageScrollView]-0-|" options:0 metrics:nil views:views]];
    
    
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_tvContent]-10-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_btnTargetSelect]->=10-[_btnRecord]-20-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_line]-0-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_tvContent(120)]-5-[_btnRecord]-10-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnTargetSelect attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_btnRecord attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    if(contentType == EnumWorkSummary)
        _btnTargetSelect.hidden = YES;
    else
        _btnTargetSelect.hidden = NO;
}

- (void) doBtnSelected:(UIButton*)sender
{
    sender.selected = !sender.selected;
}


/**
 @Brief 根据语音时间长度计算控件长度
 **/
- (CGFloat) VoiceButtonWithVoiceTimeLength:(float)timeLength {
    CGFloat ratioLegth = kMaxVoiceImageWidth * (timeLength / 30);
    return kMinVoiceImageWidth + ratioLegth;
}

#pragma mark - 长按录音
- (void)recordBtnLongPressed:(UILongPressGestureRecognizer*) longPressedRecognizer{
    //长按开始
    if(longPressedRecognizer.state == UIGestureRecognizerStateBegan) {
        [_tvContent resignFirstResponder];
        _recoderAndPlayer = [RecoderAndPlayer sharedRecoderAndPlayer];
        _recoderAndPlayer.delegate=(id)self;
        [_recoderAndPlayer startRecording];
        _voiceHud = [[LCVoiceHud alloc] init];
        [_voiceHud show];

        
    }//长按结束
    else if(longPressedRecognizer.state == UIGestureRecognizerStateEnded || longPressedRecognizer.state == UIGestureRecognizerStateCancelled){
         [_recoderAndPlayer stopRecording];
    }
}

- (void) VoicePlayClicked:(UIButton*)sender{
    [_recoderAndPlayer startPlaying:voiceName];
    
}

#pragma mark -
#pragma mark  RecoderAndPlayerDelegate

-(void)recordAndSendAudioFile:(NSData *)fileData duration:(int)timelength fileName:(NSString*)fileName{

    if ( timelength<2) {
        [_voiceHud setDisplaytext:@"说话时间太短"];
        [_voiceHud performSelector:@selector(hide) withObject:nil afterDelay:1.5f];
        return;
     }
     else if (timelength>=SpeechMaxTime) {
            [_voiceHud setDisplaytext:@"说话时间太长，最多2分钟"];
            [_voiceHud performSelector:@selector(hide) withObject:nil afterDelay:1.5f];
        }
     else{
            [_voiceHud hide];
        }
    //显示语音
    voiceName=fileName;
    _btnVoice = [[UIButton alloc] initWithFrame:CGRectZero];
    
    //_btnVoice.translatesAutoresizingMaskIntoConstraints = NO;
    [_bgView addSubview:_btnVoice];
    
    _btnVoice.frame = CGRectMake(0, 100,[self VoiceButtonWithVoiceTimeLength:timelength],
                                 20);
    _btnVoice.userInteractionEnabled=true;
    [_btnVoice setBackgroundImage:[[UIImage imageNamed:@"escorttimevolice"] stretchableImageWithLeftCapWidth:40 topCapHeight:5] forState:UIControlStateNormal];
    [_btnVoice addTarget:self action:@selector(VoicePlayClicked:) forControlEvents:UIControlEventTouchUpInside];


}

//录制中
-(void)TimePromptAction:(float)sencond peakPower:(double)peakPower {
    // NSLog(@"录音记时%f",sencond);
    if (_voiceHud)
    {
        [_voiceHud setDisplaytext:[NSString stringWithFormat:@"正在录音( %d\" )",(int)sencond]];
        [_voiceHud setProgress:peakPower];
    }
}

//播放完成回调
-(void)playingFinishWithVoice:(BOOL)isFinish {
    
}

#pragma mark -
#pragma mark PickImgEndDelegate
- (void) imagePickerControllerDissMethod{
    [_tvContent becomeFirstResponder];
}
//实现代理方法
//-(void)addPicker:(UIImagePickerController *)picker{
//    
//    [self presentViewController:picker animated:YES completion:nil];
//}

- (void) setContentType:(PublishContentType)type
{
    contentType = type;
    if(type == EnumEscortTime){
        _btnTargetSelect.hidden = NO;
    }
    else{
        _btnTargetSelect.hidden = YES;
    }
}

- (void) NavRightButtonClickEvent:(UIButton *)sender
{
    if(contentType == EnumEscortTime)
        [self PublishEscortTime];
    else
        [self PublishWorkSummary];
}

- (void)PublishEscortTime
{
    
}

- (void)PublishWorkSummary
{
    
}

@end
