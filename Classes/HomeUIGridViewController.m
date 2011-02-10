/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 23/11/10.
 *  Contributor(s): .-
 */
#import "HomeUIGridViewController.h"
#import "TheBoxLocationService.h"
#import "TheBoxNotifications.h"
#import "TheBoxUICell.h"
#import "TheBoxMath.h"

@implementation HomeUIGridViewController

@synthesize locationLabel;
@synthesize searchBar;
@synthesize theBoxLocationService;

@synthesize items;

- (void) dealloc
{
	[self.items release];
	[self.theBoxLocationService release];	
	[super dealloc];
}

-(void) loadView
{
	[super loadView];
	
	self.theBoxLocationService = [TheBoxLocationService theBox];
	[self.theBoxLocationService notifyDidFindPlacemark:self];
	[self.theBoxLocationService notifyDidFailWithError:self];
	
	self.items = [NSArray arrayWithObjects:
					  [NSArray arrayWithObjects:
					   [UIImage imageNamed:@"1,1_160x160.jpg"],
					   [UIImage imageNamed:@"1,2_160x160.jpg"],
					   [UIImage imageNamed:@"1,3_160x160.jpg"],
					   [UIImage imageNamed:@"1,4_160x160.jpg"],
					   nil],
					  
					  [NSArray arrayWithObjects:
					   [UIImage imageNamed:@"2,1_160x160.jpg"],
					   [UIImage imageNamed:@"2,2_160x160.jpg"],
					   [UIImage imageNamed:@"2,3_160x160.jpg"],
					   nil],
					  
					  [NSArray arrayWithObjects:
					   [UIImage imageNamed:@"3,1_160x160.jpg"],
					   [UIImage imageNamed:@"3,2_160x160.jpg"],
					   nil],
					  
					  [NSArray arrayWithObjects:						 
					   [UIImage imageNamed:@"4,1_160x160.jpg"],
					   nil],

					  [NSArray arrayWithObjects:
					   [UIImage imageNamed:@"5,1_160x160.jpg"],
					   [UIImage imageNamed:@"5,2_160x160.jpg"],
					   [UIImage imageNamed:@"5,3_160x160.jpg"],
					   [UIImage imageNamed:@"5,4_160x160.jpg"],
					   [UIImage imageNamed:@"5,5_160x160.jpg"],
					   nil],
					  nil];	

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
	NSLog(@"upload");
	[theSearchBar resignFirstResponder];
}

- (IBAction)upload:(id)sender 
{
	NSLog(@"upload");
	NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"Upload" owner:self options:nil];
	
	UIViewController *upload = [views objectAtIndex:0];
	
	[self presentModalViewController:upload animated:YES];    
}

-(void)didFindPlacemark:(NSNotification *)notification
{
	MKPlacemark *place = [TheBoxNotifications place:notification];
	NSString *city = place.locality;
	
	locationLabel.text = city;		
	locationLabel.hidden = NO;	
}

-(void)didFailWithError:(NSNotification *)notification
{
	NSError *error = [TheBoxNotifications error:notification];
	
	NSLog(@"%@", error);
	
	locationLabel.text = @"Unknown";		
	locationLabel.hidden = NO;
}

-(UIView *)columnView:(UIView*) column forColumn:(NSUInteger)index inSection:(NSUInteger) section
{		
	TheBoxUICell *theBoxCell = (TheBoxUICell *) column;
	NSArray *sectionView = [self.items objectAtIndex:section];
	UIImage *image = [sectionView objectAtIndex:index];
	
	theBoxCell.itemImageView.image = image;
	theBoxCell.itemLabel.text = [NSString stringWithFormat:@"%dK - %d minute", [TheBoxMath getRandomNumber:1 to:100], [TheBoxMath getRandomNumber:1 to:60]];	

return theBoxCell;
}

-(NSInteger)numberOfSectionsInGridView:(TheBoxUIGridView *)theGridView {
return [self.items count];
}

-(NSUInteger)numberOfColumnsInSection:(NSUInteger)index{
return [[self.items objectAtIndex:index] count];
}

@end
