/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 9/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TheBoxNotifications.h"
#import "TheBoxLocationServiceDelegate.h"
@class TheBox;
@protocol TBCreateItemOperationDelegate;

@interface UploadUIViewController : UIViewController <TheBoxLocationServiceDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate> 
{
}

@property(nonatomic, unsafe_unretained) IBOutlet UIScrollView *uploadView;
@property(nonatomic, unsafe_unretained) IBOutlet UIButton *takePhotoButton;
@property(nonatomic, unsafe_unretained) IBOutlet UIButton *locationButton;

@property(nonatomic, strong) TheBox *theBox;
@property(nonatomic, unsafe_unretained) NSObject<TBCreateItemOperationDelegate> *createItemDelegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

/*
 *	Presents the ImagePicker to allow the user to take a photo 
 *  only if he has a camera.
 *
 *	Allows editting of the image so that he can crop, zoom etc.
 *	in case he likes to submit a better version.
 *
 *	Also sets the delegate to self.
 */
- (IBAction)takePhoto:(id)sender;

- (IBAction)enterLocation:(id)sender;

+(UploadUIViewController*)newUploadUIViewController:(NSUInteger)userId;

@end
