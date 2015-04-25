//
//  EvaluateListModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "EvaluateListModel.h"
#import "UserModel.h"

@implementation EvaluateListModel

static NSMutableArray *evaluateList = nil;

- (NSArray *) GetEvaluatesList
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        evaluateList = [[NSMutableArray alloc] init];
    });
    return evaluateList;
}

- (void) setCareId:(NSString *)careId
{
    if(careId != nil && ![careId isEqualToString:self.careId]){
        _careId = careId;
        self.pages = 0;
        self.totals = INT_MAX;
        
        [self cleanDataList];
    }
}

- (void) setPages:(NSInteger)pages
{
    if(pages == 0)
        [self cleanDataList];
    _pages = pages;
}

- (void) cleanDataList
{
    [evaluateList removeAllObjects];
}

- (void) RequestEvaluatesWithBlock:(block) block
{
    self.careId = [UserModel sharedUserInfo].userId;
    
    if(self.pages >= self.totals){
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
                
                [evaluateList addObjectsFromArray:result];
                
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
