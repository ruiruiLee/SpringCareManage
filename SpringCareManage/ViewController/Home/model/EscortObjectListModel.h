//
//  EscortObjectListModel.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/25.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "define.h"

@interface EscortObjectListModel : NSObject

@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger totals;
@property (nonatomic, strong) NSString *careId;

+ (NSArray *) GetEscortObjectList;

- (void) RequsetEscortDataWithBlock:(block) block;

@end
