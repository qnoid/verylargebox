/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 16/11/10.
 *  Contributor(s): .-
 */
#import "TheBoxNotifications.h"


@implementation TheBoxNotifications

+(void)addObserverForUIKeyboardNotifications:(id<TheBoxKeyboardObserver>)observer
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:observer selector:@selector(noticeShowKeyboard:) name:UIKeyboardDidShowNotification object:nil];
	[center addObserver:observer selector:@selector(noticeHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];		
}	

+(void)removeObserverForUIKeyboardNotifications:(id<TheBoxKeyboardObserver>)observer
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:observer];
}

+(CLLocation *)location:(NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
return [userInfo objectForKey:@"newLocation"];
}

+(MKPlacemark *)place:(NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
return [userInfo objectForKey:@"place"];
}

+(NSError *)error:(NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
return [userInfo objectForKey:@"error"];
}

@end
