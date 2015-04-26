//
//  FaceBoardView.h
//  EducationVersion
//
//  Created by wuhuping on 13-9-9.
//  Copyright (c) 2013年 share. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaceBoardViewDelegate;
@interface FaceBoardView : UIView

@property (assign, nonatomic) id<FaceBoardViewDelegate> delegate;

@end

@protocol FaceBoardViewDelegate <NSObject>
@optional
- (void)didTouchEmojiView:(FaceBoardView*)faceBoardView touchedEmoji:(NSDictionary*)emojiDic;
- (void)deleteButtonPressed;
- (void)sendButtonPressed;
@end
