/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 16/11/10.

 */
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol VLBKeyboardObserver

-(void)keyboardWillShow:(NSNotification*) notification;

-(void)keyboardWillHide:(NSNotification*) notification;

@optional
-(void)noticeShowKeyboard:(NSNotification*)notification;

-(void)noticeHideKeyboard:(NSNotification*)notification;

@end

@interface VLBNotifications : NSObject {

}

+(void)addObserverForUIKeyboardNotifications:(id<VLBKeyboardObserver>)observer;
+(void)removeObserverForUIKeyboardNotifications:(id<VLBKeyboardObserver>)observer;

+(CLLocation *)location:(NSNotification *)notification;
+(MKPlacemark *)place:(NSNotification *)notification;
+(NSError *)error:(NSNotification *)notification;

@end
