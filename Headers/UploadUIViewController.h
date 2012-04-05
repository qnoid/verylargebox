/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 9/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import "TheBoxDelegate.h"
#import "TheBoxDataParserDelegate.h"
#import "TheBoxResponseParserDelegate.h"
#import "TheBoxNotifications.h"
@class TheBox;
@class HomeUIGridViewController;
@class TheBoxUIList;
@class TheBoxDefaultKeyboardObserver;
@protocol TBCreateItemOperationDelegate;

@interface UploadUIViewController : UIViewController <TheBoxKeyboardObserver, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate> 
{
}

@property(nonatomic, assign) IBOutlet UIScrollView *uploadView;
@property(nonatomic, assign) IBOutlet UIButton *takePhotoButton;
@property(nonatomic, assign) IBOutlet UIImageView *imageView;
@property(nonatomic, assign) IBOutlet UIButton *locationButton;
@property(nonatomic, assign) IBOutlet UITextField *nameTextField;
@property(nonatomic, assign) IBOutlet UITextField *category;
@property(nonatomic, assign) IBOutlet UITextField *firstTag;
@property(nonatomic, assign) IBOutlet UITextField *secondTag;

@property(nonatomic, retain) NSArray *textFields;
@property(nonatomic, retain) TheBoxUIList *list;
@property(nonatomic, retain) NSArray *tags;
@property(nonatomic, retain) TheBox *theBox;
@property(nonatomic, retain) TheBoxDefaultKeyboardObserver *keyboardObserver;
@property(nonatomic, retain) id<TheBoxDelegate, TheBoxDataParserDelegate> theBoxDelegate;
@property(nonatomic, assign) NSObject<TBCreateItemOperationDelegate> *createItemDelegate;

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

+(UploadUIViewController*)newUploadUIViewController;

@end
