//
//  HttpService.m
//  THUCloud
//
//  Created by Dai Yue on 14-12-24.
//  Copyright (c) 2014年 WangChangxu. All rights reserved.
//

#import "HttpService.h"

static HttpService * HttpServiceInstance;
@implementation HttpService
+ (HttpService * )getHttpServiceInstance{
    if (HttpServiceInstance == nil) {
        HttpServiceInstance = [[HttpService alloc]init];
    }
    return HttpServiceInstance;
}

- (void) HTTPGetWithUrl:(NSString*)url Parameters:(NSDictionary *) parameters andCompletionHandler: (void (^)(NSURLResponse *, NSData *, NSError *))handler{
    AFHTTPSessionManager * sessionManager  = [[AFHTTPSessionManager alloc]init];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [sessionManager GET:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData * data = responseObject;
        handler(task.response, data, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        handler(task.response, nil, error);
    }];
}

- (void) HTTPPostWithUrl:(NSString*)url Parameters:(NSDictionary *) parameters andCompletionHandler: (void (^)(NSURLResponse *, NSData *, NSError *))handler{
    AFHTTPSessionManager * sessionManager  = [[AFHTTPSessionManager alloc]init];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [sessionManager POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData * data = responseObject;
        handler(task.response, data, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        handler(task.response, nil, error);
    }];
}

- (void) synHTTPGetWithUrl:(NSString*)url Parameters:(NSDictionary *) parameters andCompletionHandler: (void (^)(NSURLResponse *, NSData *, NSError *))handler{
    NSURL *url1 = [NSURL URLWithString:@"http://thucloud.com/home/files"];
     //第二步，通过URL创建网络请求
     NSURLRequest *request1 = [[NSURLRequest alloc]initWithURL:url1 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
     NSData *received1 = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
     NSString *str0 = [[NSString alloc]initWithData:received1 encoding:NSUTF8StringEncoding];
     NSLog(@"%@",str0);
}

- (void) synHTTPPostWithUrl:(NSString*)url Parameters:(NSDictionary *) parameters andCompletionHandler: (void (^)(NSURLResponse *, NSData *, NSError *))handler{
    NSURL *url1 = [NSURL URLWithString:@"http://thucloud.com/home/files"];
    //第二步，通过URL创建网络请求
    NSURLRequest *request1 = [[NSURLRequest alloc]initWithURL:url1 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *received1 = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
    NSString *str0 = [[NSString alloc]initWithData:received1 encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str0);
}
@end
