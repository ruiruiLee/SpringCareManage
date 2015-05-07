//
//  EditCellTypeData.h
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    EnumTypeAccount,
    EnumTypeUserName,
    EnumTypeSex,
    EnumTypeAge,
    EnumTypeAddress,
    EnumTypeMobile,
    EnumTypeRelationName,
    EnumTypeHeight,//身高
} EditCellType;

@interface EditCellTypeData : NSObject

@property (nonatomic, strong) NSString *cellTitleName;
@property (nonatomic, assign) EditCellType cellType;

@end
