//
//  EscortPublishCell.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EscortPublishCell;

@protocol EscortPublishCellDelegate <NSObject>

- (void) NotifyToPublishEscort:(EscortPublishCell *) cell;

@end

@interface EscortPublishCell : UITableViewCell
{
    UILabel *_lbTimeLine;
    UIButton *_btnPublish;
}

@property (nonatomic, assign) id<EscortPublishCellDelegate> delegate;
@property (nonatomic, strong) UILabel *lbToday;
@property (nonatomic, strong) UILabel *_lbTimeLine;

@end
