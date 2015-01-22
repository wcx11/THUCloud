//
//  UserCenterViewController.m
//  THUCloud
//
//  Created by Dai Yue on 14-12-25.
//  Copyright (c) 2014年 WangChangxu. All rights reserved.
//

#import "UserCenterViewController.h"


@interface UserCenterViewController ()

@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)LogoutButtonClicked:(id)sender {
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray) {
        NSHTTPCookie *cookie = obj;
        if ([cookie.name isEqualToString:@"csrftoken"] || [cookie.name isEqualToString:@"sessionid"])
        {
            [cookieJar deleteCookie:obj];
        }
    }
    //TabManageViewController * tabManageViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"tabManageViewController"];

    //[self presentViewController:tabManageViewController animated:YES completion:nil];
    [self performSegueWithIdentifier:@"seguetoroot" sender:self];
    //[self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
