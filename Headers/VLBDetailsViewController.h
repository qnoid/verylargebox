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
#import "VLBLocationServiceDelegate.h"
#import "VLBUpdateItemOperationDelegate.h"


@interface VLBDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(nonatomic, weak) IBOutlet UIImageView* itemImageView;
@property(nonatomic, weak) IBOutlet UILabel* itemWhenLabel;

+(VLBDetailsViewController *)newDetailsViewController:(NSMutableDictionary*)item;

@end
