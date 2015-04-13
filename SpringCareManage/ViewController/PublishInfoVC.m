//
//  PublishInfoVC.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "PublishInfoVC.h"
#import "define.h"

@interface PublishInfoVC ()

@end

@implementation PublishInfoVC
@synthesize photoView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.NavigationBar.btnRight setImage:[UIImage imageNamed:@"submit"] forState:UIControlStateNormal];
    [self initSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initSubviews
{
    _bgView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.ContentView addSubview:_bgView];
    _bgView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _tvContent = [[PlaceholderTextView alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_tvContent];
    _tvContent.translatesAutoresizingMaskIntoConstraints = NO;
    _tvContent.placeholder = @"记下你的记录......";
    
    _btnRecord = [[UIButton alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_btnRecord];
    _btnRecord.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnRecord setImage:[UIImage imageNamed:@"recording"] forState:UIControlStateNormal];
    
    _btnTargetSelect = [[UIButton alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_btnTargetSelect];
    _btnTargetSelect.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnTargetSelect setTitle:@"同时发布到我的护理日志" forState:UIControlStateNormal];
    [_btnTargetSelect setImage:[UIImage imageNamed:@"paytypenoselect"] forState:UIControlStateNormal];
    [_btnTargetSelect setImage:[UIImage imageNamed:@"paytypeselected"] forState:UIControlStateSelected];
    [_btnTargetSelect addTarget:self action:@selector(doBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_btnTargetSelect setTitleColor:_COLOR(0x99, 0x99, 0x99) forState:UIControlStateNormal];
    _btnTargetSelect.titleLabel.font = _FONT(15);
    
    _line = [[UILabel alloc] initWithFrame:CGRectZero];
    [_bgView addSubview:_line];
    _line.translatesAutoresizingMaskIntoConstraints = NO;
    _line.backgroundColor = SeparatorLineColor;
    
    photoView = [[MessagePhotoView alloc]initWithFrame:CGRectMake(0.0f,
                                                                       CGRectGetHeight(self.view.frame),
                                                                       CGRectGetWidth(self.view.frame), 216)];
    [self.ContentView addSubview:photoView];
    photoView.delegate = self;
    photoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_bgView, _tvContent, _btnTargetSelect, _btnRecord, _line, photoView);
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bgView]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_bgView]-0-[photoView]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[photoView]-0-|" options:0 metrics:nil views:views]];
    
    
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_tvContent]-10-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_btnTargetSelect]->=10-[_btnRecord]-20-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_line]-0-|" options:0 metrics:nil views:views]];
    [_bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_tvContent(120)]-5-[_btnRecord]-10-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    [self.ContentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnTargetSelect attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_btnRecord attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (void) doBtnSelected:(UIButton*)sender
{
    sender.selected = !sender.selected;
}

//- (void)sharePhotoview
//{
//    if (!self.photoView)
//    {
//        self.photoView = [[MessagePhotoView alloc]initWithFrame:CGRectMake(0.0f,
//                                                                           CGRectGetHeight(self.view.frame),
//                                                                           CGRectGetWidth(self.view.frame), 216)];
//        [self.view addSubview:self.photoView];
//        self.photoView.delegate = self;
//        
//        
//    }
//}

//实现代理方法
-(void)addPicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
}

@end
