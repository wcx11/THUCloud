//
//  THUCloudConfig.m
//  THUCloud
//
//  Created by Dai Yue on 14-12-24.
//  Copyright (c) 2014年 WangChangxu. All rights reserved.
//

#import "THUCloudConfig.h"

NSString *const kServerAddress = @"http://thucloud.com";
NSHTTPCookie * csrfCookie;
NSString * csrftoken;
NSString *const kCannotAccessCameraTip = @"请允许小酱油访问您的相机，可在设置->隐私->相机中打开";
NSString *const kCannotAccessPhotoTip = @"请允许小酱油访问您的照片，可在设置->隐私->照片中打开";
@implementation THUCloudConfig

@end
