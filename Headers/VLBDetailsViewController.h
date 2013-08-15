//  VLBDetailsViewController.h
//  verylargebox
//
//  Created by Markos Charatzas on 10/04/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLBView.h"

@interface VLBDetailsViewController : UIViewController

@property(nonatomic, weak) IBOutlet UIButton* storeButton;
@property(nonatomic, weak) IBOutlet UIImageView* itemImageView;
@property(nonatomic, weak) IBOutlet UIButton* whenButton;
@property(nonatomic, weak) IBOutlet UIButton* askForDirectionsButton;
@property(nonatomic, weak) IBOutlet UIButton* reportButton;

+(VLBDetailsViewController *)newDetailsViewController:(NSMutableDictionary*)item;

-(IBAction)didTouchUpInsideAskForDirectionsButton:(id)sender;
-(IBAction)didTouchUpInsideReportButton:(id)sender;

@end
