/*
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid)  on 10/04/2012.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TheBoxLocationServiceDelegate.h"
#import "TBUpdateItemOperationDelegate.h"


@interface DetailsUIViewController : UIViewController <TheBoxLocationServiceDelegate, TBUpdateItemOperationDelegate>
{
    
}

@property(nonatomic, unsafe_unretained) IBOutlet UIButton* locationButton;
@property(nonatomic, unsafe_unretained) IBOutlet UIImageView* itemImageView;

+(DetailsUIViewController*)newDetailsViewController:(NSDictionary*)item;

-(IBAction)didClickOnLocation:(id)sender;

@end
