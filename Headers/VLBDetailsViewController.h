//  VLBDetailsViewController.h
//  verylargebox
//
//  Created by Markos Charatzas on 10/04/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <UIKit/UIKit.h>

@class VLBFeedItemView;

@interface VLBDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(nonatomic, weak) IBOutlet VLBFeedItemView* itemView;

+(VLBDetailsViewController *)newDetailsViewController:(NSMutableDictionary*)item;

@end
