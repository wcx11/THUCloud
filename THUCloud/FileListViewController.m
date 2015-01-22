//
//  FileListViewController.m
//  THUCloud
//
//  Created by Dai Yue on 14-12-24.
//  Copyright (c) 2014年 WangChangxu. All rights reserved.
//

#import "FileListViewController.h"



@interface FileListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *FileListTableView;
@property NSMutableArray * fileList;
@property NSMutableData * downloadData;
@property NSURLConnection * downloadConnection;
@end

@implementation FileListViewController
- (IBAction)sortButtonClicked:(id)sender {
    
}

- (IBAction)uploadButtonClicked:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传文件" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册中选择", nil];
    [actionSheet showInView:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:kServerAddress]];
    for (NSInteger i = 0; i < cookies.count; i++) {
        NSHTTPCookie *cookie = cookies[i];
        if ([cookie.name isEqualToString:@"csrftoken"]) {
            csrfCookie = cookie;
            csrftoken = cookie.value;
        }
    }
    self.FileListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //if ([self.FileListTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
    if ([self.FileListTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.FileListTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([self.FileListTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.FileListTableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
        
    //}
    
    //loginViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //loginViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    // Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated{
}

- (void)viewDidAppear:(BOOL)animated{
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
            [self presentViewController:loginViewController animated:YES completion:nil];
            
        }
        
        else{
            //用户已登录
            NSString * html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
            NSLog(@"%@", html);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fileList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FileListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"filecell" ];
    if(cell == nil)
    {
        cell = [[FileListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"filecell"];
    }
    cell.fileName.text = self.fileList[indexPath.row][0];
    cell.modifyTime.text = self.fileList[indexPath.row][1];
    cell.fileImage.image =  [UIImage imageNamed:@"text"];
    cell.downloadFile.tag = indexPath.row;
    cell.tag = indexPath.row;
    cell.downloadFile.userInteractionEnabled = YES;
    cell.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downloadClicked:)];
    UILongPressGestureRecognizer * longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressFile:)];
    [cell addGestureRecognizer:longpress];
    [cell.downloadFile addGestureRecognizer:tap];
    return cell;
}
-(void) longPressFile: (UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"文件操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"重命名", @"删除", nil];
        actionSheet.tag = gesture.view.tag;
        [actionSheet showInView:self.view];
    }
}
-(void) downloadClicked:(UITapGestureRecognizer *)gesture{
    NSLog(@"====%d",gesture.view.tag);//label的tag
    NSString * downloadUrl = [NSString stringWithFormat:@"%@/download_file?file_name=%@", kServerAddress, self.fileList[gesture.view.tag][0]];
    NSURL    *url = [NSURL URLWithString:downloadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableData *data = [[NSMutableData alloc] init];
    self.downloadData = data;
    NSURLConnection *newConnection = [[NSURLConnection alloc]
                                      initWithRequest:request
                                      delegate:self
                                      startImmediately:YES];
    self.downloadConnection = newConnection;
    if (self.downloadConnection != nil){
        NSLog(@"Successfully created the connection");
    } else {
        NSLog(@"Could not create the connection");
    }
}
#pragma mark - tableViewDelegate
#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:@"上传文件"]){
        if (buttonIndex == 2)
        {
            return;
        }
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        if (buttonIndex == 0)
        {
            if (![THUCloudUtils checkCaremaAuthorization])
            {
                [THUCloudUtils showAlertView:kCannotAccessCameraTip type:1];
                return;
            }
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else if (buttonIndex == 1)
        {
            if (![THUCloudUtils checkPhotoLibraryAuthorization])
            {
                [THUCloudUtils showAlertView:kCannotAccessPhotoTip type:1];
                return;
            }
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else if([actionSheet.title isEqualToString:@"文件操作"]){
        if (buttonIndex == 2)
        {
            return;
        }
        if (buttonIndex == 0) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"重命名"
                                                            message:@"请输入新文件名："
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Ok",nil];
            alert.tag = actionSheet.tag;
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [alert show];
        }
        else if (buttonIndex == 1){
            NSDictionary *parameters = @{@"csrfmiddlewaretoken":csrftoken,
                                         @"file_name":self.fileList[actionSheet.tag][0]
                                         };
            NSString * deleteUrl = [NSString stringWithFormat:@"%@/delete_file", kServerAddress];
            [[HttpService getHttpServiceInstance]HTTPPostWithUrl:deleteUrl Parameters:parameters andCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                if (error) {
                    [THUCloudUtils showAlertView:@"删除失败，请刷新或检查您的网络" type:0];
                }
                else{
                    [THUCloudUtils showAlertView:@"删除成功" type:0];
                    [self.fileList removeObjectAtIndex:actionSheet.tag];
                    [self.FileListTableView reloadData];
                }
            }];

        }
    }
    
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if (buttonIndex == 0) {
    }
    else if (buttonIndex == 1){
        NSDictionary *parameters = @{@"csrfmiddlewaretoken":csrftoken,
                                     @"old_name":self.fileList[alertView.tag][0],
                                     @"new_name":[alertView textFieldAtIndex:0].text
                                     };
        NSString * deleteUrl = [NSString stringWithFormat:@"%@/rename_file", kServerAddress];
        [[HttpService getHttpServiceInstance]HTTPGetWithUrl:deleteUrl Parameters:parameters andCompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            if (error) {
                [THUCloudUtils showAlertView:@"重命名失败，请刷新或检查您的网络" type:0];
            }
            else{
                //[THUCloudUtils showAlertView:@"重命名成功" type:0];
                [self.fileList objectAtIndex:alertView.tag][0] = [alertView textFieldAtIndex:0].text;
                //[self.fileList removeObjectAtIndex:alertView.tag];
                [self.FileListTableView reloadData];
            }
        }];
    }
}
#pragma mark ImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    MBProgressHUD *HUD = [THUCloudUtils getProgressHUDShowing:@"正在上传图片"];
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    NSString * uploadUrl = [NSString stringWithFormat:@"%@/uploadhandler", kServerAddress];
    NSDictionary *parameters = @{@"csrfmiddlewaretoken":csrftoken,
                                 @"file":UIImagePickerControllerEditedImage,
                                };
    [THUCloudUtils UploadFileWithUrl: uploadUrl Parameters:parameters FileName: UIImagePickerControllerEditedImage FileData: data andCompletionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
        [HUD removeFromSuperview];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - NSURLConnectionDeletate
- (void) connection:(NSURLConnection *)connection
   didFailWithError:(NSError *)error{
    NSLog(@"An error happened");
    NSLog(@"%@", error);
}
- (void) connection:(NSURLConnection *)connection
     didReceiveData:(NSData *)data{
    NSLog(@"Received data");
    [self.downloadData appendData:data];
}
- (void) connectionDidFinishLoading
:(NSURLConnection *)connection{
    /* 下载的数据 */
    
    NSLog(@"下载成功");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory, @"temp.png"];
    if ([self.downloadData writeToFile:savePath atomically:YES]) {
        NSLog(@"保存成功.");
    }
    else
    {
        NSLog(@"保存失败.");
    }
    
    /* do something with the data here */
}
- (void) connection:(NSURLConnection *)connection
 didReceiveResponse:(NSURLResponse *)response{
    [self.downloadData setLength:0];
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
