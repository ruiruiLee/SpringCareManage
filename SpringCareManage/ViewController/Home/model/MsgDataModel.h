//
//  MsgDataModel.h
//  SpringCareManage
//
//  Created by LiuZach on 15/5/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgDataModel : NSObject

@property (nonatomic, strong) NSString *msgId;
@property (nonatomic, strong) NSString *newsTitle;
@property (nonatomic, strong) NSString *createdAt;

+ (MsgDataModel *) modelFromDictionary:(NSDictionary *) dic;

//+ (void) LoadMsgListWith

@end
