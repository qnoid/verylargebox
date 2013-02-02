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


@interface DetailsUIViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(nonatomic, weak) IBOutlet UITableView* itemComments;
@property(nonatomic, weak) IBOutlet UIImageView* itemImageView;

+(DetailsUIViewController*)newDetailsViewController:(NSMutableDictionary*)item;

@end
