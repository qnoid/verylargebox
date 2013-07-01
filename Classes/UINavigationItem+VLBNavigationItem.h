//
//  UINavigationItem+TBNavigationItem.h
//  verylargebox
//
//  Created by Markos Charatzas on 26/05/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VLBNavigationItemAction)(UINavigationItem* navigationItem, id target);

/**


 */
extern VLBNavigationItemAction TBNavigationItemActionDismissViewControllerAnimatedOnLeftBarButtonItem;

@interface UINavigationItem (VLBNavigationItem)

-(void)vlb_addActionOnBarButtonItem:(VLBNavigationItemAction)navigationItemAction target:(id)target;

@end
