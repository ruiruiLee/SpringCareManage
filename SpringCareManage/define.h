//
//  define.h
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#ifndef LovelyCare_define_h
#define LovelyCare_define_h

#import "LCNetWorkBase.h"
#import "NSStrUtil.h"
#import "Util.h"

#define LCNetWorkBase [LCNetWorkBase sharedLCNetWorkBase]
#define Notify_Resign_First_Responder @"Notify_Resign_First_Responder"
#define Notify_Lover_Moditify @"Notify_Lover_Moditify"


#define User_DetailInfo_Get @"User_DetailInfo_Get"

#define Service_Methord @"buspromotion/detailInfo/"

#define LcationInstance [LocationManagerObserver sharedInstance]


#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ThemeImage(imageName)  [UIImage imageNamed:imageName]
#define _COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define _COLORa(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define _FONT(s) [UIFont fontWithName:@"Helvetica Neue" size:(s)]
#define _FONT_B(s) [UIFont boldSystemFontOfSize:(s)]

#define _IPHONE_OS_VERSION_UNDER_7_0 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)

#define Nav_Title_Color [UIColor WhiteColor]

//陪护时光中用来确定内容的长度
#define Content_Width [UIScreen mainScreen].bounds.size.width - 120

//
#define Disabled_Color  _COLOR(0x8f, 0x8f, 0x97)
#define Abled_Color  [UIColor colorWithRed:(0x27)/255.0 green:(0xa6)/255.0 blue:(0x69)/255.0 alpha:1]

#define ThemeImage(imageName)  [UIImage imageNamed:imageName]

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define Place_Holder_Image  nil

#define Photo_Place_Holder_Image  nil

#define SeparatorLineColor  _COLOR(0xd7, 0xd7, 0xd7)
#define TableBackGroundColor _COLOR(0xf8, 0xf8, 0xf8)
#define TableSectionBackgroundColor _COLOR(0xf3, 0xf5, 0xf7)

#define TIME_LIMIT 5
#define LIMIT_COUNT 1
#define numberOfLineLimit 5

typedef void(^block)(int code, id content);

#define RGBwithHex(hex) _COLOR(((float)((hex & 0xFF0000) >> 16)),((float)((hex & 0xFF00) >> 8)),((float)(hex & 0xFF)))

//语音存放地址
#define SpeechMaxTime 120.0f
// 订单列表页面没有数据的时候 加载的图片
#define orderBackbroundImg ThemeImage(@"orderend")
// 陪护时光无数据时加载的页面。
#define TimeBackbroundImg ThemeImage(@"img_index_03bg")

#define chat_VoiceCache_path [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VoiceCache"]

#define chat_VoiceCache_file(_fileName) [[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VoiceCache"] stringByAppendingPathComponent:_fileName]

//首页海报图片压缩比例大小
#define imgCoverSize CGSizeMake(750, 508)
#define imgHeaderSize CGSizeMake(200, 200)

//应用里头像处理尺寸
#define HeadImage(imageUrl) FormatImage(imageUrl,150,150)

#define TimesImage(imageUrl) FormatImage(imageUrl,200,200)

#define FormatImage(imageUrl,imageWidth,imageHeight) [NSString stringWithFormat:@"%@?imageView/2/w/%d/h/%d", imageUrl,imageWidth,imageHeight]

//首页海报以及产品图片压缩比例大小
#define PostersImage(imageUrl) FormatImage(imageUrl,414,277)
#define PostersImage4s(imageUrl) FormatImage(imageUrl,320,175)

//下载更新
#define apkUrl @"http://itunes.apple.com/lookup"
//#define KEY_APPLE_ID @"702715314"
#define KEY_APPLE_ID @"992339154"

#define About_Us @"5544ad2ee4b03fd8342e9c19"//关于我们
#define Care_Agreement @"5544af16e4b03fd8342eb2d3"//用户协议

#endif
