//
//  MsgDataListModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/5/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MsgDataListModel.h"
#import "MsgDataModel.h"

static MsgDataListModel *msgList = nil;

@implementation MsgDataListModel

+ (MsgDataListModel *)ShareMsgListModel
{
    if(msgList == nil){
        msgList = [[MsgDataListModel alloc] init];
    }
    
    return msgList;
}

- (id) init
{
    self = [super init];
    if(self){
        self.pages = 0;
        self.totals = INT_MAX;
        self.dataList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) setPages:(NSInteger)pages
{
    if(pages == 0){
        _pages = pages;
        self.totals = INT_MAX;
        [self.dataList removeAllObjects];
    }
    else
        _pages = pages;
}

- (void) LoadMsgListWithBlock:(block) block
{
    int offset = self.pages *LIMIT_COUNT;
    if(offset > [self.dataList count])
        offset = [self.dataList count];
    
    if(offset >= self.totals){
        if(block)
            block (0, nil);
        return;
    }
    
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setObject:[NSNumber numberWithInt:LIMIT_COUNT] forKey:@"limit"];
    [parmas setObject:[NSNumber numberWithInt:offset] forKey:@"offset"];
    
    [LCNetWorkBase postWithMethod:@"api/news/list" Params:parmas Completion:^(int code, id content) {
        if(code){
            self.totals = [[content objectForKey:@"total"] integerValue];
            
            NSMutableArray *result = [[NSMutableArray alloc] init];
            NSArray *rows = [content objectForKey:@"rows"];
            for (int i = 0; i<[rows count]; i++) {
                NSDictionary *dic = [rows objectAtIndex:i];
                MsgDataModel *model = [MsgDataModel modelFromDictionary:dic];
                [result addObject:model];
            }
            
            [self.dataList addObjectsFromArray:result];
            
            if(block)
                block(1, result);
        }
        
        if(block)
            block (0, nil);
    }];
}

@end
