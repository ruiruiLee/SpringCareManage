//
//  OrderListCell.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "OrderListCell.h"
#import "define.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"

@implementation OrderListCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initSubviews];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel*) createLabel:(UIFont*) font txtColor:(UIColor*)txtColor
{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:lb];
    lb.translatesAutoresizingMaskIntoConstraints = NO;
    lb.textColor = txtColor;
    lb.font = font;
    lb.backgroundColor = [UIColor clearColor];
    return lb;
}

- (void) initSubviews
{
    _lbOrderNum = [self createLabel:_FONT(14) txtColor: [UIColor blackColor]];
    
    _btnOrderStatus = [[UIButton alloc] initWithFrame:CGRectZero];
    _btnOrderStatus.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_btnOrderStatus];
    _btnOrderStatus.titleLabel.font = _FONT(12);
    [_btnOrderStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnOrderStatus.userInteractionEnabled = NO;
    _btnOrderStatus.clipsToBounds = YES;
    _btnOrderStatus.layer.cornerRadius = 5;
    _btnOrderStatus.backgroundColor = _COLOR(26, 147, 251);
    [_btnOrderStatus addTarget:self action:@selector(doBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _line1 = [self createLabel:_FONT(15) txtColor:_COLOR(0x10, 0x9d, 0x59)];
    _line1.backgroundColor = SeparatorLineColor;
    
    _lbServiceContent = [self createLabel:_FONT(15) txtColor:_COLOR(0x3d, 0x3d, 0x3d)];
    
    _lbTotalValue = [self createLabel:_FONT_B(20) txtColor:_COLOR(0x66, 0x66, 0x66)];
    
    _lbRealValue = [self createLabel:_FONT_B(20) txtColor:_COLOR(0x3d, 0x3d, 0x3d)];
    
    _imgvDay = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imgvDay];
    _imgvDay.translatesAutoresizingMaskIntoConstraints = NO;
    
    _imgvNight = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imgvNight];
    _imgvNight.translatesAutoresizingMaskIntoConstraints = NO;
    _imgvNight.image = ThemeImage(@"stime");
    
    _lbDetailServiceTime = [self createLabel:_FONT(13) txtColor:_COLOR(0xc2, 0xc2, 0xc2)];
    
    _line2 = [self createLabel:_FONT(15) txtColor:_COLOR(0x10, 0x9d, 0x59)];
    _line2.backgroundColor = SeparatorLineColor;
    
    
    _OrderInfoBg = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_OrderInfoBg];
    _OrderInfoBg.translatesAutoresizingMaskIntoConstraints = NO;
    _OrderInfoBg.backgroundColor = _COLOR(235, 241, 245);
    
    _lbLinkman = [[UILabel alloc] initWithFrame:CGRectZero];
    [_OrderInfoBg addSubview:_lbLinkman];
    _lbLinkman.translatesAutoresizingMaskIntoConstraints = NO;
    _lbLinkman.textColor = _COLOR(0xc2, 0xc2, 0xc2);
    _lbLinkman.font = _FONT(14);
    _lbLinkman.backgroundColor = [UIColor clearColor];
    
    _btnRing = [[UIButton alloc] initWithFrame:CGRectZero];
    [_OrderInfoBg addSubview:_btnRing];
    _btnRing.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnRing setImage:ThemeImage(@"orderdetailtel") forState:UIControlStateNormal];
    [_btnRing addTarget:self action:@selector(btnRingClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //对象信息
    _photoImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_OrderInfoBg addSubview:_photoImg];
    _photoImg.translatesAutoresizingMaskIntoConstraints = NO;
    _photoImg.layer.cornerRadius = 26;
    _photoImg.clipsToBounds = YES;
    
    _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_OrderInfoBg addSubview:_lbName];
    _lbName.translatesAutoresizingMaskIntoConstraints = NO;
    _lbName.textColor = _COLOR(0x3d, 0x3d, 0x3d);
    _lbName.font = _FONT(14);
    _lbName.backgroundColor = [UIColor clearColor];
    
    _lbAge =  [[UILabel alloc] initWithFrame:CGRectZero];
    [_OrderInfoBg addSubview:_lbAge];
    _lbAge.translatesAutoresizingMaskIntoConstraints = NO;
    _lbAge.textColor = _COLOR(0x3d, 0x3d, 0x3d);
    _lbAge.font = _FONT(14);
    _lbAge.backgroundColor = [UIColor clearColor];
    
    _lbHeight =  [[UILabel alloc] initWithFrame:CGRectZero];
    [_OrderInfoBg addSubview:_lbHeight];
    _lbHeight.translatesAutoresizingMaskIntoConstraints = NO;
    _lbHeight.textColor = _COLOR(0x3d, 0x3d, 0x3d);
    _lbHeight.font = _FONT(14);
    _lbHeight.backgroundColor = [UIColor clearColor];
    
    _btnAddress = [[UILabel alloc] initWithFrame:CGRectZero];
    [_OrderInfoBg addSubview:_btnAddress];
    _btnAddress.translatesAutoresizingMaskIntoConstraints = NO;
    _btnAddress.textColor = _COLOR(0x3d, 0x3d, 0x3d);
    _btnAddress.numberOfLines = 2;
    _btnAddress.preferredMaxLayoutWidth = ScreenWidth - 121;
    _btnAddress.font = _FONT(14);
    
    _sexLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_OrderInfoBg addSubview:_sexLogo];
    _sexLogo.translatesAutoresizingMaskIntoConstraints = NO;
    
    _statusImgv = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_statusImgv];
    _statusImgv.translatesAutoresizingMaskIntoConstraints = NO;
    _statusImgv.image = [UIImage imageNamed:@"orderend"];
    
    intervalV1 = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:intervalV1];
    intervalV1.translatesAutoresizingMaskIntoConstraints = NO;
    
    intervalV2 = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:intervalV2];
    intervalV2.translatesAutoresizingMaskIntoConstraints = NO;
    
    intervalV3 = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:intervalV3];
    intervalV3.translatesAutoresizingMaskIntoConstraints = NO;
    
    intervalV5 = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:intervalV5];
    intervalV5.translatesAutoresizingMaskIntoConstraints = NO;
    
    intervalV6 = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:intervalV6];
    intervalV6.translatesAutoresizingMaskIntoConstraints = NO;
    
    intervalV7 = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:intervalV7];
    intervalV7.translatesAutoresizingMaskIntoConstraints = NO;
    
    FootView = [[UIView alloc] initWithFrame:CGRectZero];
    FootView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:FootView];
    FootView.backgroundColor = TableSectionBackgroundColor;
    _imgvDay.hidden = YES;
    
    _couponInfoView = [[CouponLogoView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_couponInfoView];
    _couponInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self createAutoLayoutConstraints];
}

- (void) createAutoLayoutConstraints
{
    UIView *root = self.contentView;
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbOrderNum, _btnOrderStatus, _line1, _lbServiceContent, _lbTotalValue, _imgvDay, _imgvNight, _lbDetailServiceTime, _lbLinkman, _btnRing, _line2, _photoImg, _lbName, _sexLogo, _lbAge, _btnAddress, _statusImgv, intervalV1, intervalV2, intervalV3, intervalV5, FootView, intervalV6, intervalV7, _lbHeight, _lbRealValue, _OrderInfoBg, _couponInfoView);
    
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_lbOrderNum]->=4-[_btnOrderStatus(54)]-20-|" options:0 metrics:nil views:views]];
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_line1]-22-|" options:0 metrics:nil views:views]];
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_lbServiceContent]->=10-[_lbRealValue]-19-|" options:0 metrics:nil views:views]];
    couponConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=22-[_lbTotalValue]-4-[_couponInfoView]-19-|" options:0 metrics:nil views:views];
    [root addConstraints:couponConstraints];
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_OrderInfoBg]-0-|" options:0 metrics:nil views:views]];
    constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_imgvNight]-6-[_lbDetailServiceTime]->=10-|" options:0 metrics:nil views:views];
    [root addConstraints:constraintsArray];
    
    [_OrderInfoBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_lbLinkman]->=20-[_btnRing(32)]-20-|" options:0 metrics:nil views:views]];
    [_OrderInfoBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnRing(32)]->=0-|" options:0 metrics:nil views:views]];
    constraintsAcctionArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_photoImg]-22-[_lbName]-6-[_sexLogo]-6-[_lbAge]-6-[_lbHeight]->=0-|" options:0 metrics:nil views:views];
    [_OrderInfoBg addConstraints:constraintsAcctionArray];
    [_OrderInfoBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_photoImg(52)]-22-[_btnAddress]->=10-|" options:0 metrics:nil views:views]];
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=10-[_statusImgv]-20-|" options:0 metrics:nil views:views]];

    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[FootView]-0-|" options:0 metrics:nil views:views]];
    //v方向

    orderPriceConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_lbOrderNum]-15-[_line1(0.6)]-10-[_lbServiceContent]-8-[_lbDetailServiceTime]-8-[_OrderInfoBg(120)]-11-[_lbTotalValue]-11-[FootView(17)]-0-|" options:0 metrics:nil views:views];
    [root addConstraints:orderPriceConstraints];
    [_OrderInfoBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_photoImg(52)]->=11-|" options:0 metrics:nil views:views]];
    
    [_OrderInfoBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_lbName]-4-[_btnAddress]->=11-[_lbLinkman]-16-|" options:0 metrics:nil views:views]];
    
    [root addConstraint:[NSLayoutConstraint constraintWithItem:_lbRealValue attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbServiceContent attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [root addConstraint:[NSLayoutConstraint constraintWithItem:_btnRing attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbLinkman attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[intervalV6]-0-[_btnOrderStatus(20)]-0-[intervalV7]-0-[_line1]->=0-|" options:0 metrics:nil views:views]];
    [root addConstraint:[NSLayoutConstraint constraintWithItem:intervalV7 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:intervalV6 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [root addConstraint:[NSLayoutConstraint constraintWithItem:intervalV2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:intervalV1 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [root addConstraint:[NSLayoutConstraint constraintWithItem:intervalV3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:intervalV1 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [root addConstraint:[NSLayoutConstraint constraintWithItem:_statusImgv attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_btnOrderStatus attribute:NSLayoutAttributeTop multiplier:1 constant:-3]];
    
    [root addConstraint:[NSLayoutConstraint constraintWithItem:_imgvDay attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDetailServiceTime attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [root addConstraint:[NSLayoutConstraint constraintWithItem:_imgvNight attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDetailServiceTime attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_OrderInfoBg addConstraint:[NSLayoutConstraint constraintWithItem:_sexLogo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_OrderInfoBg addConstraint:[NSLayoutConstraint constraintWithItem:_lbAge attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [_OrderInfoBg addConstraint:[NSLayoutConstraint constraintWithItem:_lbHeight attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [root addConstraint:[NSLayoutConstraint constraintWithItem:_couponInfoView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbTotalValue attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
}

- (void) SetContentWithModel:(OrderInfoModel *)model
{
    _orderModel = model;
    
    NSString *orderNum = [NSString stringWithFormat:@"NO.%@", model.serialNumber];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:orderNum];
    NSRange range = [orderNum rangeOfString:model.serialNumber];
    [attString addAttribute:NSForegroundColorAttributeName value:_COLOR(0xc2, 0xc2, 0xc2) range:range];
    
    _lbOrderNum.attributedText = attString;//@"订单号:";
    if(model.registerInfo.chineseName == nil || [model.registerInfo.chineseName isKindOfClass:[NSNull class]])
    {
        _lbLinkman.attributedText = [self AttributedString:[NSString stringWithFormat:@"下单人:  %@", model.registerInfo.phone] subString:@"下单人:"];
    }
    else
        _lbLinkman.attributedText = [self AttributedString:[NSString stringWithFormat:@"下单人:  %@    %@", model.registerInfo.chineseName, model.registerInfo.phone] subString:@"下单人:"];
    
    _btnAddress.text = model.loverinfo.addr;
    
    if(model.loverinfo.age > 0)
        _lbAge.text = [self stringByReplaceString:[NSString stringWithFormat:@"%ld岁", (long)model.loverinfo.age]];//;//@"72岁";
    else
        _lbAge.text = @"年龄";
    if(model.loverinfo.height != nil)
        _lbHeight.text = [self stringByReplaceString:[NSString stringWithFormat:@"%@cm", model.loverinfo.height]];
    else
        _lbHeight.text = @"身高";
    
    _lbName.text = model.loverinfo.name;
    if(model.loverinfo.name == nil || [model.loverinfo.name length] == 0)
        _lbName.text = @"姓名";
    
    [_photoImg sd_setImageWithURL:[NSURL URLWithString:model.loverinfo.headerImage] placeholderImage:ThemeImage(@"placeholderimage")];
    
    
    NSString *value = [NSString stringWithFormat:@"￥%d  × %@", (int)model.unitPrice, model.orderCountStr];
    NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc]initWithString:value];
    NSRange range1 = [value rangeOfString:[NSString stringWithFormat:@"  × %@", model.orderCountStr]];
//    [attString1 addAttribute:NSForegroundColorAttributeName value:_COLOR(0xc2, 0xc2, 0xc2) range:range1];
    [attString1 addAttribute:NSFontAttributeName value:_FONT(12) range:range1];
    
    _lbRealValue.attributedText = attString1;
    NSMutableAttributedString *totalValue = [self AttributedStringFromString:[NSString stringWithFormat:@"实付:￥%.0f", model.realyTotalPrice] subString:[NSString stringWithFormat:@"￥%.0f", model.realyTotalPrice]];
    [totalValue addAttribute:NSFontAttributeName value:_FONT(12) range:NSMakeRange(0, 3)];
    _lbTotalValue.attributedText = totalValue;//
    [_couponInfoView SetCouponValue:model.couponsAmount];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbOrderNum, _btnOrderStatus, _line1, _lbServiceContent, _lbTotalValue, _imgvDay, _imgvNight, _lbDetailServiceTime, _lbLinkman, _btnRing, _line2, _photoImg, _lbName, _sexLogo, _lbAge, _btnAddress, _statusImgv, intervalV1, intervalV2, intervalV3, intervalV5, FootView, intervalV6, intervalV7, _lbHeight, _lbRealValue, _couponInfoView);
    
    UIView *root = self.contentView;
    
    [root removeConstraints:constraintsAcctionArray];
    NSString *sex = [Util SexImagePathWith:[Util GetSexByName:model.loverinfo.sex]];
    
    if(sex == nil){
        constraintsAcctionArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_photoImg]-22-[_lbName]-6-[_lbAge]-6-[_lbHeight]->=0-|" options:0 metrics:nil views:views];
        _sexLogo.hidden = YES;
    }
    else{
        constraintsAcctionArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_photoImg]-22-[_lbName]-6-[_sexLogo]-6-[_lbAge]-6-[_lbHeight]->=0-|" options:0 metrics:nil views:views];
        _sexLogo.image = ThemeImage(sex);
        _sexLogo.hidden = NO;
    }
    [root addConstraints:constraintsAcctionArray];
    
    _lbDetailServiceTime.text = [Util GetOrderServiceTime:[Util convertDateFromDateString:model.beginDate] enddate:[Util convertDateFromDateString:model.endDate] datetype:model.dateType];

    _lbServiceContent.text = [NSString stringWithFormat:@"%@(%@)", model.productInfo.name, model.productInfo.typeName];
    NSString *status = @"";
    _statusImgv.hidden = YES;
    
    [root removeConstraints:couponConstraints];
    if(model.couponsAmount <= 0){
        couponConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=22-[_lbTotalValue]-19-|" options:0 metrics:nil views:views];
        _couponInfoView.hidden = YES;
    }
    else{
        couponConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=22-[_lbTotalValue]-4-[_couponInfoView]-19-|" options:0 metrics:nil views:views];
        _couponInfoView.hidden = NO;
    }
    [root addConstraints:couponConstraints];
    
    _btnOrderStatus.userInteractionEnabled = NO;
    UIImage *imageNormal = [Util imageWithColor:_COLOR(26, 147, 251) size:CGSizeMake(5, 5)];
    UIImage *imageSelect = [Util imageWithColor:_COLOR(26, 147, 251) size:CGSizeMake(5, 5)];
    [_btnOrderStatus setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [_btnOrderStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    switch (model.orderStatus) {
        case EnumOrderStatusTypeNew:
            status = @"确认订单";
            _btnOrderStatus.userInteractionEnabled = YES;
            [_btnOrderStatus setBackgroundImage:imageSelect forState:UIControlStateNormal];
            [_btnOrderStatus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case EnumOrderStatusTypeConfirm:
            status = @"已预约";
            break;
        case EnumOrderStatusTypeServing:
            status = @"服务中";
            break;
        case EnumOrderStatusTypeFinish:{
            if(model.payStatus == EnumTypeNopay){
                status = @"待付款";
            }else if (model.commentStatus == EnumTypeNoComment){
                status = @"待评价";
            }else{
                status = @"服务完成";
                _statusImgv.hidden = NO;
            }
        }
            break;
        case EnumOrderStatusTypeCancel:
            status = @"已取消";
            break;
        default:
            break;
    }
    
    [_btnOrderStatus setTitle:status forState:UIControlStateNormal];
}

- (NSString *) stringByReplaceString:(NSString *)oldString
{
    return [oldString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
}

- (void) doBtnClicked:(UIButton*)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否接单？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alert.tag = 13;
    [alert show];
}

- (void)btnRingClicked{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您确定要拨打电话吗?" message:_orderModel.registerInfo.phone delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView setTag:12];
    [alertView show];
}

#pragma alertdelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 12) {
        if (buttonIndex==0) {
            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_orderModel.registerInfo.phone]];
            [[UIApplication sharedApplication] openURL:phoneURL];
        }
    }else if (alertView.tag == 13){
        if(buttonIndex == 0){
            NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
            
            [parmas setObject:_orderModel.orderId forKey:@"orderId"];
            [parmas setObject:[UserModel sharedUserInfo].userId forKey:@"currentUserId"];
            
            __weak OrderListCell *weakelf = self;
            [LCNetWorkBase postWithMethod:@"api/order/confirm" Params:parmas Completion:^(int code, id content) {
                if(code){
                    if([content objectForKey:@"code"] == nil){
                        _orderModel.orderStatus = EnumOrderStatusTypeConfirm;
                        [weakelf SetContentWithModel:_orderModel];
                        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_OrderInfo_Refresh object:nil];
                    }
                }
            }];
        }
    }
}

- (NSMutableAttributedString *)AttributedStringFromString:(NSString*)string subString:(NSString *)subString
{
    NSString *UnitPrice = string;//@"单价：¥300.00（24h） x 1天";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:UnitPrice];
    NSRange range = [UnitPrice rangeOfString:subString];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
//    [attString addAttribute:NSFontAttributeName value:_FONT(22) range:range];
    return attString;
}

- (NSMutableAttributedString *)AttributedString:(NSString*)string subString:(NSString *)subString
{
    NSString *UnitPrice = string;//@"单价：¥300.00（24h） x 1天";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:UnitPrice];
    NSRange range = [UnitPrice rangeOfString:subString];
    [attString addAttribute:NSForegroundColorAttributeName value:_COLOR(0x3d, 0x3d, 0x3d) range:range];
    return attString;
}

@end
