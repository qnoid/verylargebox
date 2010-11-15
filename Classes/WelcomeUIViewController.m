/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 8/11/10.
 *  Contributor(s): .-
 */
#import "WelcomeUIViewController.h"

@implementation WelcomeUIViewController

-(void) viewDidLoad
{
	//do location retrieval
}

- (IBAction)enter:(id)sender 
{
	NSLog(@"Hello %@", locationLabel.text);
	
	NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"Home" owner:self options:nil];
	
	UIViewController *home = [views objectAtIndex:0];
	
	[self presentModalViewController:home animated:YES];
}
@end
