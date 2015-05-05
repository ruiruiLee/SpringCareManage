//
//  LCNetWorkBase.m
//  SpringCare
//
//  Created by LiuZach on 15/3/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCNetWorkBase.h"
#import "ProjectDefine.h"
#import <AFNetworking.h>
#import "SBJson.h"

//#define SERVER_ADDRESS @"http://spring.avosapps.com/"
#define SERVER_ADDRESS @"http://springcare.avosapps.com/"

@implementation LCNetWorkBase

+ (id)sharedLCNetWorkBase
{
    static LCNetWorkBase *instance = nil;
    //
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{instance = [[LCNetWorkBase alloc] init];});
    return instance;
}


- (void)requestWithMethod:(NSString *)method Params:(NSDictionary *)params Completion:(Completion)completion
{
    NSString *path = SERVER_ADDRESS;
    if (method != nil && method.length > 0) {
        path = [SERVER_ADDRESS stringByAppendingString:method];
    }
    
    /**
     * 处理短时间内重复请求
     **/
    NSMutableString *Tag = [[NSMutableString alloc] init];
    [Tag appendString:path];
    for (int i = 0; i < [params.allKeys count]; i++) {
        NSString *key = [params.allKeys objectAtIndex:i];
        [Tag appendFormat:@"%@=%@", key, [params objectForKey:key]];
    }
    
    if([ProjectDefine searchRequestTag:Tag])
    {
//        if (completion!=nil) {
//            completion(0, nil);
//        }
        return;
    }
    [ProjectDefine addRequestTag:Tag];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //https
//    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ProjectDefine removeRequestTag:Tag];
        SBJsonParser *_parser = [[SBJsonParser alloc] init];
        NSDictionary *result = [_parser objectWithData:(NSData *)responseObject];
        
        NSLog(@"请求URL：%@ \n请求方法:%@ \n请求参数：%@\n 请求结果：%@\n==================================", SERVER_ADDRESS, method, params, result);
        completion(1, result);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProjectDefine removeRequestTag:Tag];
        NSLog(@"请求URL：%@ \n请求方法:%@ \n请求参数：%@\n 请求结果：%@\n==================================", SERVER_ADDRESS, method, params, error);
        if (error.code != -1001) {
            completion(0, error);
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (void)postWithMethod:(NSString *)method Params:(NSDictionary *)params Completion:(Completion)completion
{
    NSString *path = SERVER_ADDRESS;
    if (method != nil && method.length > 0) {
        path = [SERVER_ADDRESS stringByAppendingString:method];
    }
    
    /**
     * 处理短时间内重复请求
     **/
    NSMutableString *Tag = [[NSMutableString alloc] init];
    [Tag appendString:path];
    for (int i = 0; i < [params.allKeys count]; i++) {
        NSString *key = [params.allKeys objectAtIndex:i];
        [Tag appendFormat:@"%@=%@", key, [params objectForKey:key]];
    }
    
    if([ProjectDefine searchRequestTag:Tag])
    {
//        if (completion!=nil) {
//            completion(0, nil);
//        }
        return;
    }
    [ProjectDefine addRequestTag:Tag];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //https
    //    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ProjectDefine removeRequestTag:Tag];
        SBJsonParser *_parser = [[SBJsonParser alloc] init];
        NSDictionary *result = [_parser objectWithData:(NSData *)responseObject];
        
        NSLog(@"请求URL：%@ \n请求方法:%@ \n请求参数：%@\n 请求结果：%@\n==================================", SERVER_ADDRESS, method, params, result);
        if([result isKindOfClass:[NSDictionary class]] && [result objectForKey:@"code"] != nil){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[result objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return ;
        }
        if (completion!=nil) {
            completion(1, result);
        }
        
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProjectDefine removeRequestTag:Tag];
        NSLog(@"请求URL：%@ \n请求方法:%@ \n请求参数：%@\n 请求结果：%@\n==================================", SERVER_ADDRESS, method, params, error);
        if (error.code != -1001) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
         if (completion!=nil) {
        completion(0, error);
         }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (void)postWithParams:(NSString*)params Url:(NSString*)url Completion:(Completion)completion
{
    NSLog(@"%@", url);
    NSString *soapLength = [NSString stringWithFormat:@"%ld", (unsigned long)[params length]];
    
    /**
     * 处理短时间内重复请求
     **/
//    NSString *path = [NSString stringWithFormat:@"%@%@", url, params];
//    if ([ProjectDefine searchRequestTag:path]) {
//        return;
//    }else{
//        [ProjectDefine addRequestTag:path];
//    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    NSError *error = nil;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:url parameters:nil error:&error];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        
//        [ProjectDefine removeRequestTag:path];
        NSLog(@"%@", response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *response = [[NSString alloc] initWithData:(NSData *)[operation responseObject] encoding:NSUTF8StringEncoding];
        
//        [ProjectDefine removeRequestTag:path];
        NSLog(@"%@", response);
    }];
    [manager.operationQueue addOperation:operation];
}

@end
