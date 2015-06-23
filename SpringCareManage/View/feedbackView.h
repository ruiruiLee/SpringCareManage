//
//  feedbackViewController.h
//  EducationVersion
//
//  Created by forrestlee
//  Copyright (c) 2015年 share. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceBoardView.h"

@protocol feedbackViewDelegate;
@interface feedbackView:UIViewController <UITextFieldDelegate,FaceBoardViewDelegate>
{
    FaceBoardView  *_faceBoardView;
    BOOL faceshow;
    BOOL ControlHidden;
    BOOL addGesture;
    BOOL _hasReply;
    BOOL _hasShow;
    CGSize      _winSize;
    CGSize     _keyBoardSize;
    NSDictionary   *_plistDic;
    NSString* tempStr ;
    int navHeight;
    UITapGestureRecognizer *tapGesture;
    UIView * parentView;
    int offheight;
}

@property (strong, nonatomic) IBOutlet UIView *controlView;
@property (strong, nonatomic) IBOutlet UIView *ReplyView;
@property (strong, nonatomic) IBOutlet UIImageView *imgvReply;
@property (strong, nonatomic) IBOutlet UIButton *btnReply;
@property (strong, nonatomic) IBOutlet UILabel *lblReply;

@property (strong, nonatomic) IBOutlet UITextField *feedbackTextField;
@property (strong, nonatomic) IBOutlet UIButton *commitButton;

@property (assign, nonatomic) id<feedbackViewDelegate> delegate;

@property (nonatomic, assign) CGRect targetFrame;
@property (nonatomic, assign) int offset;

//@property (assign, nonatomic) BOOL hasReply;
-(void)finishOpration;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil controlHidden:(bool)hidden;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil controlHidden:(bool)hidden Reply:(bool)hasReply;
@end

@protocol feedbackViewDelegate <NSObject>

-(void)commitMessage:(NSString*)msg;   //按确认按钮或者发送按钮实现消息发送
-(void)tipAlertMsg:(NSString*)msg;

@optional
-(void)commentButtonPressed;
-(void)changeParentViewFram:(int)newHeight;

@end