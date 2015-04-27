//
//  EvaluateListCell.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradeInfoView.h"
#import "EvaluateInfoModel.h"

@interface EvaluateListCell : UITableViewCell
{
    UILabel *_lbName;
    UILabel *_lbServiceTime;
    UILabel *_lbContent;
    UILabel *_line;
    GradeInfoView *_gradeInfo;
}

- (void) SetContentWithModel:(EvaluateInfoModel *) model;

@end
