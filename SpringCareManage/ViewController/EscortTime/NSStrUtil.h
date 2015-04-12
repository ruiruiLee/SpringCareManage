//
//  StrUtil.h
//  OrderFood
//
//  Created by Berwin on 13-4-10.
//  Copyright (c) 2013年 Berwin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    EnumValueTypeUnknown,
    EnumValueTypeiPhone4S,
    EnumValueTypeiPhone5,
    EnumValueTypeiPhone6,
    EnumValueTypeiPhone6P,
} EnDeviceType;

@interface NSStrUtil : NSObject

//+ (NSString *) getStoryNameByUrl:(NSString*) url;

+ (BOOL) isEmptyOrNull:(NSString*) string;

+ (BOOL) notEmptyOrNull:(NSString*) string;

+ (NSString*) makeNode:(NSString*) str;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (NSString *)trimString:(NSString *) str;

+ (EnDeviceType) GetCurrentDeviceType;

@end

@interface NSString (MyExtensions)
- (NSString *) md5;
@end

@interface NSData (MyExtensions)
- (NSString*)md5;
@end
