//
//  Util.m
//  SpringCare
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "Util.h"
#import <MobileCoreServices/MobileCoreServices.h>
@implementation Util

+ (NSString*) getFullImageUrlPath:(NSString*) path
{
    return @"";
}



+ (NSString*) StringFromDate:(NSDate*) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string = [formatter stringFromDate:date];
    return string;
}


+ (NSDate*) getDateFromString:(NSString*) string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date=[formatter dateFromString:string];
    return date;
}

+ (NSDate*) convertDateFromString:(NSString*)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH"];
    NSDate *date=[formatter dateFromString:string];
    return date;
}

+ (NSString*) convertStringFromString:(NSDate*) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH"];
    NSString *string = [formatter stringFromDate:date];
    return string;
}

+ (NSString*) convertDinstance:(float)distance
{
    if (distance>=1000) {
       // distance =round(distance/1000*100)/100 ;
        distance=distance/1000;
         return [NSString stringWithFormat:@"%.2fKm",distance];
    }
    else{
        return [NSString stringWithFormat:@"%.0fm",distance];
    }
}

+ (NSString*) orderTimeFromDate:(NSDate*)Date
{
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:Date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [formatter stringFromDate:Date];
    [formatter setDateFormat:@"HH:mm"];
    NSString *strTime = [formatter stringFromDate:Date];
    return [NSString stringWithFormat:@"%@ %@  %@",strDate, [weekdays objectAtIndex:[comp weekday]],strTime];
}

+ (NSString *) reductionTimeFromOrderTime:(NSString *)orderTime
{
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    for (int i = 0; i < [weekdays count]; i++) {
        NSString *string = [weekdays objectAtIndex:i];
        NSString *newString = [NSString stringWithFormat:@" %@ ", string];
        orderTime = [orderTime stringByReplacingOccurrencesOfString:newString withString:@""];
    }
    
    return orderTime;
}

+ (int) getAgeWithBirthday:(NSString*) birthday
{
    int birth = [[birthday substringToIndex:4] intValue];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    int year = (int)[comps year];
    
    return (year - birth);
}

//图像等比例压缩 .充满空隙

+(UIImage *)fitSmallImage:(UIImage *)image scaledToSize:(CGSize)tosize
{
    if (!image)
    {
        return nil;
    }
    if (image.size.width<tosize.width && image.size.height<tosize.height)
    {
        return image;
    }
    CGFloat wscale = image.size.width/tosize.width;
    CGFloat hscale = image.size.height/tosize.height;
    CGFloat scale = (wscale>hscale)?wscale:hscale;
    CGSize newSize = CGSizeMake(image.size.width/scale, image.size.height/scale);
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
    [image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

// 打开照相机
+ (void)openCamera:(UIViewController*)currentViewController allowEdit:(BOOL)allowEdit completion:(void (^)(void))completion
{
    UIImagePickerController  *picker = [[UIImagePickerController alloc] init];
    //
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        picker.delegate      = (id)currentViewController;
        picker.allowsEditing = allowEdit;
        picker.sourceType    = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        //
        [currentViewController presentViewController:picker animated:YES completion:completion];
    }
}

//打开相册
+ (void)openPhotoLibrary:(UIViewController*)currentViewController allowEdit:(BOOL)allowEdit completion:(void (^)(void))completion
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    //
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        pickerImage.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        pickerImage.delegate      = (id)currentViewController;
        pickerImage.allowsEditing = allowEdit;
        //
        [currentViewController presentViewController:pickerImage animated:YES completion:completion];
    }
}


+ (UserSex) GetSexByName:(NSString*) string
{
    if(string == nil)
        return EnumUnknown;
    if([string isEqualToString:@"男"])
        return EnumMale;
    else if ([string isEqualToString:@"女"])
        return EnumFemale;
    else
        return EnumUnknown;
}

//半天服务时，获取是晚上服务还是白天服务
+ (ServiceTimeType) GetServiceTimeType:(NSDate *) begin
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [calendar components:unitFlags fromDate:begin];
    
    NSInteger beginHour = [components hour];
    
    if(beginHour >= 18)
        return EnumServiceTimeNight;
    else
        return EnumServiceTimeDay;
}

+ (NSString *) GetOrderServiceTime:(NSDate *) begin enddate:(NSDate *) end datetype:(DateType) datetype
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [calendar components:unitFlags fromDate:begin];
    
    NSInteger beginday = [components day]; // 15
    NSInteger beginmonth = [components month]; // 9
    NSInteger beginyear = [components year]; // 5764
    NSInteger beginHour = [components hour];
    NSInteger beginMinute = [components minute];
    
    components = [calendar components:unitFlags fromDate:end];
    NSInteger endday = [components day]; // 15
    NSInteger endmonth = [components month]; // 9
    NSInteger endyear = [components year]; // 5764
    NSInteger endHour = [components hour];
    NSInteger endMinute = [components minute];
    
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendString:[NSString stringWithFormat:@"%ld", beginyear]];
    [result appendString:[NSString stringWithFormat:@".%02ld", beginmonth]];
    [result appendString:[NSString stringWithFormat:@".%02ld", beginday]];
    [result appendString:[NSString stringWithFormat:@"－"]];
    if(endyear != beginyear){
        [result appendString:[NSString stringWithFormat:@"%ld.", endyear]];
    }
    [result appendString:[NSString stringWithFormat:@"%02ld", endmonth]];
    [result appendString:[NSString stringWithFormat:@".%02ld", endday]];
    
    if(datetype == EnumTypeHalfDay){
        [result appendString:[NSString stringWithFormat:@"("]];
        [result appendString:[NSString stringWithFormat:@"%02ld", beginHour]];
        [result appendString:[NSString stringWithFormat:@".%02ld", beginMinute]];
        [result appendString:[NSString stringWithFormat:@"－"]];
        ServiceTimeType timeType = [Util GetServiceTimeType:begin];
        if(timeType == EnumServiceTimeNight)
            [result appendString:[NSString stringWithFormat:@"次日"]];
        [result appendString:[NSString stringWithFormat:@"%02ld", endHour]];
        [result appendString:[NSString stringWithFormat:@".%02ld", endMinute]];
        [result appendString:[NSString stringWithFormat:@")"]];
    }
    
    return result;
}

+ (NSDate*) convertDateFromDateString:(NSString*)uiDate
{
    NSString *sub = [uiDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString *sub1 = [sub stringByReplacingOccurrencesOfString:@"Z" withString:@""];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:sub1];
    return date;
}

+ (NSString*) ChangeToUTCTime:(NSString*) time
{
//    NSDate *date = [Util getDateFromString:time];
    
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    
//    NSDate *localeDate = [date  dateByAddingTimeInterval: -interval];
    
    return time;//[Util getStringFromDate:localeDate];
}

+ (NSString *) headerImagePathWith:(UserSex ) sex
{
//    return @"";
    NSString *headerImage = @"nurselistfemale";
    if( sex == EnumMale)
        headerImage = @"nurselistmale";
    return headerImage;
}

+ (NSInteger) GetAgeByBirthday:(NSString *) day
{
    NSDate *date = [Util convertDateFromDateString:day];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    NSInteger beginyear = [components year]; // 5764
    
    components = [calendar components:unitFlags fromDate:[NSDate date]];
    
    return [components year] - beginyear;
}

+ (BOOL) isOneDay:(NSDate *) begin end:(NSDate *) end
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [calendar components:unitFlags fromDate:begin];
    NSInteger beginyear = [components year]; // 5764
    
    components = [calendar components:unitFlags fromDate:end];
    NSInteger endyear = [components year]; // 5764
    
    if(beginyear == endyear){
        return YES;
    }else
        return NO;
}

@end
