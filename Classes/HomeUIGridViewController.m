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
#import "JSON.h"
#import "ItemProvider.h"
#import "Item.h"
#import "Items.h"
#import "ASIHTTPRequest.h"
#import "FooTest.h"
#import "UploadUIViewController.h"


@implementation HomeUIGridViewController

@synthesize uploadViewController;
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

	ASIHTTPRequest *request = [FooTest jsonRequest:@"http://0.0.0.0:3000/items"];

	[request startSynchronous];
	
	NSString *jsonString = [request responseString];
	
	NSLog(@"%@", jsonString);

	NSDictionary *dictionary = [jsonString JSONValue];
	
	ItemProvider *foo = [[ItemProvider alloc] initWith:dictionary];
	
	NSMutableArray *theItems = [[NSMutableArray alloc] init];

	Item *item;
	while(item = [foo nextObject])
	{
		[theItems addObject:item];
	}
	
	[foo release];

	self.items = [NSArray arrayWithObjects:
					theItems,
	
					[[Items newItemsWithImages:
					  [NSArray arrayWithObjects:
					   [UIImage imageNamed:@"1,1_160x160.jpg"],
					   [UIImage imageNamed:@"1,2_160x160.jpg"],
					   [UIImage imageNamed:@"1,3_160x160.jpg"],
					   [UIImage imageNamed:@"1,4_160x160.jpg"],
					   nil]] autorelease],
					  
					[[Items newItemsWithImages:
					  [NSArray arrayWithObjects:
					   [UIImage imageNamed:@"2,1_160x160.jpg"],
					   [UIImage imageNamed:@"2,2_160x160.jpg"],
					   [UIImage imageNamed:@"2,3_160x160.jpg"],
					   nil]] autorelease],
					  
					[[Items newItemsWithImages:
					  [NSArray arrayWithObjects:
					   [UIImage imageNamed:@"3,1_160x160.jpg"],
					   [UIImage imageNamed:@"3,2_160x160.jpg"],
					   nil]] autorelease],
					  
					[[Items newItemsWithImages:
					  [NSArray arrayWithObjects:						 
					   [UIImage imageNamed:@"4,1_160x160.jpg"],
					   nil]] autorelease],
					
					[[Items newItemsWithImages:
					  [NSArray arrayWithObjects:
					   [UIImage imageNamed:@"5,1_160x160.jpg"],
					   [UIImage imageNamed:@"5,2_160x160.jpg"],
					   [UIImage imageNamed:@"5,3_160x160.jpg"],
					   [UIImage imageNamed:@"5,4_160x160.jpg"],
					   [UIImage imageNamed:@"5,5_160x160.jpg"],
					  nil]] autorelease],
					 
				   nil];
	
	[theItems release];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
	NSLog(@"upload");
	[theSearchBar resignFirstResponder];
}

- (IBAction)upload:(id)sender 
{
	NSLog(@"upload");	
	NSLog(@"skata: '%@'", uploadViewController);
	[super dismissModalViewControllerAnimated:YES];
	NSLog(@"AEGFAEGEAGGAEGAE");
	[self presentModalViewController:uploadViewController animated:YES];    
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
	NSArray *sectionItems = [self.items objectAtIndex:section];
	
	Item *item = [sectionItems objectAtIndex:index];

	NSLog(@"%@", item);

	theBoxCell.itemImageView.image = item.image;
	theBoxCell.itemLabel.text = [NSString stringWithFormat:@"%@", item.when];	

return theBoxCell;
}

-(NSInteger)numberOfSectionsInGridView:(TheBoxUIGridView *)theGridView {
return [self.items count];
}

-(NSUInteger)numberOfColumnsInSection:(NSUInteger)index{
return [[self.items objectAtIndex:index] count];
}

@end
