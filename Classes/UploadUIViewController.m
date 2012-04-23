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
#import "TheBoxQueries.h"
#import "HomeUIGridViewController.h"
#import "TheBoxDefaultKeyboardObserver.h"
#import "AFHTTPRequestOperation.h"
#import "JSONKit.h"
#import "LocationUIViewController.h"
#import "CategoriesViewController.h"
#import "TheBoxLocationService.h"

@interface UploadUIViewController ()
@property(nonatomic, strong) NSMutableDictionary* location;
@property(nonatomic, strong) NSDictionary* category;
@property(nonatomic, strong) TheBoxLocationService *theBoxLocationService;
@end

@implementation UploadUIViewController

@synthesize uploadView;
@synthesize takePhotoButton;
@synthesize categoryTextField;
@synthesize firstTag;
@synthesize secondTag;
@synthesize imageView;
@synthesize locationButton;
@synthesize nameTextField;

@synthesize textFields;
@synthesize list;
@synthesize tags;
@synthesize theBox;
@synthesize keyboardObserver;
@synthesize createItemDelegate;

@synthesize location = _location;
@synthesize category;
@synthesize theBoxLocationService;

- (void) dealloc
{
    [TheBoxNotifications removeObserverForUIKeyboardNotifications:self.keyboardObserver];
}

+(UploadUIViewController*)newUploadUIViewController
{
    UploadUIViewController* newUploadUIViewController = [[UploadUIViewController alloc] initWithNibName:@"UploadUIViewController" bundle:[NSBundle mainBundle]];
    
    TheBoxDefaultKeyboardObserver* newKeyboardObserver = [[TheBoxDefaultKeyboardObserver alloc] init];
    newKeyboardObserver.keyboardObserver = newUploadUIViewController;
    newUploadUIViewController.keyboardObserver = newKeyboardObserver;
    
    [TheBoxNotifications addObserverForUIKeyboardNotifications:newKeyboardObserver];
    
    
return newUploadUIViewController;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.location = [NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionary] forKey:@"location"];
        self.category = [NSDictionary dictionaryWithObject:@"" forKey:@"name"];
        self.theBoxLocationService = [TheBoxLocationService theBox];                
    }
    
return self;
}

-(void) viewDidLoad
{
	[super viewDidLoad];

    [self.theBoxLocationService notifyDidUpdateToLocation:self];

	self.textFields = [NSArray arrayWithObjects:nameTextField, categoryTextField, firstTag, secondTag, nil];	
	self.list = [TheBoxUIList newListWithTextFields: [NSArray arrayWithObjects:categoryTextField, firstTag, secondTag, nil]];
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

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark TheBoxLocationServiceDelegate

-(void)didUpdateToLocation:(NSNotification *)notification;
{
	CLLocation *location = [TheBoxNotifications location:notification];

	[[_location objectForKey:@"location"] setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"lat"];
	[[_location objectForKey:@"location"] setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"lng"];
}


#pragma mark TheBoxKeyboardObserver

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
    if(textField == self.nameTextField){
        [textField resignFirstResponder];
    return NO;
    }
    
	NSInteger index = [textFields indexOfObject:textField];	
    if(index + 1 == [textFields count]){
        [textField resignFirstResponder];
    return YES;
    }
    
	[[textFields objectAtIndex:++index] becomeFirstResponder];
		
return textField == self.categoryTextField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return textField != self.categoryTextField;  
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
	AFHTTPRequestOperation *itemQuery = [TheBoxQueries newItemQuery:imageView.image 
												itemName:nameTextField.text 
												location:self.location
												category:category
												tags:tags];


    [itemQuery setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.createItemDelegate didSucceedWithItem:[operation.responseString mutableObjectFromJSONString]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.createItemDelegate didFailOnItemWithError:error];
    }];
    
	[itemQuery start];
    
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
	UIViewController *locationController = [LocationUIViewController newLocationViewController];
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(didEnterLocation:) name:@"didEnterLocation" object:locationController];
	
	[self presentModalViewController:locationController animated:YES];	
}

-(void)didEnterLocation:(NSNotification *)aNotification
{
	NSDictionary *userInfo = [aNotification userInfo];
    self.location = [userInfo valueForKey:@"location"];
    
	NSString *locationName = [self.location objectForKey:@"name"];
	[locationButton setTitle:locationName forState:UIControlStateNormal];
	[locationButton setTitle:locationName forState:UIControlStateSelected];
}

- (IBAction)selectCategory:(id)sender
{
	UIViewController *categoriesController = [CategoriesViewController newCategoriesViewController];
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(didSelectCategory:) name:@"didSelectCategory" object:categoriesController];
	
	[self presentModalViewController:categoriesController animated:YES];	    
}

-(void)didSelectCategory:(NSNotification *)aNotification
{
	NSDictionary *userInfo = [aNotification userInfo];
    self.category = [userInfo valueForKey:@"category"];
    
	NSString *categoryName = [category objectForKey:@"name"];
	self.categoryTextField.text = categoryName;
}

//http://stackoverflow.com/questions/1703100/resize-uiimage-with-aspect-ratio
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGSize newSize = CGSizeMake(2056.0f, 1536.0f);

        UIGraphicsBeginImageContext(newSize);
        
        [image drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        imageView.image = newImage;
    });

	imageView.hidden = NO;
	takePhotoButton.hidden = YES;
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
