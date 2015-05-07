//
//  EditUserTableviewCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "EditUserTableviewCell.h"
#import "define.h"

@implementation EditUserTableviewCell
@synthesize tfEdit = _tfEdit;
@synthesize cellType;
@synthesize lbUnit;
@synthesize layoutArray;
@synthesize delegate;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)NotifyResignFirstResponder:(NSNotification *) notify
{
    [_tfEdit resignFirstResponder];
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyResignFirstResponder:) name:Notify_Resign_First_Responder object:nil];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self initSubViews];
    }
    return self;
}

- (void) initSubViews
{
    _lbTite = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbTite];
    _lbTite.font = _FONT(16);
    _lbTite.textColor = _COLOR(0x22, 0x22, 0x22);
    _lbTite.translatesAutoresizingMaskIntoConstraints = NO;
    
    _tfEdit = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_tfEdit];
    _tfEdit.font = _FONT(16);
    _tfEdit.translatesAutoresizingMaskIntoConstraints = NO;
    _tfEdit.delegate = self;
    
    _imgUnflod = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imgUnflod];
    _imgUnflod.translatesAutoresizingMaskIntoConstraints = NO;
    _imgUnflod.image = [UIImage imageNamed:@"usercentershutgray"];
    
    _lbLine = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbLine];
    _lbLine.translatesAutoresizingMaskIntoConstraints = NO;
    _lbLine.backgroundColor = SeparatorLineColor;
    
    lbUnit = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:lbUnit];
    lbUnit.font = _FONT(16);
    lbUnit.textColor = _COLOR(0x66, 0x66, 0x66);
    lbUnit.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbTite, _tfEdit, _imgUnflod, _lbLine, lbUnit);
    layoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_lbTite(96)]-10-[_tfEdit]-5-[lbUnit(30)]-10-[_imgUnflod(12)]-20-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:layoutArray];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-13-[_lbTite]-13-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-13-[lbUnit]-13-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_tfEdit]-5-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-17-[_imgUnflod(16)]-17-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=17-[_lbLine(1)]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_lbLine]-0-|" options:0 metrics:nil views:views]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) SetcontentData:(EditCellTypeData*) celldata info:(NSDictionary*) info
{
    _lbTite.text = celldata.cellTitleName;
    [_tfEdit setEnabled:YES];
    _imgUnflod.hidden = NO;
    cellType = celldata.cellType;
    lbUnit.hidden = YES;
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbTite, _tfEdit, _imgUnflod, _lbLine, lbUnit);
    [self.contentView removeConstraints:layoutArray];
    _tfEdit.textColor =  _COLOR(0x66, 0x66, 0x66);
    if(celldata.cellType == EnumTypeAccount){
        _tfEdit.textColor =  _COLOR(0x99, 0x99, 0x99);
        [_tfEdit setEnabled:NO];
        _imgUnflod.hidden = YES;
        layoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_lbTite(96)]-10-[_tfEdit]-20-|" options:0 metrics:nil views:views];
    }
    else if (celldata.cellType == EnumTypeUserName){
        _imgUnflod.hidden = YES;
        layoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_lbTite(46)]-10-[_tfEdit]-20-|" options:0 metrics:nil views:views];
    }
    else if (celldata.cellType == EnumTypeSex){
        [_tfEdit setEnabled:NO];
        _imgUnflod.hidden = NO;
        layoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_lbTite(46)]-10-[_tfEdit]-10-[_imgUnflod(12)]-20-|" options:0 metrics:nil views:views];
    }
    else if (celldata.cellType == EnumTypeAge){
        [_tfEdit setEnabled:NO];
        layoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_lbTite(46)]-10-[_tfEdit]-10-[_imgUnflod(12)]-20-|" options:0 metrics:nil views:views];
    }
    else if (celldata.cellType == EnumTypeAddress){
        _imgUnflod.hidden = YES;
        layoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_lbTite(46)]-10-[_tfEdit]-20-|" options:0 metrics:nil views:views];
        _tfEdit.placeholder = @"必须填写";
    }
    else if (celldata.cellType == EnumTypeMobile){
        _imgUnflod.hidden = YES;
        layoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_lbTite(46)]-10-[_tfEdit]-20-|" options:0 metrics:nil views:views];
        _tfEdit.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if (celldata.cellType == EnumTypeRelationName){
        _imgUnflod.hidden = YES;
        layoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_lbTite(96)]-10-[_tfEdit]-20-|" options:0 metrics:nil views:views];
        _tfEdit.placeholder = @"如父亲，母亲";
    }
    else if (celldata.cellType == EnumTypeHeight){
        _imgUnflod.hidden = YES;
        _tfEdit.keyboardType = UIKeyboardTypeNumberPad;
        lbUnit.hidden = NO;
        lbUnit.text = @"cm";
        layoutArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_lbTite(46)]-10-[_tfEdit]-5-[lbUnit(30)]-20-|" options:0 metrics:nil views:views];
        lbUnit.hidden = NO;
    }
    [self.contentView addConstraints:layoutArray];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    NSLog(@"");
    if(delegate && [delegate respondsToSelector:@selector(NotifyTextChanged:type:)]){
        [delegate NotifyTextChanged:textField.text type:self.cellType];
    }
}

@end
