//
//  define.h
//  LovelyCare
//
//  Created by LiuZach on 15/3/17.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#ifndef LovelyCare_define_h
#define LovelyCare_define_h


#define SERVER_ADDRESS @"http://baidu.com"
//#define SERVER_ADDRESS @"http://baidu.com"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width


#define _COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define _COLORa(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//#FF2A66
#define RGBwithHex(hex) _COLOR(((float)((hex & 0xFF0000) >> 16)),((float)((hex & 0xFF00) >> 8)),((float)(hex & 0xFF)))

#define ThemeImage(imageName)  [UIImage imageNamed:imageName]

//语音存放地址
#define SpeechMaxTime 60.0f

#define chat_VoiceCache_path [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VoiceCache"]

#define chat_VoiceCache_file(_fileName) [[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VoiceCache"] stringByAppendingPathComponent:_fileName]



//#define _FONT(s) [UIFont fontWithName:@"STHeitiSC-Medium" size:(s)]//[UIFont fontWithName:@"Helvetica Neue" size:(s)]
#define _FONT(s) [UIFont fontWithName:@"Helvetica Neue" size:(s)]
#define _FONT_B(s) [UIFont boldSystemFontOfSize:(s)]

#define _IPHONE_OS_VERSION_UNDER_7_0 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)

#define Nav_Title_Color [UIColor WhiteColor]

//陪护时光中用来确定内容的长度
#define Content_Width [UIScreen mainScreen].bounds.size.width - 120

//
#define Disabled_Color  _COLOR(0x8f, 0x8f, 0x97)
#define Abled_Color  [UIColor colorWithRed:(0x27)/255.0 green:(0xa6)/255.0 blue:(0x69)/255.0 alpha:1]

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define Place_Holder_Image  nil//[UIImage imageNamed:@""]

#define Photo_Place_Holder_Image  nil

#define SeparatorLineColor  _COLOR(0xd7, 0xd7, 0xd7)
#define TableBackGroundColor _COLOR(0xf8, 0xf8, 0xf8)
#define TableSectionBackgroundColor _COLOR(0xf3, 0xf5, 0xf7)

#define TIME_LIMIT 5

#endif
