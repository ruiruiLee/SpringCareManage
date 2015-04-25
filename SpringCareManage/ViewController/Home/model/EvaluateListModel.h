//
//  EvaluateListModel.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvaluateInfoModel.h"
#import "define.h"

@interface EvaluateListModel : NSObject

@property (nonatomic, strong) NSString *careId;
@property (nonatomic, strong) NSString *commentsRate;
@property (nonatomic, assign) NSInteger totals;

@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, strong) NSMutableArray *evaluateList;


+ (EvaluateListModel *) GetEvaluatesListModel;

- (void) RequestEvaluatesWithBlock:(block) block;

@end
