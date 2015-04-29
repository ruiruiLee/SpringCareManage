//
//  PickImgScrollView.h
//  强哥独创 自定义相册多选scrollview
//
//  Created by forrestlee on 14-1-10.
//  Copyright (c) 2014年 inphase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "ELCPickerHelper.h"

@protocol PickImgEndDelegate<NSObject>
@optional
- (void) imagePickerControllerDissMethod;
@end

@interface PickImgScrollView : UIView<UIActionSheetDelegate,MWPhotoBrowserDelegate,DelegateDismissPick>

{
    UIScrollView *imageScrollView;
    UIButton *cameraButton;
    UIAlertView   *alertView;
    CGRect myframe;
    MWPhotoBrowser *_photoBrowser;
}
@property (nonatomic,assign) id <PickImgEndDelegate> delegate;
@property (strong, nonatomic) UIViewController *parentController;
@property (strong,nonatomic,readonly) NSMutableArray *selectImgArray;

@end