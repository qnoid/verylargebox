//
//  UINavigationItem+TBNavigationItem.h
//  thebox
//
//  Created by Markos Charatzas on 26/05/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TBNavigationItemAction)(UINavigationItem* navigationItem, id target);

/**


 */
extern TBNavigationItemAction TBNavigationItemActionDismissViewControllerAnimatedOnLeftBarButtonItem;

@interface UINavigationItem (TBNavigationItem)

-(void)tb_addActionOnBarButtonItem:(TBNavigationItemAction)navigationItemAction target:(id)target;

@end
