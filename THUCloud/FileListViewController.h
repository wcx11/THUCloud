//
//  FileListViewController.h
//  THUCloud
//
//  Created by Dai Yue on 14-12-24.
//  Copyright (c) 2014年 WangChangxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "HttpService.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "XPathQuery.h"
#import "FileListTableViewCell.h"
#import "THUCloudUtils.h"
#import "MBProgressHUD.h"

@interface FileListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate, UIAlertViewDelegate/*, NSURLConnectionDownloadDelegate*/>

@end
