//
//  EscortObjectListModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/25.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "EscortObjectListModel.h"
#import "UserModel.h"
#import "LoverInfoModel.h"

static NSMutableArray *escortList = nil;

@implementation EscortObjectListModel
@synthesize pages;

+ (NSArray *) GetEscortObjectList
{
    if(escortList == nil){
        escortList = [[NSMutableArray alloc] init];
    }
    return escortList;
}

- (id) init
{
    self = [super init];
    if(self){
        pages = 0;
        self.totals = INT_MAX;
    }
    
    return self;
}

- (void) setPages:(NSInteger)page
{
    if(page == 0){
        [self cleanDataList];
        self.totals = INT_MAX;
    }
    pages = page;
}

- (void) cleanDataList
{
    [escortList removeAllObjects];
}

- (void) RequsetEscortDataWithBlock:(block) block
{
    self.careId = [UserModel sharedUserInfo].userId;
    
    if(self.pages*LIMIT_COUNT >= self.totals){
        if(block){
            block(1000, nil);
        }
        
        return;
    }
    
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setObject:self.careId forKey:@"careId"];
    [parmas setObject:[NSNumber numberWithInteger:LIMIT_COUNT] forKey:@"limit"];
    [parmas setObject:[NSNumber numberWithInteger:LIMIT_COUNT * self.pages] forKey:@"offset"];
    
    [LCNetWorkBase postWithMethod:@"api/lover/care/list" Params:parmas Completion:^(int code, id content) {
        if(code){
            self.totals = [[content objectForKey:@"total"] integerValue];
            NSArray *rows = [content objectForKey:@"rows"];
            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (int i = 0; i < [rows count]; i++) {
                NSDictionary *dic = [rows objectAtIndex:i];
                LoverInfoModel *model = (LoverInfoModel*)[LoverInfoModel modelFromDictionary:dic];
                [result addObject:model];
            }
            
            [escortList addObjectsFromArray:result];
            
            if(block){
                block (1, result);
            }
        }else{
            if (block) {
                block(0, nil);
            }
        }
    }];
    
}

@end

