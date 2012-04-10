/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 8/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TheBoxLocationServiceDelegate.h"
#import "HomeUIGridViewController.h"

@class TheBoxLocationService;

@interface WelcomeUIViewController : UIViewController <TheBoxLocationServiceDelegate> 

@property(nonatomic, unsafe_unretained) IBOutlet UILabel *locationLabel;
@property(nonatomic, unsafe_unretained) IBOutlet UIButton *checkInButton;
@property(nonatomic) TheBoxLocationService *theBoxLocationService;

- (IBAction)enter:(id)sender;
@end
