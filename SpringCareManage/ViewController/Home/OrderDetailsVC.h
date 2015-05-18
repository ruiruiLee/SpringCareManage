//
//  OrderDetailsVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/10.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "OrderStepView.h"
#import "OrderInfoModel.h"


@protocol OrderPriceCellDelegate <NSObject>

- (void) NotifyButtonClickedWithFlag:(int) flag;//0 去付款， 1 去评论

@end

@interface OrderPriceCell : UITableViewCell
{
    UILabel *_lbPrice;
    UILabel *_lbTotalPrice;
    UIButton *_btnStatus;
    UIImageView *_imgLogo;
    OrderInfoModel *_orderModel;
}

@property (nonatomic , assign) id<OrderPriceCellDelegate> delegate;

- (void) setContentData:(OrderInfoModel *) model;

@end

@interface OrderInfoCell : UITableViewCell
{
    UIImageView *_imgPhoto;//头像
    UILabel *_lbName;//名字
    UILabel *_lbPrice;//价格
    UILabel *_lbDetailTime;
    UIButton *_btnInfo;//护工信息
    UILabel *_lbIntro;//护工介绍
    
    UILabel *_lbType;
    UILabel *_line;
    
    NSArray *constraintArray;
    NSArray *nurseConstraintArray;
}

- (void) setContentData:(OrderInfoModel *) model;

@end

@interface BeCareInfoCell : UITableViewCell
{
    UIImageView *_imgPhoto;//头像
    UILabel *_lbName;//名字
    UILabel *_lbAge;
    UIButton *_btnMobile;
    UIButton *_btnAddress;
    UILabel *_LbRelation;
    UIImageView *_imgSex;
    UIImageView *_imgvAddr;
}

- (void) setContentData:(OrderInfoModel *) model;

@end




@class OrderDetailsVC;

@protocol OrderDetailsVCDelegate <NSObject>

- (void) NotifyOrderCancelAndRefreshTableView:(OrderDetailsVC *) orderDetailVC;

@end

@interface OrderDetailsVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, OrderPriceCellDelegate>
{
    UITableView *_tableview;
    OrderStepView *_stepView;
    UILabel *lbOrderNum;//订单号
    UILabel *lbOrderTime;//下单时间
    
    OrderInfoModel *_orderModel;
    
    OrderInfoCell *ordercell;
}

@property (nonatomic, strong)OrderInfoModel *_orderModel;
@property (nonatomic, strong)OrderStepView *_stepView;
@property (nonatomic, assign) id<OrderDetailsVCDelegate> delegate;

- (id) initWithOrderModel:(OrderInfoModel *) model;

@end
