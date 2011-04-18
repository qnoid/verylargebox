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
#import "ASIFormDataRequest.h"
#import "UITextField+TheBoxUITextField.h"
#import "TheBoxQueries.h"
#import "TheBoxPost.h"
#import "TheBox.h"
#import "HomeUIGridViewController.h"
#import "TheBoxSingleDataParser.h"
#import "TheBoxDataParser.h"

@implementation UploadUIViewController

@synthesize theBoxDelegate;
@synthesize uploadView;
@synthesize takePhotoButton;
@synthesize category;
@synthesize firstTag;
@synthesize secondTag;
@synthesize imageView;
@synthesize locationButton;
@synthesize nameTextField;

@synthesize textFields;
@synthesize list;
@synthesize tags;
@synthesize theBox;

- (void) dealloc
{
	[self.uploadView release];
	[self.takePhotoButton release];
	[self.imageView release];
	[self.locationButton release];
	[self.nameTextField release];
	[self.textFields release];
	[self.list release];
	[self.tags release];
	[self.theBox release];
	[self.theBoxDelegate release];
	[super dealloc];
}

-(void) loadView
{
	[super loadView];
	
	TheBoxBuilder* builder = [[TheBoxBuilder alloc] init];		
	
	id<TheBoxDataParser> dataParser = [[TheBoxSingleDataParser alloc] init];
	dataParser.delegate = theBoxDelegate;	
	[builder dataParser:dataParser];
	
	self.theBox = [builder build];
	self.theBox.delegate = theBoxDelegate;

	[dataParser release];
	[builder release];		
}

-(void) viewDidLoad
{
	[super viewDidLoad];

	self.textFields = [NSArray arrayWithObjects:nameTextField, category, firstTag, secondTag, nil];	
	self.list = [TheBoxUIList newListWithTextFields: [NSArray arrayWithObjects:category, firstTag, secondTag, nil]];
	self.tags = [NSArray arrayWithObjects:firstTag, secondTag, nil];	
	
	for (UITextField *textField in textFields) {
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	}
	
	for (UITextField *textField in list) {
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
	[self.list textFieldDidChange:textField];
}

- (IBAction)cancel:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender 
{
	TheBoxPost *itemQuery = [[TheBoxQueries itemQuery:imageView.image 
												itemName:nameTextField.text 
												locationName:locationButton.titleLabel.text
												categoryName:category.text
												tags:tags] retain];

	[self.theBox query:itemQuery];
	
	[self dismissModalViewControllerAnimated:YES];    
}

- (IBAction)takePhoto:(id)sender 
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
#if !TARGET_IPHONE_SIMULATOR
	picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
#endif
	
	[self presentModalViewController:picker animated:YES];
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
	//less than a meg
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
