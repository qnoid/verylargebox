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
		IBOutlet UIScrollView *uploadView;
		IBOutlet UIButton *takePhotoButton;
		IBOutlet UITextField *firstTag;
		IBOutlet UIImageView *imageView;
		IBOutlet UITextField *locationTextField;
		IBOutlet UITextField *nameTextField;
		IBOutlet UITextField *secondTag;
		IBOutlet UITextField *thirdTag;
	
		NSArray *textFields;
		TheBoxUIList *tags;
}

@property(nonatomic, retain) NSArray *textFields;
@property(nonatomic, retain) TheBoxUIList *tags;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

- (IBAction)edit:(id)sender;

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

@end
