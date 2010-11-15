/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 12/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>

/*
 * Call 	
 *
 *	[super viewDidLoad];
 *
 * to register for notifications
 */
@interface UIViewController (TheBoxUIViewController)

- (void)noticeShowKeyboard:(NSNotification *)notification;
- (void)noticeHideKeyboard:(NSNotification *)notification;

/*
 * Override to set the view when keyboard will show
 */
- (void)keyboardWillShow:(NSNotification *)notification;

/*
 * Override to set the view when keyboard will hide
 */
- (void)keyboardWillHide:(NSNotification *)notification;

@end
