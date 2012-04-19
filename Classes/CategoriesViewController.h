/**
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid)  on 16/04/2012.
 *  Contributor(s): .-
 */

#import <UIKit/UIKit.h>
#import "TBCategoriesOperationDelegate.h"
#import "TBCreateCategoryOperationDelegate.h"

@interface CategoriesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TBCategoriesOperationDelegate, TBCreateCategoryOperationDelegate>

- (IBAction)addCategory:(id)sender;
- (IBAction)cancel:(id)sender;

@property(nonatomic, unsafe_unretained) IBOutlet UITableView *categoriesTableView;

+(CategoriesViewController*)newCategoriesViewController;

@end
