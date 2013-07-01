//
//  VLBLocalitiesTableViewController.h
//  verylargebox
//
//  Created by Markos Charatzas on 19/05/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLBLocalityOperationDelegate.h"

@protocol VLBLocalitiesTableViewControllerDelegate

-(void)didSelectLocality:(NSDictionary*)locality;

@end


/**
 
 Displays a list of localities.
 
 */
@interface VLBLocalitiesTableViewController : UITableViewController <VLBLocalityOperationDelegate>

@property(nonatomic, weak) id<VLBLocalitiesTableViewControllerDelegate> delegate;

+(instancetype)newLocalitiesViewController;

@end
