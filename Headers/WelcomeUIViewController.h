/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 8/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TBCityViewController.h"

@interface WelcomeUIViewController : UIViewController

@property(nonatomic, unsafe_unretained) IBOutlet UILabel *locationLabel;
@property(nonatomic, unsafe_unretained) IBOutlet UIButton *checkInButton;

+(WelcomeUIViewController*)newWelcomeViewController;

- (IBAction)enter:(id)sender;
@end
