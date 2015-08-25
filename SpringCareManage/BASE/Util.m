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


+ (int) getAgeWithBirthday:(NSDate*) birthDate
{
    NSTimeInterval dateDiff = [birthDate timeIntervalSinceNow];
    int age = trunc(dateDiff/(60*60*24))/365;
    return -age;
}
+ (NSInteger) GetAgeByBirthday:(NSString *) day
{
    NSDate *date = [Util convertDateFromDateString:day];
    return [self getAgeWithBirthday:date];
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

+ (NSString*) convertStringFromDate:(NSDate*) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH"];
    NSString *string = [formatter stringFromDate:date];
    return string;
}

+ (NSString*) convertStringFromDateOnlyOnDay:(NSDate*) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
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

+ (NSInteger)GetMonthFromdate:(NSString *)inputDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:inputDate];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    NSInteger month = [components month]; // 9
    
    return month;
}

+ (NSString*) convertChinese:(NSInteger)number{
    if (number>1 ) {
        NSArray * arrMonth=[NSArray arrayWithObjects:@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月", nil];
        return [NSString stringWithFormat:@"%@",[arrMonth objectAtIndex:number-1]];
    }
    else{
        return @"";
    }
    
}

+ (NSInteger)GetDayFromdate:(NSString *)inputDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:inputDate];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    NSInteger day = [components day]; // 15
    
    return day;
}

+(NSString *)convertTimetoBroadFormat:(NSString*) inputDate{
    
    if (!inputDate||inputDate.length==0) {
        return @"";
    }
    // inputDate = [inputDate substringToIndex:10];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* compareDate = [dateFormatter dateFromString:inputDate];
    
    return [Util compareDate:compareDate];
}

+(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
//    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[self StringFromDate:today] substringToIndex:10];
    NSString * yesterdayString = [[self StringFromDate:yesterday] substringToIndex:10];
//    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[self StringFromDate:date] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }
    else
    {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"dd/MM"];
//        NSString *result = [dateFormatter stringFromDate:date];
        return nil;
    }
}

+ (NSArray*) convertTimeFromStringDate:(NSString*) stringdate
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:stringdate];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init] ;
    [formatter2 setDateFormat:@"HH:mm"];
    
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init] ;
    [formatter3 setDateFormat:@"yyyy-MM-dd"];
    
    NSArray *array = [[NSArray alloc]initWithObjects:[formatter3 stringFromDate:date],[formatter2 stringFromDate:date], nil];
    return array;
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
    
    if(beginHour > 12)
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
        [result appendString:@"08:00-20:00"];
//        [result appendString:[NSString stringWithFormat:@"%02ld", beginHour]];
//        [result appendString:[NSString stringWithFormat:@".%02ld", beginMinute]];
//        [result appendString:[NSString stringWithFormat:@"－"]];
//        ServiceTimeType timeType = [Util GetServiceTimeType:begin];
//        if(timeType == EnumServiceTimeNight)
//            [result appendString:[NSString stringWithFormat:@"次日"]];
//        [result appendString:[NSString stringWithFormat:@"%02ld", endHour]];
//        [result appendString:[NSString stringWithFormat:@".%02ld", endMinute]];
        [result appendString:[NSString stringWithFormat:@")"]];
    }else{
        [result appendString:[NSString stringWithFormat:@"("]];
        [result appendString:[NSString stringWithFormat:@"%02ld", beginHour]];
        [result appendString:[NSString stringWithFormat:@":%02ld", beginMinute]];
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

+ (NSString *) SexImagePathWith:(UserSex ) sex
{
    NSString *sexPath = nil;
    if(sex == EnumMale)
        sexPath = @"mail";
    else if (sex == EnumFemale)
        sexPath = @"femail";
    return sexPath;
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

+ (DateType) getDateType:(NSInteger) typeId
{
    DateType type = (typeId == 1) ? EnumTypeHalfDay : EnumTypeOneDay;
    return type;
}

+ (OrderStatus) GetOrderStatus:(NSInteger) statusId
{
    OrderStatus status = EnumOrderStatusTypeUnknown;
    if(statusId == 1)
        status = EnumOrderStatusTypeNew;
    else if (statusId == 2)
        status = EnumOrderStatusTypeConfirm;
    else if (statusId == 3)
        status = EnumOrderStatusTypeServing;
    else if (statusId == 4)
        status = EnumOrderStatusTypeFinish;
    else if (statusId == 99)
        status = EnumOrderStatusTypeCancel;
    else
        status = EnumOrderStatusTypeUnknown;
    
    return status;
}

+ (CommentStatus) GetCommentStatus:(NSInteger) statusId
{
    CommentStatus status = EnumTypeNoComment;
    if(status > 0)
        status = EnumTypeNoComment;
    else
        status = EnumTypeCommented;
    
    return status;
}

+ (PayStatus) GetPayStatus:(NSInteger) statusId
{
    PayStatus status = EnumTypeNopay;
    if(statusId == 1)
        status = EnumTypePayed;
    
    return status;
}

+ (NSString*) convertShotStrFromDate:(NSDate*) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"M月d日 HH"];
    NSString *string = [formatter stringFromDate:date];
    return string;
}

+ (BOOL) isDateShowFirstDate:(NSString *)date1 secondDate:(NSString *)date2
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[Util convertDateFromDateString:date1]];
    
    NSInteger beginday = [components day]; // 15
    NSInteger beginmonth = [components month]; // 9
    NSInteger beginyear = [components year]; // 5764
    
    components = [calendar components:unitFlags fromDate:[Util convertDateFromDateString:date2]];
    NSInteger endday = [components day]; // 15
    NSInteger endmonth = [components month]; // 9
    NSInteger endyear = [components year]; // 5764
    
    if(beginyear == endyear && beginday == endday && beginmonth == endmonth)
        return NO;
    else
        return YES;
}

+ (void)showAlertMessage:(NSString*)msg
{
    UIAlertView * mAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定"  otherButtonTitles:nil, nil];
    [mAlert show];
}

+ (void)updateVersion :(void(^)(NSArray *info))handleResponse{
    NSDictionary *jsonInfo = [[NSDictionary alloc] initWithObjectsAndKeys:KEY_APPLE_ID, @"id", @"cn", @"country", nil];
    [LCNetWorkBase GetWithParams:jsonInfo  Url:apkUrl Completion:^(int code, id content) {
        if(code){
            if ([[content objectForKey:@"resultCount"] integerValue]==0) {
                [Util showAlertMessage:@"请等待上架appstore！"];
            }
            else{
                NSArray *infoArray = [content objectForKey:@"results"];
                if (infoArray) {
                    if (handleResponse) {
                        handleResponse(infoArray);
                    }
                }
                else{
                    [Util showAlertMessage:@"更新失败！"];
                }
            }
        }
        else{
            [Util showAlertMessage:content];
        }
    }];
    
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *) GetBtnBackgroundImage
{
    UIImage *image = [Util imageWithColor:Abled_Color size:CGSizeMake(5, 5)];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, image.size.width/2-10, 0, image.size.width/2-10);
    
    return [image resizableImageWithCapInsets:inset ];
}

+ (NSString *)getCurrentVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return currentVersion;
}

@end
