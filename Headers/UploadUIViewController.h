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
@class TheBoxUIList;

@interface UploadUIViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate> {
	
	@private
		UIScrollView *uploadView;
		UIButton *takePhotoButton;
		UITextField *firstTag;
		UIImageView *imageView;
		UIButton *locationButton;
		UITextField *nameTextField;
		UITextField *secondTag;
		UITextField *thirdTag;	
		NSArray *textFields;
		TheBoxUIList *tags;
}
@property(nonatomic, assign) IBOutlet UIScrollView *uploadView;
@property(nonatomic, assign) IBOutlet UIButton *takePhotoButton;
@property(nonatomic, assign) IBOutlet UITextField *firstTag;
@property(nonatomic, assign) IBOutlet UIImageView *imageView;
@property(nonatomic, assign) IBOutlet UIButton *locationButton;
@property(nonatomic, assign) IBOutlet UITextField *nameTextField;
@property(nonatomic, assign) IBOutlet UITextField *secondTag;
@property(nonatomic, assign) IBOutlet UITextField *thirdTag;
@property(nonatomic, retain) NSArray *textFields;
@property(nonatomic, retain) TheBoxUIList *tags;

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

@end
