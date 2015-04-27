//
//  feedbackViewController.m
//  EducationVersion
//
//  Created by forrestlee
//  Copyright (c) 2015年 share. All rights reserved.
//

#import "feedbackView.h"
#import "define.h"
#define extendedLen 50
#define contentHeight 50
@implementation feedbackView


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil controlHidden:(bool)hidden Reply:(bool)hasReply{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        faceshow =NO;
        _hasReply =hasReply;
        ControlHidden =hidden; // yes，父控件点击可以隐藏
        _winSize=[UIScreen mainScreen].bounds.size;
        navHeight=44 ;
        _plistDic =[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                               pathForResource:@"faceMap_ch"
                                                               ofType:@"plist"]];
        
       self.view.frame =CGRectMake(0, _winSize.height, _winSize.width, _keyBoardSize.height+contentHeight);

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyBoardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil controlHidden:(bool)hidden
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        faceshow =NO;
        ControlHidden =hidden; //点击父控件隐藏输入表情框
        _winSize=[UIScreen mainScreen].applicationFrame.size;
        navHeight=44 ;
        _plistDic =[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                               pathForResource:@"faceMap_ch"
                                                               ofType:@"plist"]];
       self.view.frame =CGRectMake(0,_winSize.height, _winSize.width, _keyBoardSize.height+contentHeight);
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyBoardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];

    }
        return self;
}


- (void)viewDidLoad
{
    self.feedbackTextField.text = @"";
    self.feedbackTextField.delegate=self;
   // self.controlView.frame =CGRectMake(0, 0, _winSize.width, 50);
     [self.controlView setBackgroundColor:RGBwithHex(0xeeeff4)];
   // [self.controlView setBackgroundColor:[UIColor redColor]];

     [self.commitButton setImage:ThemeImage(@"chat_smailbtn") forState:UIControlStateNormal];
    if (_hasReply) {  //拥有回复操作
        self.ReplyView.hidden=NO;
        [self.lblReply setTextColor:RGBwithHex(0x868686)];
        [self.imgvReply setImage:ThemeImage(@"chat_replybtn")];

    }
    else{
        self.ReplyView.hidden=YES;
    }
        [self.view endEditing:YES];
}


// 回复按钮触发
- (IBAction)ReplyButtonPressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(commentButtonPressed)]) {
        [_delegate commentButtonPressed];
    }
}

//切换键盘或者表情
- (IBAction)commitButtonPressed:(id)sender {
     faceshow =!faceshow;
    if (faceshow) {   // 变成显示表情
        [self.commitButton setImage:ThemeImage(@"chat_keyboard") forState:UIControlStateNormal];
        [self.feedbackTextField resignFirstResponder];
        if (_faceBoardView == nil) {
            _faceBoardView = [[FaceBoardView alloc] initWithFrame:CGRectMake(0,contentHeight,_keyBoardSize.width,_keyBoardSize.height-contentHeight)];
            _faceBoardView.delegate = self;

        [self.view addSubview:_faceBoardView];
        }
         [UIView animateWithDuration:0.25f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
    
         // 要减去tabbar的高度
         int pheight =_winSize.height-navHeight-_faceBoardView.frame.size.height+20-55;
         self.view.frame = CGRectMake(0,pheight,self.view.frame.size.width,_faceBoardView.frame.size.height+contentHeight);
             } completion:^(BOOL finished) {
               // self.myTableView.userInteractionEnabled = NO;
            }];
    }
    else{  //键盘
        [self.commitButton setImage:ThemeImage(@"chat_smailbtn") forState:UIControlStateNormal];
        [self.feedbackTextField becomeFirstResponder];
      //  [_faceBoardView removeFromSuperview];
         //NSLog(@"%f",self.view.frame.origin.y);238
    }
    if (!addGesture &&!ControlHidden) {
        //添加父亲view手势 ，如果父亲是tableview添加后将会掩盖didselectrow事件 ,这种千万不能加
        [self addSuperViewClickGesture];
    }
}

//键盘展开
- (void)keyboardWillShow:(NSNotification*)notification {
    if (!addGesture &&!ControlHidden) {
        //添加父亲view手势 ，如果父亲是tableview添加后将会掩盖didselectrow事件 ,这种千万不能加
        [self addSuperViewClickGesture];
    }
    NSDictionary *info = [notification userInfo];
   _keyBoardSize =[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
   // NSLog(@"%f",_keyBoardSize.height);
    [UIView animateWithDuration:0.2 animations:^{
        //父view变化
           offheight =_winSize.height-navHeight-_keyBoardSize.height+20;
        
        if ([_delegate respondsToSelector:@selector(changeParentViewFram:)]&&!_hasShow) {
            [_delegate changeParentViewFram:offheight];
        }
       self.view.frame=CGRectMake(0,offheight,self.view.frame.size.width,_keyBoardSize.height+contentHeight);
       _hasShow=YES;
        } completion:nil];

}
//键盘隐藏
- (void)keyBoardWillHide:(NSNotification*)notification {
    if (!faceshow) {
    [self.commitButton setImage:ThemeImage(@"chat_smailbtn") forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        [self.feedbackTextField resignFirstResponder];
        if ([_delegate respondsToSelector:@selector(changeParentViewFram:)]&&!_hasShow) {
            [_delegate changeParentViewFram:-offheight];
        }
        self.view.frame=CGRectMake(0,_winSize.height,self.view.frame.size.width,self.view.frame.size.height);    } completion:nil];
 }
}

-(void)addSuperViewClickGesture{
    if (tapGesture==nil) {
        tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(finishOpration)];
        tapGesture.numberOfTapsRequired=1;
    }
   
    //    NSLog(@"%@",[self.view.superview class]);
    if (parentView==nil) {
        for (id  subView in self.view.superview.subviews){
            if ([subView isKindOfClass:[UITableView class]]) {
                parentView = subView;
                break;
            }
        }

    }
     [parentView addGestureRecognizer:tapGesture];
    addGesture=YES;
}


//还原成原始坐标位置
-(void)finishOpration
{
    if (!self) {
        return;
    }
    if (addGesture) {
        [parentView removeGestureRecognizer:tapGesture];
        addGesture=NO;
    }
    _hasShow=NO;
    if (faceshow) {  //显示的是表情
        faceshow=NO;
        [self.commitButton setImage:ThemeImage(@"chat_smailbtn") forState:UIControlStateNormal];
        // int pheight =self.view.frame.size.height-55;
        // offheight =_winSize.height-navHeight-_faceBoardView.frame.size.height+20-55;
        if ([_delegate respondsToSelector:@selector(changeParentViewFram:)]) {
            [_delegate changeParentViewFram:-offheight];
        }
        [UIView animateWithDuration:0.2 animations:^{
          
        self.view.frame=CGRectMake(0,_winSize.height,self.view.frame.size.width,self.view.frame.size.height);
          } completion:nil];
        
     }
    else{
         [self.feedbackTextField resignFirstResponder];
    }
    

    
}

#pragma mark - text的代理事件
#pragma mark UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [self sendButtonPressed];
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark FaceBoardViewDelegate
- (void)didTouchEmojiView:(FaceBoardView *)faceBoardView touchedEmoji:(NSDictionary *)emojiDic {
    if (_feedbackTextField.text == nil ) {
        _feedbackTextField.text = [NSString stringWithFormat:@"%@",[emojiDic allValues][0]];
    }else
        _feedbackTextField.text = [NSString stringWithFormat:@"%@%@",_feedbackTextField.text,[emojiDic allValues][0]];
}

- (void)deleteButtonPressed {
    NSString *inputString = _feedbackTextField.text;
    NSString *string = nil;
    NSInteger stringLength = inputString.length;
    NSString *emojiString = nil;
    if (stringLength > 0) {
        if ([@"]" isEqualToString:[inputString substringFromIndex:stringLength - 1]]) {
            if ([inputString rangeOfString:@"["].location == NSNotFound) {
                string = [inputString substringToIndex:stringLength - 1];
            }else {
                emojiString = [inputString substringFromIndex:[inputString rangeOfString:@"[" options:NSBackwardsSearch].location];
                if ([[_plistDic allValues] containsObject:emojiString]) {
                    string = [inputString substringToIndex:[inputString rangeOfString:@"[" options:NSBackwardsSearch].location];
                }else {
                    string = [inputString substringToIndex:stringLength - 1];
                }
            }
        }else {
            string = [inputString substringToIndex:stringLength - 1];
        }
    }
    _feedbackTextField.text = string;
}

//处理表情转换方法
- (NSString*)dealWithContentString:(NSString*)string startIndex:(int)startIndex{
    NSMutableString *resultString = [NSMutableString string];
    NSMutableString *emojiStr = [NSMutableString string];
    NSUInteger stringLength = string.length;
    
    for (int i = startIndex; i < stringLength; i ++) {
        NSString *curStr = [string substringWithRange:NSMakeRange(i, 1)];
        if ([curStr isEqualToString:@"["] || (![emojiStr isEqualToString:@""] && ![curStr isEqualToString:@"]"])) {
            [emojiStr appendString:curStr];
            continue;
        }else if ([curStr isEqualToString:@"]"]) {
            [emojiStr appendString:curStr];
            if ([_plistDic allKeysForObject:emojiStr].count) {
                [resultString appendString:[_plistDic allKeysForObject:emojiStr][0]];
            }else
                [resultString appendString:emojiStr];
            
            emojiStr.string = @"";
        }else {
            [resultString appendString:curStr];
        }
    }
    
    if (![emojiStr isEqualToString:@""]) {
        [resultString appendString:emojiStr];
    }
    return resultString;
}

- (void)sendButtonPressed {
    tempStr = [_feedbackTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([tempStr isEqualToString:@""]) {
          [self finishOpration];
         //[self.delegate tipAlertMsg:@"不能发送空白消息"];
        return;
    }
    else{
        //发送消息
        [self.delegate commitMessage:[self dealWithContentString:_feedbackTextField.text startIndex:0 ]];
         _feedbackTextField.text=@"";
        [self.view endEditing:YES];
        [self finishOpration];

    }
}


- (void)didReceiveMemoryWarning
{
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
  [self finishOpration];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];

}

@end
