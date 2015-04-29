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
    return lb;
}

- (void) initSubviews
{
    _lbOrderNum = [self createLabel:_FONT(14) txtColor:_COLOR(0x66, 0x66, 0x66)];
    
    _lbPublishTime = [self createLabel:_FONT(14) txtColor:_COLOR(0x66, 0x66, 0x66)];
    
    _lbOrderStatus = [self createLabel:_FONT(15) txtColor:_COLOR(0x10, 0x9d, 0x59)];
    
    _line1 = [self createLabel:_FONT(15) txtColor:_COLOR(0x10, 0x9d, 0x59)];
    _line1.backgroundColor = SeparatorLineColor;
    
    _lbServiceContent = [self createLabel:_FONT(15) txtColor:_COLOR(0x66, 0x66, 0x66)];
    
    _lbTotalValue = [self createLabel:_FONT(18) txtColor:_COLOR(0xec, 0x5a, 0x4d)];
    
    _imgvDay = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imgvDay];
    _imgvDay.translatesAutoresizingMaskIntoConstraints = NO;
    
    _imgvNight = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imgvNight];
    _imgvNight.translatesAutoresizingMaskIntoConstraints = NO;
    
    _lbDetailServiceTime = [self createLabel:_FONT(15) txtColor:_COLOR(0x66, 0x66, 0x66)];
    
    _lbLinkman = [self createLabel:_FONT(15) txtColor:_COLOR(0x66, 0x66, 0x66)];
    
    _btnRing = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnRing];
    _btnRing.translatesAutoresizingMaskIntoConstraints = NO;
//    _btnRing.imageView = ThemeImage(@"userattentionring");
    [_btnRing setImage:ThemeImage(@"userattentionring") forState:UIControlStateNormal];
    
    _line2 = [self createLabel:_FONT(15) txtColor:_COLOR(0x10, 0x9d, 0x59)];
    _line2.backgroundColor = SeparatorLineColor;
    
    //对象信息
    _photoImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_photoImg];
    _photoImg.translatesAutoresizingMaskIntoConstraints = NO;
    _photoImg.layer.cornerRadius = 26;
    _photoImg.clipsToBounds = YES;
    
    _lbName = [self createLabel:_FONT(18) txtColor:_COLOR(0x22, 0x22, 0x22)];
    
    _lbRelationship = [self createLabel:_FONT(15) txtColor:_COLOR(0x66, 0x66, 0x66)];
    
    _lbAge = [self createLabel:_FONT(15) txtColor:_COLOR(0x66, 0x66, 0x66)];
    
    _btnMobile = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnMobile];
    _btnMobile.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnMobile setImage:[UIImage imageNamed:@"orderdetailtel"] forState:UIControlStateNormal];
    [_btnMobile setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    _btnMobile.titleLabel.font = _FONT(15);
    
    _btnAddress = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnAddress];
    _btnAddress.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnAddress setImage:[UIImage imageNamed:@"nurselistlocation"] forState:UIControlStateNormal];
    [_btnAddress setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    _btnAddress.titleLabel.font = _FONT(15);
    
    _sexLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_sexLogo];
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
    
    intervalV4 = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:intervalV4];
    intervalV4.translatesAutoresizingMaskIntoConstraints = NO;
    
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
    FootView.backgroundColor = TableBackGroundColor;
    
    [self createAutoLayoutConstraints];
}

- (void) createAutoLayoutConstraints
{
    UIView *root = self.contentView;
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbOrderNum, _lbPublishTime, _lbOrderStatus, _line1, _lbServiceContent, _lbTotalValue, _imgvDay, _imgvNight, _lbDetailServiceTime, _lbLinkman, _btnRing, _line2, _photoImg, _lbName, _lbRelationship, _sexLogo, _lbAge, _btnMobile, _btnAddress, _statusImgv, intervalV1, intervalV2, intervalV3, intervalV4, intervalV5, FootView, intervalV6, intervalV7);
    
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_lbOrderNum]->=20-[_lbOrderStatus]-19-|" options:0 metrics:nil views:views]];
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_lbPublishTime]->=20-[_lbOrderStatus]-19-|" options:0 metrics:nil views:views]];
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_line1]-0-|" options:0 metrics:nil views:views]];
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_lbServiceContent]->=10-[_lbTotalValue]-19-|" options:0 metrics:nil views:views]];
    constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_imgvDay]-0-[_imgvNight]-0-[_lbDetailServiceTime]->=50-|" options:0 metrics:nil views:views];
    [root addConstraints:constraintsArray];
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_lbLinkman]->=20-[_btnRing]->=0-|" options:0 metrics:nil views:views]];
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_line2]-0-|" options:0 metrics:nil views:views]];
    constraintsAcctionArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_photoImg]-22-[_lbName]-6-[_sexLogo]-6-[_lbAge]->=0-|" options:0 metrics:nil views:views];
    [root addConstraints:constraintsAcctionArray];
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_photoImg(52)]-22-[_btnMobile]->=20-|" options:0 metrics:nil views:views]];
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_photoImg(52)]-22-[_btnAddress]->=20-|" options:0 metrics:nil views:views]];
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=10-[_statusImgv]-20-|" options:0 metrics:nil views:views]];
    [root addConstraint:[NSLayoutConstraint constraintWithItem:_btnRing attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_lbTotalValue attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [root addConstraint:[NSLayoutConstraint constraintWithItem:_lbRelationship attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_photoImg attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[FootView]-0-|" options:0 metrics:nil views:views]];
    //v方向
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_lbOrderNum]-4-[_lbPublishTime]-10-[_line1(1)]-10-[_lbServiceContent]-8-[_lbDetailServiceTime]-8-[_lbLinkman]-10-[_line2(1)]-6-[_photoImg(52)]-4-[_lbRelationship]-10-[FootView(17)]-0-|" options:0 metrics:nil views:views]];
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_line2]-6-[_lbName]-0-[intervalV4]-0-[_btnMobile]-0-[intervalV5]-0-[_btnAddress]->=0-|" options:0 metrics:nil views:views]];
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_line1]-0-[intervalV1]-0-[_lbTotalValue]-0-[intervalV2]-0-[_btnRing]-0-[intervalV3]-0-[_line2]->=0-|" options:0 metrics:nil views:views]];
    
    [root addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[intervalV6]-0-[_lbOrderStatus]-0-[intervalV7]-0-[_line1]->=0-|" options:0 metrics:nil views:views]];
    [root addConstraint:[NSLayoutConstraint constraintWithItem:intervalV7 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:intervalV6 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [root addConstraint:[NSLayoutConstraint constraintWithItem:intervalV2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:intervalV1 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [root addConstraint:[NSLayoutConstraint constraintWithItem:intervalV3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:intervalV1 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [root addConstraint:[NSLayoutConstraint constraintWithItem:intervalV5 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:intervalV4 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [root addConstraint:[NSLayoutConstraint constraintWithItem:_statusImgv attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_lbOrderStatus attribute:NSLayoutAttributeTop multiplier:1 constant:-3]];
    
    [root addConstraint:[NSLayoutConstraint constraintWithItem:_imgvDay attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDetailServiceTime attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [root addConstraint:[NSLayoutConstraint constraintWithItem:_imgvNight attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbDetailServiceTime attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [root addConstraint:[NSLayoutConstraint constraintWithItem:_btnAddress attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbRelationship attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [root addConstraint:[NSLayoutConstraint constraintWithItem:_sexLogo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [root addConstraint:[NSLayoutConstraint constraintWithItem:_lbAge attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
}

- (void) SetContentWithModel:(OrderInfoModel *)model
{
    _lbOrderNum.text = [NSString stringWithFormat:@"订单号:%@", model.serialNumber];//@"订单号:";
    _lbPublishTime.text = [NSString stringWithFormat:@"下单时间:%@", model.createdDate];//@"2015-03-19 12:46";//下单时间
    _lbLinkman.text = [NSString stringWithFormat:@"联系人:%@", model.registerInfo.chineseName];//@"联系人:";
    [_btnAddress setTitle:model.loverinfo.addr forState:UIControlStateNormal];//陪护对象地址
    [_btnMobile setTitle:model.loverinfo.phone forState:UIControlStateNormal];//陪护对象电话
    
    _lbAge.text = [self stringByReplaceString:[NSString stringWithFormat:@"%ld岁", (long)model.loverinfo.age]];//;//@"72岁";
    
    _lbName.text = model.loverinfo.name;//@"张发财";
    if(model.loverinfo.name == nil || [model.loverinfo.name length] == 0)
        _lbName.text = @"姓名";
    _lbRelationship.text = model.loverinfo.nickname;//@"父亲";
    
    [_photoImg sd_setImageWithURL:[NSURL URLWithString:model.loverinfo.headerImage] placeholderImage:ThemeImage(@"placeholderimage")];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbOrderNum, _lbPublishTime, _lbOrderStatus, _line1, _lbServiceContent, _lbTotalValue, _imgvDay, _imgvNight, _lbDetailServiceTime, _lbLinkman, _btnRing, _line2, _photoImg, _lbName, _lbRelationship, _sexLogo, _lbAge, _btnMobile, _btnAddress, _statusImgv, intervalV1, intervalV2, intervalV3, intervalV4, intervalV5, FootView, intervalV6, intervalV7);
    UIView *root = self.contentView;
    [root removeConstraints:constraintsArray];
    ServiceTimeType type = [Util GetServiceTimeType:[Util convertDateFromDateString:model.beginDate]];
    constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_imgvDay(18)]-0-[_imgvNight(18)]-0-[_lbDetailServiceTime]->=50-|" options:0 metrics:nil views:views];
    if(type == EnumServiceTimeNight){
        _imgvNight.image = ThemeImage(@"night");
        _imgvDay.image = nil;
        constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_imgvNight(18)]-0-[_lbDetailServiceTime]->=50-|" options:0 metrics:nil views:views];
    }
    else if (type == EnumServiceTimeDay){
        _imgvNight.image = nil;
        _imgvDay.image = ThemeImage(@"daytime");
        constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_imgvDay(18)]-0-[_lbDetailServiceTime]->=50-|" options:0 metrics:nil views:views];
    }
    else{
        _imgvNight.image = ThemeImage(@"night");
        _imgvDay.image = ThemeImage(@"daytime");
    }
    
    [root addConstraints:constraintsArray];
    
    [root removeConstraints:constraintsAcctionArray];
    NSString *sex = [Util SexImagePathWith:[Util GetSexByName:model.loverinfo.sex]];
    if(sex == nil){
        constraintsAcctionArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_photoImg]-22-[_lbName]-6-[_lbAge]->=0-|" options:0 metrics:nil views:views];
    }
    else{
        constraintsAcctionArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[_photoImg]-22-[_lbName]-6-[_sexLogo]-6-[_lbAge]->=0-|" options:0 metrics:nil views:views];
    }
    [root addConstraints:constraintsAcctionArray];
    
    _lbDetailServiceTime.text = [Util GetOrderServiceTime:[Util convertDateFromDateString:model.beginDate] enddate:[Util convertDateFromDateString:model.endDate] datetype:model.dateType];
    _lbTotalValue.text = [NSString stringWithFormat:@"¥%.0f", model.totalPrice];//@"¥180.00";
    NSString *dayString = @"";
    NSString *hourString = @"";
    DateType dateType = model.dateType;
    if(dateType == EnumTypeHalfDay){
        dayString = @"天";
        hourString = @"12";
    }else if (dateType == EnumTypeOneDay){
        dayString = @"天";
        hourString = @"24";
    }
    else if (dateType == EnumTypeOneWeek){
        dayString = @"周";
        hourString = @"24";
    }
    else if (dateType == EnumTypeOneMounth){
        dayString = @"月";
        hourString = @"24";
    }
    _lbServiceContent.text = [NSString stringWithFormat:@"%@：¥%.0f/%@h x %ld%@", model.productInfo.name, model.unitPrice, hourString, (long)model.orderCount, dayString];
    NSString *status = @"";
    _statusImgv.hidden = YES;
    switch (model.orderStatus) {
        case EnumOrderStatusTypeNew:
            status = @"确认中";
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
    _lbOrderStatus.text = status;
}

- (NSString *) stringByReplaceString:(NSString *)oldString
{
    return [oldString stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
}

@end