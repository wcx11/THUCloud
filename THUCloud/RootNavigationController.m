//
//  RootNavigationController.m
//  THUCloud
//
//  Created by Dai Yue on 15-1-15.
//  Copyright (c) 2015年 WangChangxu. All rights reserved.
//

#import "RootNavigationController.h"

@interface RootNavigationController ()

@end

@implementation RootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[HttpService getHttpServiceInstance] HTTPGetWithUrl:kServerAddress Parameters:nil andCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        NSString *url = [[response.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        if ([url isEqualToString:[NSString stringWithFormat:@"%@/", kServerAddress]]) {
            //用户未登录
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:kServerAddress]];
            for (NSInteger i = 0; i < cookies.count; i++) {
                NSHTTPCookie *cookie = cookies[i];
                if ([cookie.name isEqualToString:@"csrftoken"]) {
                    csrfCookie = cookie;
                    csrftoken = cookie.value;
                }
            }
            LoginViewController * loginViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"loginViewController"];
            /*[self presentViewController:loginViewController animated:YES completion:nil];*/
            [self pushViewController:loginViewController animated:YES];
        }
        
        else{
            //用户已登录
            /*NSString * html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
            NSString *nodeString = @"//tbody//tr[@class='fileinfo']";
            NSArray *elements  = [xpathParser searchWithXPathQuery:nodeString];
            
            self.fileList = [@[] mutableCopy];
            
            for (TFHppleElement * element in elements){
                NSString * raw = element.raw;
                TFHpple * childParser = [[TFHpple alloc] initWithHTMLData:[raw dataUsingEncoding:NSUTF8StringEncoding]];
                NSString * childNodeString = @"//td[@class='listfilename']|//td[@class='listdate']";
                NSArray* fileinfo = [childParser searchWithXPathQuery:childNodeString];
                NSMutableArray* temp = [@[] mutableCopy];
                for (TFHppleElement * info in fileinfo){
                    [temp addObject:info.content];
                }
                [self.fileList addObject:temp];
            }
            [self.FileListTableView reloadData];
            NSLog(@"%@", html);*/
            LoginViewController * tabManageViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"tabManageViewController"];
            //[self performSegueWithIdentifier:@"seguetomain" sender:self];
            [self pushViewController:tabManageViewController animated:YES];;
        }
    }];
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
