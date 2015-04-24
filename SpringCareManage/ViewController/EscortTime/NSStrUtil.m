//
//  StrUtil.m
//  OrderFood
//
//  Created by Berwin on 13-4-10.
//  Copyright (c) 2013年 Berwin. All rights reserved.
//

#import "NSStrUtil.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
#import <UIKit/UIKit.h>
#import "define.h"
#import "TextAndEmojiView.h"

@implementation NSStrUtil

//+ (NSString *) getStoryNameByUrl:(NSString*) url
//{
//    if ([NSStrUtil notEmptyOrNull:url]) {
//        NSRange range = [url rangeOfString:@"/" options:NSBackwardsSearch];
//        NSString *string = [url substringFromIndex:NSMaxRange(range)];
//        return string;
//    } else {
//        return nil;
//    }
//}

+ (BOOL) isEmptyOrNull:(NSString*) string
{
   return ![self notEmptyOrNull:string];
    
}

+ (BOOL) notEmptyOrNull:(NSString*) string
{
    if([string isKindOfClass:[NSNull class]])
        return NO;
    if ([string isKindOfClass:[NSNumber class]]) {
        if (string != nil) {
            return  YES;
        }
        return NO;
    } else {
        string=[self trimString:string];
        if (string != nil && string.length > 0 && ![string isEqualToString:@"null"]&&![string isEqualToString:@"(null)"]&&![string isEqualToString:@" "]) {
            return  YES;
        }
        return NO;
    }
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    //手机号以13， 15，18开头，八个 \d 数字字符  14,17
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9])|(14[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobileNum];
}

+ (NSString*) makeNode:(NSString*) str{
    return [[NSString alloc] initWithFormat:@"<node>%@</node>", str];
}

+ (NSString *)trimString:(NSString *) str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize]
                         constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                             lineBreakMode:NSLineBreakByCharWrapping];
    return sizeToFit.height+5;
}

+ (float)widthForString:(NSString *)value fontSize:(float)fontSize
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize]
                         constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)
                             lineBreakMode:NSLineBreakByCharWrapping];
    return sizeToFit.width;
}

+(NSString *)convertTimetoBroadFormat:(NSString*) inputDate{
    
    if (!inputDate||inputDate.length==0) {
        return @"";
    }
    inputDate = [inputDate substringToIndex:10];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* compareDate = [dateFormatter dateFromString:inputDate];
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    NSInteger temp = timeInterval/60/60; // 小时
    NSString *result=@"";
    if(temp<24){
        result = NSLocalizedString(@"今天", @"");
    }
    else if(temp/24 <2){
        result = NSLocalizedString(@"昨天", @"");
    }
    else{
        //[dateFormatter setDateFormat:NSLocalizedString(@"MD",nil)];
        [dateFormatter setDateFormat:@"dd/MM"];
        result = [dateFormatter stringFromDate:compareDate];
    }
    return  result;
}

UIColor* colorFromHexRGB(NSString *inColorString){
    
    if ([NSStrUtil isEmptyOrNull:inColorString]) {
        return nil;
    }
    
    inColorString = [inColorString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if ([NSStrUtil isEmptyOrNull:inColorString]) {
        return nil;
    }
    
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

+ (EnDeviceType) GetCurrentDeviceType
{
    EnDeviceType type = EnumValueTypeUnknown;
    
    if([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
    {
        type = EnumValueTypeiPhone5;
    }
    else if([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)
    {
        type = EnumValueTypeiPhone6;
    }
    else if([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
    {
        type = EnumValueTypeiPhone6P;
    }
    else if ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
    {
        type = EnumValueTypeiPhone4S;
    }
    return type;
}

+ (NSInteger) NumberOfLinesForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    lb.font = _FONT(fontSize);
    lb.text = value;
    lb.numberOfLines = 0;
    
    CGSize size = [lb.text sizeWithFont:lb.font constrainedToSize:lb.frame.size lineBreakMode:lb.lineBreakMode];
    CGFloat height = [[value substringToIndex:1] sizeWithFont:lb.font].height;
    return size.height / height;
}

+ (float) HeightOfString:(NSString *) value fontSize:(float)fontSize andWidth:(float)width
{
    TextAndEmojiView *lb = [[TextAndEmojiView alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    lb.maxWidth = width;
    lb.fontsize = fontSize;
    lb.textString = value;
    
    return lb.frame.size.height;
}

@end

@implementation NSString (MyExtensions)
- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end

@implementation NSData (MyExtensions)
- (NSString*)md5
{
    unsigned char result[16];
    CC_MD5( self.bytes, self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
