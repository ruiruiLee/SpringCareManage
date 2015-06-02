//
//  OrderListCell.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfoModel.h"

@interface OrderListCell : UITableViewCell
{
    UILabel *_lbOrderNum;//订单号
    UILabel *_lbPublishTime;//下单时间
    UIButton *_btnOrderStatus;//状态
    UILabel *_line1;
    UILabel *_lbServiceContent;//服务内容
    UILabel *_lbTotalValue;//总价值
    
    UILabel *_lbCouponValue;
    UILabel *_lbRealValue;//
    
    UIImageView *_imgvDay;//白天
    UIImageView *_imgvNight;//夜晚
    UILabel *_lbDetailServiceTime;//具体时间
    UILabel *_lbLinkman;//联系人
    UIButton *_btnRing;
    UILabel *_line2;
    //服务对象
    UIImageView *_photoImg;//头像
    UILabel *_lbName;
//    UILabel *_lbRelationship;
    UIImageView *_sexLogo;
    UILabel *_lbAge;
    UILabel *_lbHeight;
    UIButton *_btnMobile;
    UIImageView *_imgvMobile;
    UILabel *_btnAddress;
    UIImageView *_imgvAddress;
    UIImageView *_statusImgv;//完成标志
    
    UIView *intervalV1;
    UIView *intervalV2;
    UIView *intervalV3;
    UIView *intervalV4;
    UIView *intervalV5;
    UIView *intervalV6;
    UIView *intervalV7;
    
    UIView *FootView;
    
    NSArray *constraintsArray;
    NSArray *constraintsAcctionArray;
    NSArray *constraintsLoverArray;
    NSArray *orderPriceConstraints;
    
    OrderInfoModel *_orderModel;
}

- (void) SetContentWithModel:(OrderInfoModel *)model;

@end
