//
//  ViewController.m
//  THUCloud
//
//  Created by Dai Yue on 14-12-5.
//  Copyright (c) 2014年 WangChangxu. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *EmailText;
@property (weak, nonatomic) IBOutlet UITextField *PassWordText;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        NSLog(@"%@", cookie);
    }*/
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"logintoregister" sender:self];
}
- (IBAction)loginButtonClicked:(id)sender {
    NSString * email = self.EmailText.text;
    NSString * password = self.PassWordText.text;
    NSDictionary *parameters = @{@"csrfmiddlewaretoken":csrftoken,
                   @"email":email,
                   @"password":password,
                   @"next":@"/"};
    NSString * loginUrl = [NSString stringWithFormat:@"%@/login_do", kServerAddress];
    [[HttpService getHttpServiceInstance]HTTPPostWithUrl:loginUrl Parameters:parameters andCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (error) {
            return ;
        }
        else{
            NSString *url = [[response.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            if ([url isEqualToString:[NSString stringWithFormat:@"%@/home/files", kServerAddress ]]) {
                //[self dismissViewControllerAnimated:YES completion:nil];
                //[self.navigationController popViewControllerAnimated:YES];
                [self performSegueWithIdentifier:@"logintoroot" sender:self];
            }
        }
    }];
    
}

@end
