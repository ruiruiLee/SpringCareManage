//
//  ELCPickerHelper.m
//  EducationVersion
//
//  Created by forrestlee on 13-10-24.
//  Copyright (c) 2013年 share. All rights reserved.
//

#import "ELCPickerHelper.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"


@interface ELCPickerHelper()<ELCImagePickerControllerDelegate>
@property (assign, nonatomic) id<DelegateDismissPick> deleget;
@property (nonatomic, copy) ELCBlock elcBlock;
@property (nonatomic, strong) UIViewController *viewController;
@end

@implementation ELCPickerHelper
  static ELCPickerHelper *elcPickerHelper = nil;
+ (id)sharedElcPickerHelper {
  
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        elcPickerHelper = [[ELCPickerHelper alloc] init];

    });
    return elcPickerHelper;
}

-(void)defineDeleget:(id)deleget
{
    elcPickerHelper.deleget=deleget;
}
- (void)openELImagePicker:(UIViewController*)currentViewController
            maxImageCount:(int)maxImageCount
               completion:(void(^)(NSArray *imageArray))completion{
    
    self.elcBlock = completion;
    self.viewController = currentViewController;
    
    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:nil bundle:nil];
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
    elcPicker.maximumImagesCount = maxImageCount;
    [albumController setParent:elcPicker];
    [elcPicker setDelegate:self];
    
    [currentViewController presentViewController:elcPicker animated:YES completion:nil];
}


- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    if (self.viewController) {
        if ([_deleget respondsToSelector:@selector(dismissViewConttroller)]) {
            [_deleget dismissViewConttroller];
        }
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
        self.viewController = nil;
    }
    if (self.elcBlock) {
        NSMutableArray *imageInfoArray = [NSMutableArray arrayWithCapacity:[info count]];
        for(NSDictionary *dict in info) {
            UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
            [imageInfoArray addObject:image];
        }
        self.elcBlock(imageInfoArray);
        self.elcBlock = nil;
    }
}
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    if (self.viewController) {
        if ([_deleget respondsToSelector:@selector(dismissViewConttroller)]) {
           [_deleget dismissViewConttroller];
        }
       [self.viewController dismissViewControllerAnimated:YES completion:nil];
        self.viewController = nil;
       
    }
}

@end
