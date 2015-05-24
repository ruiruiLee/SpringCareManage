//
//  PickImgScrollView.m
//
//  Created by forrestlee on 14-1-10.
//  Copyright (c) 2014年 inphase. All rights reserved.
//

#import "PickImgScrollView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "define.h"

#define kImageButtonTag 100
#define MAXIMAGECOUNT 9
//上传图片压缩比例大小
#define imgCompressSize CGSizeMake(1024, 1024)
@implementation PickImgScrollView

- (void) dealloc
{
    if(_cameraView)
        [_cameraView removeFromSuperview];
}

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
        __weak PickImgScrollView *weakSelf = self;
        [[ELCPickerHelper sharedElcPickerHelper] defineDeleget:self];
        [[ELCPickerHelper sharedElcPickerHelper] openELImagePicker:_parentController
          maxImageCount:MAXIMAGECOUNT - _selectImgArray.count
            completion:^(NSArray *imageArray) {
                if (imageArray.count) {
                    for (UIImage *image in imageArray) {
                        @autoreleasepool {
                              [weakSelf addImageToUploadArray:image index:weakSelf.selectImgArray.count];
                          }
                        }
                }
            }];

        
    }else if (buttonIndex == 1) //调用相机
    {
//        [self openCamera:_parentController allowEdit:NO completion:nil];
        [self launchCamera:nil];
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
            __weak UIButton *weakButton = cameraButton;
            __weak UIScrollView *weakScrollView = imageScrollView;
            __weak PickImgScrollView *weakSelf = self;
            [UIView animateWithDuration:0.2f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 weakButton.frame = CGRectMake(weakButton.frame.origin.x + (weakButton.frame.size.width)+1,
                                                                 weakButton.frame.origin.y,
                                                                 weakButton.frame.size.width,
                                                                 weakButton.frame.size.height);
                             } completion:^(BOOL finished) {
                                 if (weakSelf.selectImgArray.count>5) {
                                     [weakScrollView setContentOffset:CGPointMake(weakScrollView.contentSize.width-weakScrollView.bounds.size.width, 0) animated:YES];

             
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
    __weak PickImgScrollView *weakSelf = self;
    __weak UIButton *weakButton = cameraButton;
    __weak UIScrollView *weakScrollView = imageScrollView;
    [UIView animateWithDuration:0.15f
              delay:0.0f
            options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             btn.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
         } completion:^(BOOL finished) {
             [btn removeFromSuperview];
             [weakSelf.selectImgArray removeObjectAtIndex:index];
             weakScrollView.contentSize = CGSizeMake(MAX(weakScrollView.frame.size.width+1, (weakButton.frame.size.width+1)*(weakSelf.selectImgArray.count+1)), weakScrollView.contentSize.height);
             weakButton.frame = CGRectMake(weakButton.frame.origin.x - (weakButton.frame.size.width + 1),
                                             weakButton.frame.origin.y,
                                             weakButton.frame.size.width,
                                             weakButton.frame.size.height);
             [UIView animateWithDuration:0.15f
                   delay:0.0f
                 options:UIViewAnimationOptionCurveEaseInOut
              animations:^{
                  for (int i = 0; i < arrayCount; i++) {
                      @autoreleasepool {
                      UIButton* subBtn = (UIButton*)[weakScrollView viewWithTag:kImageButtonTag+i];
                      if (subBtn.tag > index+kImageButtonTag) {
                          subBtn.frame = CGRectMake(subBtn.frame.origin.x - (weakButton.frame.size.width +1),
                                                    subBtn.frame.origin.y,
                                                    subBtn.frame.size.width,
                                                    subBtn.frame.size.height);
                          subBtn.tag--;
                      }
                    }
                  }
               
              } completion:^(BOOL finished) {
                [weakSelf dismissViewConttroller];
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
    @autoreleasepool{
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
}

- (void)launchCamera:(id)sender {
    
    //Set white status bar
    
    //Instantiate the camera view & assign its frame
    if(_cameraView == nil){
        _cameraView = [[CameraSessionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT)];
        
        //Set the camera view's delegate and add it as a subview
        _cameraView.delegate = self;
        
        //Apply animation effect to present the camera view
        CATransition *applicationLoadViewIn =[CATransition animation];
        [applicationLoadViewIn setDuration:0.6];
        [applicationLoadViewIn setType:kCATransitionReveal];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [[_cameraView layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    }
    
    [_parentController.view addSubview:_cameraView];
    
    //____________________________Example Customization____________________________
    //[_cameraView setTopBarColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha: 0.64]];
    //[_cameraView hideFlashButton]; //On iPad flash is not present, hence it wont appear.
    //[_cameraView hideCameraToogleButton];
    //[_cameraView hideDismissButton];
}

-(void)didCaptureImage:(UIImage *)image {
    NSLog(@"CAPTURED IMAGE");
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self.cameraView removeFromSuperview];
     UIImage* newImage = [self fitSmallImage:image scaledToSize:imgCompressSize];
    image = nil;
    [self addImageToUploadArray:newImage index:_selectImgArray.count];
}

-(void)didCaptureImageWithData:(NSData *)imageData {
    NSLog(@"CAPTURED IMAGE DATA");
    //UIImage *image = [[UIImage alloc] initWithData:imageData];
    //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    //[self.cameraView removeFromSuperview];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //Show error alert if image could not be saved
    if (error) [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


/*
#pragma mark- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //原图 ：UIImagePickerControllerOriginalImage  裁剪的图：UIImagePickerControllerEditedImage
    NSData *imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],0.5f);
    [_parentController dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [UIImage imageWithData:imageData];
    [NSThread detachNewThreadSelector:@selector(useImage:) toTarget:self withObject:image];
    image = nil;
}

- (void)useImage:(UIImage *)image {
//    @autoreleasepool{
    // Create a graphics image context
        // Get the new image from the context
        UIImage* newImage = [self fitSmallImage:image scaledToSize:imgCompressSize];
        // End the context
        
        [self addImageToUploadArray:newImage index:_selectImgArray.count];
        [self dismissViewConttroller];
//    }
}


#pragma mark- UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
     [self dismissViewConttroller];
    [_parentController dismissViewControllerAnimated:YES completion:nil];
   
}


- (void)openCamera:(UIViewController*)currentViewController allowEdit:(BOOL)allowEdit completion:(void (^)(void))completion
{
    if(imagePicker == nil){
        imagePicker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.delegate      = (id)self;
            imagePicker.allowsEditing = allowEdit;
            imagePicker.sourceType    = UIImagePickerControllerSourceTypeCamera;
        }
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [currentViewController presentViewController:imagePicker animated:YES completion:completion];
    }

}*/



@end
