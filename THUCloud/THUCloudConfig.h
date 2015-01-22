//
//  THUCloudConfig.h
//  THUCloud
//
//  Created by Dai Yue on 14-12-24.
//  Copyright (c) 2014年 WangChangxu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kServerAddress;
extern NSString *const kCannotAccessCameraTip;
extern NSString *const kCannotAccessPhotoTip;
extern NSHTTPCookie * csrfCookie;
extern NSString * csrftoken;
@interface THUCloudConfig : NSObject

@end
