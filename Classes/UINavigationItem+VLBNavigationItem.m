//
//  UINavigationItem+TBNavigationItem.m
//  verylargebox
//
//  Created by Markos Charatzas on 26/05/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "UINavigationItem+VLBNavigationItem.h"


VLBNavigationItemAction TBNavigationItemActionDismissViewControllerAnimatedOnLeftBarButtonItem = ^(UINavigationItem* navigationItem, id target)
{
        UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc]
                                          initWithTitle:@"Dismiss"
                                          style:UIBarButtonItemStylePlain
                                          target:target
                                          action:@selector(dismissViewControllerAnimated:completion:)];
        
        navigationItem.leftBarButtonItem = dismissButton;
};

@implementation UINavigationItem (VLBNavigationItem)

-(void)vlb_addActionOnBarButtonItem:(VLBNavigationItemAction)navigationItemAction target:(id)target
{
    navigationItemAction(self, target);
}
@end
