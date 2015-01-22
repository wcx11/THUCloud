//
//  THUCloudUtils.m
//  THUCloud
//
//  Created by Dai Yue on 15-1-17.
//  Copyright (c) 2015年 WangChangxu. All rights reserved.
//

#import "THUCloudUtils.h"
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation THUCloudUtils

+ (void)showAlertView:(NSString *)message type:(int)type
{
    [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil] show];
}
+ (BOOL)checkCaremaAuthorization
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return NO;
    }
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusRestricted)
    {
        NSLog(@"Restricted");
        return NO;
    }
    else if (authStatus == AVAuthorizationStatusDenied)
    {
        NSLog(@"Denied");
        return NO;
    }
    else if (authStatus == AVAuthorizationStatusAuthorized)
    {
        NSLog(@"Authorized");
        return YES;
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(!granted){
                    [THUCloudUtils showAlertView:kCannotAccessCameraTip type:1];
                }
            });
            
        }];
        return YES;
    }
    else
    {
        NSLog(@"Unknown authorization status");
        return NO;
    }
    return NO;
}

+ (BOOL)checkPhotoLibraryAuthorization
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        return NO;
    }
    Class clazz = NSClassFromString(@"PHPhotoLibrary");
    if (clazz)
    {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            switch (status) {
                case PHAuthorizationStatusRestricted:
                case PHAuthorizationStatusDenied:
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [THUCloudUtils showAlertView:kCannotAccessPhotoTip type:1];
                    });
                    break;
                case PHAuthorizationStatusAuthorized:
                    break;
                default:
                    break;
            }
        }];
    }
    else
    {
        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:nil failureBlock:^(NSError *error) {
            if (error.code == ALAssetsLibraryAccessUserDeniedError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [THUCloudUtils showAlertView:kCannotAccessPhotoTip type:1];
                });
            }
        }];
    }
    return YES;
}

+ (MBProgressHUD *)getProgressHUDShowing:(NSString *)text
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window != nil)
    {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
        HUD.labelText = text;
        HUD.mode = MBProgressHUDModeIndeterminate;
        [window addSubview:HUD];
        [HUD show:YES];
        return HUD;
    }
    else
    {
        return nil;
    }

}
+ (void) UploadFileWithUrl: (NSString *)url Parameters:(NSDictionary *) parameters FileName: (NSString *)filename FileData: (NSData *) filedata andCompletionHandler: (void (^)(NSURLResponse *, NSData *, NSError *))handler{
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [parameters allKeys];
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"file"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[parameters objectForKey:key]];
        }
    }
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"boris.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:filedata];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    //建立连接，设置代理
    //NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *resultStr = [[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", resultStr);
    handler(response, nil, error);

    //设置接受response的data
    //if (conn) {
    //    mResponseData = [[NSMutableData data] retain];
    //}
}
@end
