//
//  ELCImagePickerController.m
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerController.h"
#import "ELCAsset.h"
#import "ELCAssetCell.h"
#import "ELCAssetTablePicker.h"
#import "ELCAlbumPickerController.h"


@implementation ELCImagePickerController

@synthesize delegate = _myDelegate;

- (void)cancelImagePicker
{
	if([_myDelegate respondsToSelector:@selector(elcImagePickerControllerDidCancel:)]) {
		[_myDelegate performSelector:@selector(elcImagePickerControllerDidCancel:) withObject:self];
	}
}

- (BOOL)shouldSelectAsset:(ELCAsset *)asset previousCount:(NSUInteger)previousCount {
    BOOL shouldSelect = previousCount < self.maximumImagesCount;
    if (!shouldSelect) {
        NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Only %d photos please!", nil), self.maximumImagesCount];
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"You can only send %d photos at a time.", nil), self.maximumImagesCount];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                            message:message
                                           delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:NSLocalizedString(@"Okay", nil), nil];
        [alert show];
        [alert release];
    }
    return shouldSelect;
}

- (void)selectedAssets:(NSArray *)assets
{
	NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
	
	for(ALAsset *asset in assets) {
        
		NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
		[workingDictionary setObject:[asset valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
        //        CGSize dimension = [assetRep dimensions];
        //        NSLog(@"%f",dimension.width);
        //        NSLog(@"%f",dimension.height);
        
        CGImageRef imgRef;
        UIImage *img;
        //        if (dimension.width/dimension.height>3.0f) {  // 宽度超长，表示全景图
        //             imgRef = [assetRep fullResolutionImage];
        //            [assetRep release];
        //             img = [CommonMethod fitSmallImage:[UIImage imageWithCGImage:imgRef
        //                                                                  scale:1.0f
        //                                                            orientation:UIImageOrientationUp] ];
        //        }
        //else{
        imgRef = [assetRep fullScreenImage];
        img= [UIImage imageWithCGImage:imgRef
                                 scale:1.0f
                           orientation:UIImageOrientationUp];
        // }
       // img=[CommonMethod fitSmallImage:img scaledToSize:imgCompressSize];
        [workingDictionary setObject:img forKey:@"UIImagePickerControllerOriginalImage"];
		[workingDictionary setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:@"UIImagePickerControllerReferenceURL"];
		
		[returnArray addObject:workingDictionary];
		[workingDictionary release];
        img=nil;
        [img dealloc];
	}
	if(_myDelegate != nil && [_myDelegate respondsToSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:)]) {
		[_myDelegate performSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:[NSArray arrayWithArray:returnArray]];
	} else {
        [self popToRootViewControllerAnimated:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    NSLog(@"ELC Image Picker received memory warning.");
    
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc
{
    NSLog(@"deallocing ELCImagePickerController");
    [super dealloc];
}

@end
