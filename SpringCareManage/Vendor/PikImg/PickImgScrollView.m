//
//  PickImgScrollView.m
//
//  Created by forrestlee on 14-1-10.
//  Copyright (c) 2014年 inphase. All rights reserved.
//

#import "PickImgScrollView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#define kImageButtonTag 100
#define MAXIMAGECOUNT 9
//上传图片压缩比例大小
#define imgCompressSize CGSizeMake(1024, 1024)
@implementation PickImgScrollView


- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        myframe=self.bounds;
        [self baseInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        myframe = frame;
        [self baseInit];

    }
    return self;
}

-(void) baseInit {
    self.userInteractionEnabled=YES;
    _selectImgArray = [[NSMutableArray alloc]init];
    imageScrollView = [[UIScrollView alloc] initWithFrame:myframe];
    imageScrollView.scrollEnabled=YES;
    imageScrollView.userInteractionEnabled=YES;
    imageScrollView.backgroundColor = [UIColor clearColor];
    imageScrollView.showsVerticalScrollIndicator = NO;
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.bounces = YES;
    cameraButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.frame= CGRectMake(0,0,50,50);
    [cameraButton setImage: [UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:nil
                                          delegate:self
                                 cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [imageScrollView addSubview:cameraButton];
    [self addSubview:imageScrollView];

}

- (void)cameraButtonPressed:(id)sender {
    if (_selectImgArray.count==MAXIMAGECOUNT) {
        alertView.message=@"最多选择9张图片";
        [alertView show];
        return;
    }
    
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:NSLocalizedString(@"从手机相册选择",nil)
                                           otherButtonTitles:NSLocalizedString(@"拍照",nil), nil];
    ac.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [ac showInView:self.window];
}

#pragma mark DelegateDismissPick
- (void)dismissViewConttroller
{
    if ([_delegate respondsToSelector:@selector(imagePickerControllerDissMethod)]){
        [_delegate imagePickerControllerDissMethod];
    }
}
//选择图片
#define MAXIMAGECOUNT 9
#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[ELCPickerHelper sharedElcPickerHelper] defineDeleget:self];
        [[ELCPickerHelper sharedElcPickerHelper] openELImagePicker:_parentController
          maxImageCount:MAXIMAGECOUNT - _selectImgArray.count
            completion:^(NSArray *imageArray) {
                if (imageArray.count) {
                    for (UIImage *image in imageArray) {
                        @autoreleasepool {
                              [self addImageToUploadArray:image index:_selectImgArray.count];
                          }
                        }
                }
            }];

        
    }else if (buttonIndex == 1) //调用相机
    {
        [self openCamera:_parentController allowEdit:NO completion:nil];
    }
    else{
        
    }
}


- (void)addImageToUploadArray:(UIImage*)image index:(NSInteger)i{
   
        [_selectImgArray addObject:image];
        NSInteger arrayCount = _selectImgArray.count;
        UIButton* btn = (UIButton*)[imageScrollView viewWithTag:kImageButtonTag + i];
        if (btn == nil) {
            btn = [[UIButton alloc] initWithFrame:CGRectMake(cameraButton.frame.origin.x ,
                                                             cameraButton.frame.origin.y,
                                                             cameraButton.frame.size.width,
                                                             cameraButton.frame.size.height)];
            btn.clipsToBounds = YES;
            btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            btn.tag = kImageButtonTag + i;
            [btn setImage:[_selectImgArray objectAtIndex:i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(intoPhotoBrowser:) forControlEvents:UIControlEventTouchUpInside];
            //btn长按事件
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
            longPress.minimumPressDuration = 0.8; //定义按的时间
            [btn addGestureRecognizer:longPress];
            //btn长按事件
            [imageScrollView addSubview:btn];
            imageScrollView.contentSize = CGSizeMake(MAX(imageScrollView.frame.size.width+1,(cameraButton.frame.size.width+1)*(arrayCount+1)), imageScrollView.contentSize.height);
            [UIView animateWithDuration:0.2f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 cameraButton.frame = CGRectMake(cameraButton.frame.origin.x + (cameraButton.frame.size.width)+1,
                                                                 cameraButton.frame.origin.y,
                                                                 cameraButton.frame.size.width,
                                                                 cameraButton.frame.size.height);
                             } completion:^(BOOL finished) {
                                 if (_selectImgArray.count>5) {
                                     [imageScrollView setContentOffset:CGPointMake(imageScrollView.contentSize.width-imageScrollView.bounds.size.width, 0) animated:YES];

             
                                 }

                             }];
          }
}

- (void)intoPhotoBrowser:(id)sender {
    _photoBrowser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    _photoBrowser.displayDeleteButton = YES;
    UIButton* btn = (UIButton*)sender;
    [_photoBrowser setCurrentPhotoIndex:btn.tag - kImageButtonTag];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:_photoBrowser];
    navigation.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [_parentController presentViewController:navigation animated:YES completion:nil];
}

-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        NSInteger index =gestureRecognizer.view.tag- kImageButtonTag;
        [self deleteImageButtonAtIndex:index];
    }
}
- (void) deleteImageButtonAtIndex: (NSInteger)index {
    NSInteger arrayCount = _selectImgArray.count;
    UIButton* btn = (UIButton*)[imageScrollView viewWithTag:index+kImageButtonTag];
    [UIView animateWithDuration:0.15f
              delay:0.0f
            options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             btn.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
         } completion:^(BOOL finished) {
             [btn removeFromSuperview];
             [_selectImgArray removeObjectAtIndex:index];
             imageScrollView.contentSize = CGSizeMake(MAX(imageScrollView.frame.size.width+1, (cameraButton.frame.size.width+1)*(_selectImgArray.count+1)), imageScrollView.contentSize.height);
             cameraButton.frame = CGRectMake(cameraButton.frame.origin.x - (cameraButton.frame.size.width + 1),
                                             cameraButton.frame.origin.y,
                                             cameraButton.frame.size.width,
                                             cameraButton.frame.size.height);
             [UIView animateWithDuration:0.15f
                   delay:0.0f
                 options:UIViewAnimationOptionCurveEaseInOut
              animations:^{
                  for (int i = 0; i < arrayCount; i++) {
                      @autoreleasepool {
                      UIButton* subBtn = (UIButton*)[imageScrollView viewWithTag:kImageButtonTag+i];
                      if (subBtn.tag > index+kImageButtonTag) {
                          subBtn.frame = CGRectMake(subBtn.frame.origin.x - (cameraButton.frame.size.width +1),
                                                    subBtn.frame.origin.y,
                                                    subBtn.frame.size.width,
                                                    subBtn.frame.size.height);
                          subBtn.tag--;
                      }
                    }
                  }
               
              } completion:^(BOOL finished) {
                [self dismissViewConttroller];
              }];
         }];
}


#pragma mark -
#pragma mark MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [_selectImgArray count];
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < [_selectImgArray count])
    {
        MWPhoto *photo = [MWPhoto photoWithImage:[_selectImgArray objectAtIndex:index]];
        return photo;
    }
    return nil;
}

- (void)deletePhoto:(MWPhotoBrowser *)photoBrowser deletePhotoIndex:(NSUInteger)index {
    [self deleteImageButtonAtIndex:index];
}

-(UIImage *)fitSmallImage:(UIImage *)image scaledToSize:(CGSize)tosize
{
    if (!image)
    {
        return nil;
    }
    if (image.size.width<tosize.width && image.size.height<tosize.height)
    {
        return image;
    }
    CGFloat wscale = image.size.width/tosize.width;
    CGFloat hscale = image.size.height/tosize.height;
    CGFloat scale = (wscale>hscale)?wscale:hscale;
    CGSize newSize = CGSizeMake(image.size.width/scale, image.size.height/scale);
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
    [image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

#pragma mark- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //原图 ：UIImagePickerControllerOriginalImage  裁剪的图：UIImagePickerControllerEditedImage
    NSData *imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],1.0);
    UIImage *image = [UIImage imageWithData:imageData];
    image = [self fitSmallImage:image scaledToSize:imgCompressSize];
    [self addImageToUploadArray:image index:_selectImgArray.count];
     [self dismissViewConttroller];
    [_parentController dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
     [self dismissViewConttroller];
    [_parentController dismissViewControllerAnimated:YES completion:nil];
   
}


- (void)openCamera:(UIViewController*)currentViewController allowEdit:(BOOL)allowEdit completion:(void (^)(void))completion
{
    UIImagePickerController  *picker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        picker.delegate      = (id)self;
        picker.allowsEditing = allowEdit;
        picker.sourceType    = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
  
        [currentViewController presentViewController:picker animated:YES completion:completion];
    }
}



@end
