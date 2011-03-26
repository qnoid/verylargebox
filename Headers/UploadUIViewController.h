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
		UIImageView *imageView;
		UIButton *locationButton;
		UITextField *nameTextField;
		UITextField *category;	
		UITextField *firstTag;
		UITextField *secondTag;
		NSArray *textFields;
		TheBoxUIList *list;
		NSArray *tags;
}
@property(nonatomic, retain) IBOutlet UIScrollView *uploadView;
@property(nonatomic, retain) IBOutlet UIButton *takePhotoButton;
@property(nonatomic, retain) IBOutlet UIImageView *imageView;
@property(nonatomic, retain) IBOutlet UIButton *locationButton;
@property(nonatomic, retain) IBOutlet UITextField *nameTextField;
@property(nonatomic, retain) IBOutlet UITextField *category;
@property(nonatomic, retain) IBOutlet UITextField *firstTag;
@property(nonatomic, retain) IBOutlet UITextField *secondTag;
@property(nonatomic, retain) NSArray *textFields;
@property(nonatomic, retain) TheBoxUIList *list;
@property(nonatomic, retain) NSArray *tags;

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
