//
//  MainTableCell.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableCell : UITableViewCell
{
    UIImageView *_photoImgV;
    UILabel *_lbTitle;
    UIImageView *_imgUnfold;
    UILabel *_line;
}

@property (nonatomic, strong) UIImageView *photoImgV;
@property (nonatomic, strong) UILabel *lbTitle;

@end
