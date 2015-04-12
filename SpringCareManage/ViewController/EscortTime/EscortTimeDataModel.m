//
//  EscortTimeDataModel.m
//  Demo
//
//  Created by LiuZach on 15/3/30.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "EscortTimeDataModel.h"
#import "ObjImageDataInfo.h"

@implementation EscortTimeReplyDataModel
@synthesize publishName;
@synthesize publishContent;
@synthesize replyId;
@synthesize parser;
@synthesize height;

- (id) init
{
    self = [super init];
    if(self)
    {
        parser = [[MatchParser alloc] init];
        parser.textColor = _COLOR(0x66, 0x66, 0x66);
        parser.font = _FONT(14);
        
        replyId = @"1234";
        publishContent = @"豆腐，那是肯定就会感受到很多风格好汾河谷地法国和德国发挥地方";
        publishName = @"13628050827";
        
        [self ParserDataWithContent:publishContent width:Content_Width - 20];
    }
    return self;
}

- (void)ParserDataWithContent:(NSString*) str width:(float) width
{

    parser.keyWorkColor=[UIColor blueColor];
    parser.width = width;
//    parser.numberOfLimitLines = 5;
//    self.numberOfLineLimit = 5;
    
    [parser match:str atCallBack:^BOOL(NSString * string) {
        //        NSString *partInStr;
        //        if (![tMans isKindOfClass:[NSString class]]) {
        //            partInStr = [tMans JSONString];
        //        } else {
        //            partInStr = (NSString*)tMans;
        //        }
        NSLog(@"%@", string);
        return NO;
    }];
    height = parser.height;
}

@end

@implementation EscortTimeDataModel
@synthesize itemId;
@synthesize textContent;
@synthesize voiceContentUrl;
@synthesize voiceLen;
@synthesize publishTime;
@synthesize replyData;
@synthesize imgPicArray;
@synthesize isShut;
@synthesize parser = _parser;


+ (NSArray*) GetEscortTimeData
{
    static NSMutableArray *escortTimeData = nil;
    
    if (!escortTimeData)
    {
        escortTimeData = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 10; i++) {
            EscortTimeDataModel *data = [[EscortTimeDataModel alloc] init];
            [escortTimeData addObject:data];
        }
    }
    return escortTimeData;
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        _parser = [self createMatch];
        _parser.textColor = _COLOR(0x22, 0x22, 0x22);
        
        isShut = NO;
        
        itemId = @"11111";
        textContent = @"撒打个比方公司13608083606的风格的损公肥私的风格扶桑岛国个大是大非根深蒂固山东分公司对方感受到分公司的风格的沙发公司的分公司对方感受到分公司山东分公司对方感受到分公司的风格是豆腐干山东分公司对方感受到分公司的风格是豆腐干是豆腐干山东分公司对方感受到分公司的风格山东分公司对方感受到分公司的风格说受到各方山东分公司的风格";
        publishTime = @"11\"";
        
        publishTime = @"20140512";
        voiceContentUrl = @"http";
        
        NSMutableArray *_images = [NSMutableArray array];
        
        ObjImageDataInfo *info = [[ObjImageDataInfo alloc] init];
        info.urlPath = @"http://www.tattoo77.com/uploads/allimg/121217/1-12121G43453108.jpg";
        [_images addObject:info];
        
        
        ObjImageDataInfo *info1 = [[ObjImageDataInfo alloc] init];
        info1.urlPath = @"http://image.tianjimedia.com/uploadImages/2013/228/KT0X2XI3X9Z9.jpg";
        [_images addObject:info1];
        
        
        ObjImageDataInfo *info2 = [[ObjImageDataInfo alloc] init];
        info2.urlPath = @"http://img.photo.163.com/QNaHBfv9UpKOpSV5iT8ihQ==/2538622814953414148.jpg";
        [_images addObject:info2];
//
//        ObjImageDataInfo *info3 = [[ObjImageDataInfo alloc] init];
//        info3.urlPath = @"http://www.tattoo77.com/uploads/allimg/121217/1-12121G43453108.jpg";
//        [_images addObject:info3];
//         
//        ObjImageDataInfo *info4 = [[ObjImageDataInfo alloc] init];
//        info4.urlPath = @"http://www.tattoo77.com/uploads/allimg/121217/1-12121G43453108.jpg";
//        [_images addObject:info4];
//
//        ObjImageDataInfo *info5 = [[ObjImageDataInfo alloc] init];
//        info5.urlPath = @"http://www.tattoo77.com/uploads/allimg/121217/1-12121G43453108.jpg";
//        [_images addObject:info5];
//        
//        ObjImageDataInfo *info6 = [[ObjImageDataInfo alloc] init];
//        info6.urlPath = @"http://www.tattoo77.com/uploads/allimg/121217/1-12121G43453108.jpg";
//        [_images addObject:info6];
//
//        ObjImageDataInfo *info7 = [[ObjImageDataInfo alloc] init];
//        info7.urlPath = @"http://www.tattoo77.com/uploads/allimg/121217/1-12121G43453108.jpg";
//        [_images addObject:info7];
//        
//        ObjImageDataInfo *info8 = [[ObjImageDataInfo alloc] init];
//        info8.urlPath = @"http://www.tattoo77.com/uploads/allimg/121217/1-12121G43453108.jpg";
//        [_images addObject:info8];
//        
//        ObjImageDataInfo *info9 = [[ObjImageDataInfo alloc] init];
//        info9.urlPath = @"http://www.tattoo77.com/uploads/allimg/121217/1-12121G43453108.jpg";
//        [_images addObject:info9];
//        
//        ObjImageDataInfo *info10 = [[ObjImageDataInfo alloc] init];
//        info10.urlPath = @"http://www.tattoo77.com/uploads/allimg/121217/1-12121G43453108.jpg";
//        [_images addObject:info10];
        
        imgPicArray = _images;
        
        NSMutableArray *_reply = [[NSMutableArray alloc] init];
        
        for (int  i = 0; i < 10; i++) {
            EscortTimeReplyDataModel *model = [[EscortTimeReplyDataModel alloc] init];
            [_reply addObject:model];
        }
        
        replyData = _reply;
        
        [self ParserDataWithContent:textContent width:Content_Width];
    }
    return self;
}

-(MatchParser*)createMatch
{
    MatchParser * matchparser=[[MatchParser alloc] init];
    return matchparser;
}

- (void)ParserDataWithContent:(NSString*) str width:(float) width
{
    _parser.keyWorkColor=[UIColor blueColor];
    _parser.width = width;
    _parser.numberOfLimitLines = 5;
    self.numberOfLineLimit = 5;
    [_parser match:str atCallBack:^BOOL(NSString * string) {
//        NSString *partInStr;
//        if (![tMans isKindOfClass:[NSString class]]) {
//            partInStr = [tMans JSONString];
//        } else {
//            partInStr = (NSString*)tMans;
//        }
        NSLog(@"%@", string);
        return NO;
    }];
    self.numberOfLinesTotal = _parser.numberOfTotalLines;
}

@end
