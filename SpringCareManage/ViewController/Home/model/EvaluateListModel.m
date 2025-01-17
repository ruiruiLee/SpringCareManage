//
//  EvaluateListModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "EvaluateListModel.h"
#import "UserModel.h"
#import "define.h"

@implementation EvaluateListModel

static EvaluateListModel *model = nil;

+ (EvaluateListModel *) GetEvaluatesListModel
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[EvaluateListModel alloc] init];
    });
    return model;
}

- (id) init
{
    self = [super init];
    if(self){
        self.evaluateList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) setPages:(NSInteger)pages
{
    if(pages == 0){
//        [self cleanDataList];
        self.totals = INT_MAX;
    }
    _pages = pages;
}

- (void) cleanDataList
{
    [self.evaluateList removeAllObjects];
}

- (void) RequestEvaluatesWithBlock:(block) block
{
    self.careId = [UserModel sharedUserInfo].userId;
    
    if(self.pages*LIMIT_COUNT >= self.totals){
        if(block){
            block(1000, nil);
        }
        
        return;
    }
    
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    if(self.careId)
        [parmas setObject:self.careId forKey:@"careId"];
    if(self.pages > 0)
        [parmas setObject:@"true" forKey:@"isOnlySplit"];
    else
        [parmas setObject:@"false" forKey:@"isOnlySplit"];
    
    [parmas setObject:[NSNumber numberWithInteger:self.pages * LIMIT_COUNT] forKey:@"offset"];
    [parmas setObject:[NSNumber numberWithInteger:LIMIT_COUNT] forKey:@"limit"];
    
    __weak EvaluateListModel *weakSelf = self;
    [LCNetWorkBase postWithMethod:@"api/order/care/comment/List" Params:parmas Completion:^(int code, id content) {
        if(code){
            if([content objectForKey:@"code"] == nil){
                if(weakSelf.pages == 0){
                    NSDictionary *care = [content objectForKey:@"care"];
                    self.commentsRate = [care objectForKey:@"commentsRate"];
                }
                self.totals = [[content objectForKey:@"total"] integerValue];
                NSArray *rows = [content objectForKey:@"rows"];
                NSMutableArray *result = [[NSMutableArray alloc] init];
                for (int i = 0; i < [rows count]; i++) {
                    NSDictionary *dic = [rows objectAtIndex:i];
                    EvaluateInfoModel *model = [EvaluateInfoModel modelFromDictionary:dic];
                    [result addObject:model];
                }
                if(self.pages == 0)
                    [self cleanDataList];
                [self.evaluateList addObjectsFromArray:result];
                
                if(block)
                    block (1, result);
            }
            if(block)
                block (0, nil);
        }
        if(block)
            block (0, nil);
    }];
}

@end
