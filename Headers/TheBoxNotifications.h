/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 16/11/10.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol TheBoxKeyboardObserver

-(void)keyboardWillShow:(NSNotification*) notification;

-(void)keyboardWillHide:(NSNotification*) notification;

@optional
-(void)noticeShowKeyboard:(NSNotification*)notification;

-(void)noticeHideKeyboard:(NSNotification*)notification;

@end

@interface TheBoxNotifications : NSObject {

}

+(void)addObserverForUIKeyboardNotifications:(id<TheBoxKeyboardObserver>)observer;
+(void)removeObserverForUIKeyboardNotifications:(id<TheBoxKeyboardObserver>)observer;

+(CLLocation *)location:(NSNotification *)notification;
+(MKPlacemark *)place:(NSNotification *)notification;
+(NSError *)error:(NSNotification *)notification;

@end
