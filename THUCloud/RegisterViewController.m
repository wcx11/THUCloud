//
//  RegisterViewController.m
//  THUCloud
//
//  Created by Dai Yue on 15-1-16.
//  Copyright (c) 2015年 WangChangxu. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *EmailText;
@property (weak, nonatomic) IBOutlet UITextField *PasswordText;
@property (weak, nonatomic) IBOutlet UITextField *NickNameText;
@property (weak, nonatomic) IBOutlet UITextField *PasswordConfirmText;

@end

@implementation RegisterViewController
- (IBAction)RegisterButtonClicked:(id)sender {
    NSString * email = self.EmailText.text;
    NSString * password = self.PasswordText.text;
    NSString * passwordConfirm = self.PasswordConfirmText.text;
    NSString * nickname = self.NickNameText.text;
    NSDictionary *parameters = @{@"csrfmiddlewaretoken":csrftoken,
                                 @"email":email,
                                 @"nickname":nickname,
                                 @"password":password,
                                 @"password_confirm":passwordConfirm,
        };
    NSString * registerUrl = [NSString stringWithFormat:@"%@/register_do", kServerAddress];
    [[HttpService getHttpServiceInstance]HTTPPostWithUrl:registerUrl Parameters:parameters andCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (error) {
            return ;
        }
        else{
            NSString *url = [[response.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            if ([url isEqualToString:[NSString stringWithFormat:@"%@/home/files?firstLogin=True", kServerAddress ]]) {
                
                [self performSegueWithIdentifier:@"registertoroot" sender:self];
            }
        }
    }];
    
}
- (IBAction)loginButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
