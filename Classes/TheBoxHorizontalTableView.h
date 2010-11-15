/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 8/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TheBoxHorizontalTableView : UIScrollView 
{
	@private
		UITableView *tableView;
}

@property(nonatomic, retain) IBOutlet UITableView *tableView;

-(id) initWithTableView:(UITableView *)tableView;

@end
