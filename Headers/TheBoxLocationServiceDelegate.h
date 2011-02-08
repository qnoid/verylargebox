/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 16/11/10.
 *  Contributor(s): .-
 */

#import <UIKit/UIKit.h>


@protocol TheBoxLocationServiceDelegate<NSObject>

@optional
	-(void)didUpdateToLocation:(NSNotification *)notification;
	-(void)didFindPlacemark:(NSNotification *)notification;
	-(void)didFailWithError:(NSNotification *)notification;

@end
