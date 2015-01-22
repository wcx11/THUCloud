//
//  THUCloudUtils.h
//  THUCloud
//
//  Created by Dai Yue on 15-1-17.
//  Copyright (c) 2015年 WangChangxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THUCloudConfig.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface THUCloudUtils : NSObject<UIAlertViewDelegate>
+ (BOOL)checkCaremaAuthorization;
+ (BOOL)checkPhotoLibraryAuthorization;
+ (void)showAlertView:(NSString *)message type:(int)type;
+ (MBProgressHUD *)getProgressHUDShowing:(NSString *)text;
+ (void) UploadFileWithUrl: (NSString *)url Parameters:(NSDictionary *) parameters FileName: (NSString *)filename FileData: (NSData *) filedata andCompletionHandler: (void (^)(NSURLResponse *, NSData *, NSError *))handler;
@end
