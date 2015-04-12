//
//  EscortTimeDataModel.h
//  Demo
//
//  Created by LiuZach on 15/3/30.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatchParser.h"
#import "define.h"

@interface EscortTimeReplyDataModel : NSObject

@property (nonatomic, strong) NSString *publishName;
@property (nonatomic, strong) NSString *publishContent;
@property (nonatomic, strong) NSString *replyId;
@property (nonatomic, strong) MatchParser *parser;
@property (nonatomic, assign) float height;


@end

@interface EscortTimeDataModel : NSObject
{
    MatchParser *_parser;
}

@property (nonatomic, strong) MatchParser *parser;
@property (nonatomic, strong) NSString *itemId;//陪护时光id
@property (nonatomic, strong) NSString *textContent;//文字内容
@property (nonatomic, strong) NSString *voiceContentUrl;//音频内容地址
@property (nonatomic, strong) NSString *voiceLen;//音频时长
@property (nonatomic, strong) NSString *publishTime;//发布时间
@property (nonatomic, strong) NSArray *replyData;//回复数据
@property (nonatomic, strong) NSArray *imgPicArray;//图片数据列表

@property (nonatomic, assign) NSInteger numberOfLineLimit;
@property (nonatomic, assign) NSInteger numberOfLinesTotal;
@property (nonatomic, assign) BOOL isShut;//是否展开， 0未展开； 1展开

+ (NSArray*) GetEscortTimeData;

@end
