/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 8/11/10.
 *  Contributor(s): .-
 */
#import "TheBoxHorizontalTableView.h"

@implementation TheBoxHorizontalTableView

@synthesize tableView;

- (void) dealloc
{
	[tableView release];
	[super dealloc];
}


-(id) initWithTableView:(UITableView *)_tableView
{
	self = [super init];
	
	if (self) 
	{
		self.tableView = _tableView;
	}
	
	return self;
}

@end
