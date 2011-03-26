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
#import "Item.h"
#import "ASIHTTPRequest.h"
#import "TheBox.h"
#import "TheBoxQueries.h"
#import "TheBoxPost.h"
#import "TheBoxGet.h"
#import "UploadUIViewController.h"

@interface HomeUIGridViewController ()


@end


@implementation HomeUIGridViewController

@synthesize uploadViewController;
@synthesize locationLabel;
@synthesize searchBar;
@synthesize theBoxLocationService;

@synthesize items;

- (void) dealloc
{
	[self.uploadViewController release];
	[self.locationLabel release];
	[self.searchBar release];
	[self.theBoxLocationService release];
	[self.items release];
	[self.theBoxLocationService release];
	[super dealloc];}

-(void) loadView
{
	[super loadView];
	
	self.theBoxLocationService = [TheBoxLocationService theBox];
	[self.theBoxLocationService notifyDidFindPlacemark:self];
	[self.theBoxLocationService notifyDidFailWithError:self];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
	NSLog(@"upload");
	[theSearchBar resignFirstResponder];
}

- (IBAction)upload:(id)sender 
{
	[self presentModalViewController:uploadViewController animated:YES];    
}
#pragma mark location based
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

#pragma mark datasource
-(UIView *)columnView:(UIView*) column forColumn:(NSUInteger)index inSection:(NSUInteger) section
{		
	TheBoxUICell *theBoxCell = (TheBoxUICell *) column;
	NSArray *sectionItems = [self.items objectAtIndex:section];
	
	Item *item = [sectionItems objectAtIndex:index];

	NSLog(@"%@", item);

	theBoxCell.itemLabel.text = [NSString stringWithFormat:@"%@", item.when];	

return theBoxCell;
}

-(NSInteger)numberOfSectionsInGridView:(TheBoxUIGridView *)theGridView {
return 1;
}

-(NSUInteger)numberOfColumnsInSection:(NSUInteger)index{
return [items count];
}

@end
