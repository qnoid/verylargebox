//  VLBDetailsViewController.h
//  thebox
//
//  Created by Markos Charatzas on 10/04/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <UIKit/UIKit.h>

@class VLBUserItemView;

@interface VLBDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
}

@property(nonatomic, weak) IBOutlet VLBUserItemView* userItemView;

+(VLBDetailsViewController *)newDetailsViewController:(NSMutableDictionary*)item;

@end
