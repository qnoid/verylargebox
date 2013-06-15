/*
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid)  on 30/03/2012.
 *  Contributor(s): .-
 */
#import "VLBDefaultKeyboardObserver.h"

@implementation VLBDefaultKeyboardObserver

@synthesize keyboardObserver;

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


-(void)keyboardWillShow:(NSNotification*) notification
{
    [self.keyboardObserver keyboardWillShow:notification];
}

-(void)keyboardWillHide:(NSNotification*) notification
{
    [self.keyboardObserver keyboardWillHide:notification];
}

@end
