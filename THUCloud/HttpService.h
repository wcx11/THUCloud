//
//  HttpService.h
//  THUCloud
//
//  Created by Dai Yue on 14-12-24.
//  Copyright (c) 2014年 WangChangxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HttpService : NSObject
+ (HttpService * )getHttpServiceInstance;
- (void) HTTPGetWithUrl:(NSString*)url Parameters:(NSDictionary *) parameters andCompletionHandler: (void (^)(NSURLResponse *, NSData *, NSError *))handler;
- (void) HTTPPostWithUrl:(NSString*)url Parameters:(NSDictionary *) parameters andCompletionHandler: (void (^)(NSURLResponse *, NSData *, NSError *))handler;
@end
