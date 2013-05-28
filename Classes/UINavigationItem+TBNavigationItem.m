//
//  UINavigationItem+TBNavigationItem.m
//  thebox
//
//  Created by Markos Charatzas on 26/05/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "UINavigationItem+TBNavigationItem.h"


TBNavigationItemAction TBNavigationItemActionDismissViewControllerAnimatedOnLeftBarButtonItem = ^(UINavigationItem* navigationItem, id target)
{
        UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc]
                                          initWithTitle:@"Dismiss"
                                          style:UIBarButtonItemStylePlain
                                          target:target
                                          action:@selector(dismissViewControllerAnimated)];
        
        navigationItem.leftBarButtonItem = dismissButton;
};

@implementation UINavigationItem (TBNavigationItem)

-(void)tb_addActionOnBarButtonItem:(TBNavigationItemAction)navigationItemAction target:(id)target
{
    navigationItemAction(self, target);
}
@end
