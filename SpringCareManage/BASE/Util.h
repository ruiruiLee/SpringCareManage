//
//  Util.h
//  SpringCare
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "define.h"

typedef enum : NSUInteger {
    EnumMale = 1,
    EnumFemale = 0,
    EnumUnknown = 2,
} UserSex;

typedef enum : NSUInteger {
    EnumDateTypeUnknown,
    EnumTypeHalfDay,
    EnumTypeOneDay,
    EnumTypeOneWeek,
    EnumTypeOneMounth,
} DateType;

typedef enum : NSUInteger {
    EnumOrderStatusTypeNew,
    EnumOrderStatusTypeConfirm,
    EnumOrderStatusTypeServing,
    EnumOrderStatusTypeFinish,
    EnumOrderStatusTypeCancel,
    EnumOrderStatusTypeUnknown,
} OrderStatus;

typedef enum : NSUInteger {
    EnumTypeCommented,
    EnumTypeNoComment,
} CommentStatus;

typedef enum : NSUInteger {
    EnumTypePayed,
    EnumTypeNopay,
} PayStatus;

typedef enum : NSUInteger {
    EnumOrderAll,
    EnumOrderNew,
    EnumOrderSubscribe,
    EnumOrderTreatPay,
    EnumOrderEvaluate,
} OrderListType;

typedef enum : NSUInteger {
    EnumServiceTimeNight,
    EnumServiceTimeDay,
    EnumServiceTimeOneDay,
} ServiceTimeType;

@interface Util : NSObject

/**
 * 获取图片文件资源，
 * 带图片的 长, 宽
 **/
+ (NSString*) getFullImageUrlPath:(NSString*) path;


+ (NSString*) convertDinstance:(float)distance;
/**
 * 获取时间的显示字符,精确到小时
 */

+ (NSString*) StringFromDate:(NSDate*) date;
+ (NSDate*) convertDateFromString:(NSString*)string;
+ (NSString*) convertStringFromDate:(NSDate*) date;
+ (NSString*) convertStringFromDateOnlyOnDay:(NSDate*) date;
+ (NSString*) orderTimeFromDate:(NSDate*) date;  //订单展示时间形式
+ (NSString *) reductionTimeFromOrderTime:(NSString *)orderTime;//逆转回来，和上面是一对
+ (NSString*) convertTimeFromStringDate:(NSString*) stringdate;
+ (int) getAgeWithBirthday:(NSDate*) birthDate;
+ (NSInteger) GetAgeByBirthday:(NSString *) day;
+(NSString *)convertTimetoBroadFormat:(NSString*) inputDate;
/**
 *@Method openCamera:
 *@Brief 打开照相机
 *@Param |currentViewController| 当前的viewcontroller
 **/
+ (void)openCamera:(UIViewController*)currentViewController allowEdit:(BOOL)allowEdit completion:(void (^)(void))completion;

/**
 *@Method openPhotoLibrary:
 *@Brief 打开相册
 *@Param |currentViewController| 当前的viewcontroller
 **/
+ (void)openPhotoLibrary:(UIViewController*)currentViewController allowEdit:(BOOL)allowEdit completion:(void (^)(void))completion;



+ (UIImage *)fitSmallImage:(UIImage *)image scaledToSize:(CGSize)tosize;

+ (UserSex) GetSexByName:(NSString*) string;

+ (NSString *) GetOrderServiceTime:(NSDate *) begin enddate:(NSDate *) end datetype:(DateType) datetype;

+ (ServiceTimeType) GetServiceTimeType:(NSDate *) begin;

+ (NSDate*) convertDateFromDateString:(NSString*)uiDate;

+ (NSString*) ChangeToUTCTime:(NSString*) time;

+ (NSString *) headerImagePathWith:(UserSex ) sex;

+ (NSString *) SexImagePathWith:(UserSex ) sex;

+ (BOOL) isOneDay:(NSDate *) begin end:(NSDate *) end;

+ (DateType) getDateType:(NSInteger) typeId;

+ (OrderStatus) GetOrderStatus:(NSInteger) statusId;

+ (CommentStatus) GetCommentStatus:(NSInteger) statusId;

+ (PayStatus) GetPayStatus:(NSInteger) statusId;

+ (NSString*) convertShotStrFromDate:(NSDate*) date;

@end
