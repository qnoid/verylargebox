/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 8/11/10.
 *  Contributor(s): .-
 */
#import "HomeUIViewController.h"

@implementation HomeUIViewController

- (IBAction)upload:(id)sender 
{
	NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"Upload" owner:self options:nil];
	
	UIViewController *upload = [views objectAtIndex:0];
	
	[self presentModalViewController:upload animated:YES];    
}
@end
