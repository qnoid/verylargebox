//  VLBDetailsViewController.h
//  verylargebox
//
//  Created by Markos Charatzas on 10/04/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLBView.h"
@class VLBFeedItemView;

@interface VLBDetailsViewController : UIViewController <VLBViewDrawRectDelegate>

@property(nonatomic, weak) IBOutlet UIButton* storeButton;
@property(nonatomic, weak) IBOutlet UIImageView* itemImageView;
@property(nonatomic, weak) IBOutlet UIButton* whenButton;
@property(nonatomic, weak) IBOutlet UIButton* askForDirectionsButton;

+(VLBDetailsViewController *)newDetailsViewController:(NSMutableDictionary*)item;

-(IBAction)didTouchUpInsideAskForDirectionsButton:(id)sender;
@end
