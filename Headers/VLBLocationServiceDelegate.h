/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 16/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>


@protocol VLBLocationServiceDelegate <NSObject>

@optional
-(void)didUpdateToLocation:(NSNotification *)notification;
-(void)didFindPlacemark:(NSNotification *)notification;
-(void)didFailUpdateToLocationWithError:(NSNotification *)notification;
-(void)didFailReverseGeocodeLocationWithError:(NSNotification *)notification;

@end
