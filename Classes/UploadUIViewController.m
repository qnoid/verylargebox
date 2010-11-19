/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 9/11/10.
 *  Contributor(s): .-
 */
#import "UploadUIViewController.h"
#import "TheBoxUIList.h"
#import "NSArray+Decorator.h"

@implementation UploadUIViewController

@synthesize uploadView;
@synthesize takePhotoButton;
@synthesize firstTag;
@synthesize imageView;
@synthesize locationButton;
@synthesize nameTextField;
@synthesize secondTag;
@synthesize thirdTag;

@synthesize textFields;
@synthesize tags;

- (void) dealloc
{
	[textFields release];
	[tags release];
	[super dealloc];
}


-(void) viewDidLoad
{
	[super viewDidLoad];

	self.textFields = [NSArray arrayWithObjects:nameTextField, firstTag, secondTag, thirdTag, nil];	
	self.tags = [TheBoxUIList newListWithTextFields: [NSArray arrayWithObjects:firstTag, secondTag, thirdTag, nil]];
	
	for (UITextField *textField in textFields) {
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	}
	
	for (UITextField *textField in tags) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
	}
	
	uploadView.contentSize = uploadView.frame.size;
	
	CGRect bounds = uploadView.bounds;
	NSLog(@"%@", NSStringFromCGRect(bounds));
	CGSize contentSize = uploadView.contentSize;
	NSLog(@"%@", NSStringFromCGSize(contentSize));		
}

- (void)keyboardWillShow:(NSNotification *)notification
{
	CGRect frame = [uploadView frame];
	frame.origin.y -= [imageView frame].size.height;
	[uploadView setFrame:frame];
	
	CGSize contentSize = uploadView.contentSize;
	contentSize.height += 500;
	uploadView.contentSize = contentSize;
	NSLog(@"%@", NSStringFromCGSize(contentSize));
}
- (void)keyboardWillHide:(NSNotification *)notification
{
	CGRect frame = [uploadView frame];
	frame.origin.y += [imageView frame].size.height;	
	[uploadView setFrame:frame];
	
	CGSize contentSize = uploadView.contentSize;
	contentSize.height -= 500;
	uploadView.contentSize = contentSize;
	NSLog(@"%@", NSStringFromCGSize(contentSize));
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
	for (UITextField *textField in textFields) {
		if([textField resignFirstResponder]){
			return;
		}
	}
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{	
	NSInteger index = [textFields indexOfObject:textField];	
	[[textFields objectAtIndex:++index] becomeFirstResponder];
		
return NO;
}

- (void)textFieldDidChange:(NSNotification *)notification
{
	UITextField *textField = (UITextField *)[notification object];
	[self.tags textFieldDidChange:textField];
}

- (IBAction)cancel:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender {
	[self dismissModalViewControllerAnimated:YES];    
}

- (IBAction)takePhoto:(id)sender 
{
//	BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
//	
//	if(hasCamera)
//	{
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsEditing = YES;
	
		[self presentModalViewController:picker animated:YES];
//	}
}

- (IBAction)enterLocation:(id)sender
{
	NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"Location" owner:self options:nil];
	
	UIViewController *locationController = [views objectAtIndex:0];
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(didEnterLocation:) name:@"didEnterLocation" object:locationController];
	
	[self presentModalViewController:locationController animated:YES];	
}

-(void)didEnterLocation:(NSNotification *)aNotification
{
	NSDictionary *userInfo = [aNotification userInfo];
	NSString *location = [userInfo valueForKey:@"location"];
	locationButton.titleLabel.text = location;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
	imageView.image = image;
	imageView.hidden = NO;
	takePhotoButton.hidden = YES;
	
	[self dismissModalViewControllerAnimated:YES];
	[picker release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
	[picker release];	
}

@end
