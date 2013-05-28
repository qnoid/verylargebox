//
//  TBLocalitiesTableViewController.h
//  thebox
//
//  Created by Markos Charatzas on 19/05/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBLocalityOperationDelegate.h"

@protocol TBLocalitiesTableViewControllerDelegate

-(void)didSelectLocality:(NSDictionary*)locality;

@end


/**
 
 Displays a list of localities.
 
 */
@interface TBLocalitiesTableViewController : UITableViewController <TBLocalityOperationDelegate>

@property(nonatomic, weak) id<TBLocalitiesTableViewControllerDelegate> delegate;

+(instancetype)newLocalitiesViewController;

@end
