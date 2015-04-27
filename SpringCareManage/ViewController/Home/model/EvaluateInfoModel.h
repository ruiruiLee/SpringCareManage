//
//  EvaluateInfoModel.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvaluateInfoModel : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createAt;
@property (nonatomic, strong) NSString *commentUserName;
@property (nonatomic, assign) NSInteger score;

+ (EvaluateInfoModel *) modelFromDictionary:(NSDictionary *)dic;

@end
