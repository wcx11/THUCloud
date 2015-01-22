//
//  FileListTableViewCell.h
//  THUCloud
//
//  Created by Dai Yue on 14-12-27.
//  Copyright (c) 2014年 WangChangxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *fileImage;
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *modifyTime;
@property (weak, nonatomic) IBOutlet UILabel *downloadFile;

@end
