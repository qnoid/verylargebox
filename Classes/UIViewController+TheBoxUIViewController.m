/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 12/11/10.
 *  Contributor(s): .-
 */
#import "UIViewController+TheBoxUIViewController.h"


@implementation UIViewController (TheBoxUIViewController)

-(void) viewDidLoad
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(noticeShowKeyboard:) name:UIKeyboardDidShowNotification object:nil];
	[center addObserver:self selector:@selector(noticeHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];		
}	

- (void)noticeShowKeyboard:(NSNotification *)notification
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	[self keyboardWillShow:notification];

	[UIView commitAnimations];
}

- (void)noticeHideKeyboard:(NSNotification *)notification
{
	[UIView beginAnimations:nil context:NULL];	
	[UIView setAnimationDuration:0.3];
	
	[self keyboardWillHide:notification];
	
	[UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notification{}
- (void)keyboardWillHide:(NSNotification *)notification{}

@end
