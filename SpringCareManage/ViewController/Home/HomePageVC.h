//
//  HomePageVC.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "EGORefreshTableHeaderView.h"
#import "HBImageViewList.h"
#import "SwitchView.h"
#import "CouponLogoView.h"

@interface HomePageVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>
{
    UIView *_bgView;
    UIImageView *_photoImage;//头像
    UILabel *_lbName;//姓名
    UIButton *_btnCert;//证书
    UILabel *_lbMobile;//电话
    UIButton *_btnInfo;//年龄，护龄信息
    UILabel *_detailInfo;//详细信息
    
    SwitchView *_workStatus;//工作状态
    
    UIButton *_btnNew;//新订单
    UILabel *_lbNew;
    NSInteger newCount;
    BOOL newFlag;
    
    UIButton *_btnSubscribe;//已预约
    UILabel *_lbSubscribe;
    NSInteger subscribeCount;
    BOOL subscribeFlag;
    
    UIButton *_btnTreatPay;//待付款
    UILabel *_lbTreatPay;
    NSInteger treatPayCount;
    BOOL treatPayFlag;
    
    UIButton *_btnEvaluate;//待评价
    UILabel *_lbEvaluate;
    NSInteger evaluateCount;
    BOOL evaluateFlag;
    
    UIView *intervalV1;
    UIView *intervalV2;
    UIView *intervalV3;
    
    UIView *_OrderInfoView;
    UIView *_orderTitleView;
    
    UIButton *_btnOrderOnDoing;
    UIImageView *_imgVOrderOnDoing;
    UILabel *_line2;
    UILabel *_lbCareType;
    UIImageView *_imgDay;
    UILabel *_lbDetailText;
    UILabel *_line3;
    
    UILabel *_lbTotalValue;//总价值
//    UILabel *_lbCouponValue;
    UILabel *_lbRealValue;//
    
    UILabel *_btnCustomerMobile;
    UIImageView *_imgvLover;
    UILabel *_btnAddress;
    UIImageView *_imgvAddress;
    UILabel *_lbLoverInfo;
    UIImageView *_imgvLoverSex;
    UILabel *_lbOtherInfo;
    
    
    UIButton *btnRing;
    
    UIView *_SepLine;
    
    UITableView *_tableview;
    
    NSArray *constraints;
    NSArray *couponConstraints;
    NSArray *loverInfoConstraints;
    NSArray *coupons;
    
    HBImageViewList *_imageList;
    
    CouponLogoView *_couponInfoView;
}

@property (nonatomic, strong) EGORefreshTableHeaderView *refreshView;
@property (nonatomic, strong) UITableView *tableview;

@end
