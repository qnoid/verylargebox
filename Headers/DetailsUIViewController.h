//
//  DetailsUIViewController.h
//  TheBox
//
//  Created by Markos Charatzas on 10/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TheBoxLocationServiceDelegate.h"

@interface DetailsUIViewController : UIViewController <TheBoxLocationServiceDelegate>
{
    
}

@property(nonatomic, unsafe_unretained) IBOutlet UIButton* locationButton;
@property(nonatomic, unsafe_unretained) IBOutlet UIImageView* itemImageView;

+(DetailsUIViewController*)newDetailsViewController:(NSDictionary*)item;

-(IBAction)didClickOnLocation:(id)sender;

@end
