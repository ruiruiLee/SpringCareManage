//
//  MWPhoto.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 17/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "SDWebImageDecoder.h"
#import "SDWebImageManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
// Private
@interface MWPhoto () {

    BOOL _loadingInProgress;
        
}

// Properties
@property (nonatomic, strong) UIImage *underlyingImage; // holds the decompressed image

// Methods
- (void)decompressImageAndFinishLoading;
- (void)imageLoadingComplete;

@end

// MWPhoto
@implementation MWPhoto

#pragma mark Class Methods

+ (MWPhoto *)photoWithImage:(UIImage *)image {
	return [[MWPhoto alloc] initWithImage:image];
}

// Depricated
+ (MWPhoto *)photoWithFilePath:(NSString *)path {
    return [MWPhoto photoWithURL:[NSURL fileURLWithPath:path]];
}

+ (MWPhoto *)photoWithURL:(NSURL *)url {
	return [[MWPhoto alloc] initWithURL:url];
}

#pragma mark NSObject

- (id)initWithImage:(UIImage *)image {
	if ((self = [super init])) {
		_image = image;
	}
	return self;
}

// Depricated
- (id)initWithFilePath:(NSString *)path {
	if ((self = [super init])) {
		_photoURL = [NSURL fileURLWithPath:path];
	}
	return self;
}

- (id)initWithURL:(NSURL *)url {
	if ((self = [super init])) {
		_photoURL = [url copy];
	}
	return self;
}

#pragma mark MWPhoto Protocol Methods

- (UIImage *)underlyingImage {
    return _underlyingImage;
}

- (void)loadUnderlyingImageAndNotify {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    if (_loadingInProgress) return;
    _loadingInProgress = YES;
    @try {
        if (self.underlyingImage) {
            
            // Image already loaded
            [self imageLoadingComplete];
            
        } else {
            
            // Get underlying image
            if (_image) {
                
                // We have UIImage so decompress
                self.underlyingImage = _image;
                [self decompressImageAndFinishLoading];
                
            } else if (_photoURL) {
                
                // Check what type of url it is
                if ([[[_photoURL scheme] lowercaseString] isEqualToString:@"assets-library"]) {
                    
                    // Load from asset library async
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        @autoreleasepool {
                            @try {
                                ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
                                [assetslibrary assetForURL:_photoURL
                                               resultBlock:^(ALAsset *asset){
                                                   ALAssetRepresentation *rep = [asset defaultRepresentation];
                                                   CGImageRef iref = [rep fullScreenImage];
                                                   if (iref) {
                                                       self.underlyingImage = [UIImage imageWithCGImage:iref];
                                                   }
                                                   [self performSelectorOnMainThread:@selector(decompressImageAndFinishLoading) withObject:nil waitUntilDone:NO];
                                               }
                                              failureBlock:^(NSError *error) {
                                                  self.underlyingImage = nil;
                                                  MWLog(@"Photo from asset library error: %@",error);
                                                  [self performSelectorOnMainThread:@selector(decompressImageAndFinishLoading) withObject:nil waitUntilDone:NO];
                                              }];
                            } @catch (NSException *e) {
                                MWLog(@"Photo from asset library error: %@", e);
                                [self performSelectorOnMainThread:@selector(decompressImageAndFinishLoading) withObject:nil waitUntilDone:NO];
                            }
                        }
                    });
                    
                } else if ([_photoURL isFileReferenceURL]) {
                    
                    // Load from local file async
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        @autoreleasepool {
                            @try {
                                self.underlyingImage = [UIImage imageWithContentsOfFile:_photoURL.path];
                                if (!_underlyingImage) {
                                    MWLog(@"Error loading photo from path: %@", _photoURL.path);
                                }
                            } @finally {
                                [self performSelectorOnMainThread:@selector(decompressImageAndFinishLoading) withObject:nil waitUntilDone:NO];
                            }
                        }
                    });
                    
                } else {
                    
                    // Load async from web (using SDWebImage)
//                @try {
//                        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//                        [manager downloadWithURL:_photoURL
//                                         options:0
//                                        progress:^(NSUInteger receivedSize, long long expectedSize) {
//                                            float progress = receivedSize / (float)expectedSize;
//                                            NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                                  [NSNumber numberWithFloat:progress], @"progress",
//                                                                  self, @"photo", nil];
//                                            [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_PROGRESS_NOTIFICATION object:dict];
//                                        }
//                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//                                           if (error) {
//                                               MWLog(@"SDWebImage failed to download image: %@", error);
//                                           }
//                                           self.underlyingImage = image;
//                                           [self decompressImageAndFinishLoading];
//                                       }];
//                    } @catch (NSException *e) {
//                        MWLog(@"Photo from web: %@", e);
//                        [self decompressImageAndFinishLoading];
//                    }
//                    
                }
                
            } else {
                
                // Failed - no source
                @throw [NSException exceptionWithName:nil reason:nil userInfo:nil];
                
            }
        }
    }
    @catch (NSException *exception) {
        self.underlyingImage = nil;
        _loadingInProgress = NO;
        [self imageLoadingComplete];
    }
    @finally {

    }
}

// Release if we can get it again from path or url
- (void)unloadUnderlyingImage {
    _loadingInProgress = NO;
	if (self.underlyingImage) {
		self.underlyingImage = nil;
	}
}

- (void)decompressImageAndFinishLoading {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    if (self.underlyingImage) {
        // Decode image async to avoid lagging when UIKit lazy loads
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.underlyingImage = [UIImage decodedImageWithImage:self.underlyingImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Finish on main thread
                [self imageLoadingComplete];
            });
        });
    } else {
        // Failed
        [self imageLoadingComplete];
    }
}

- (void)imageLoadingComplete {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    // Complete so notify
    _loadingInProgress = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_LOADING_DID_END_NOTIFICATION
                                                        object:self];
}

@end
