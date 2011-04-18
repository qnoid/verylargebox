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
#import "TheBoxUISectionView.h"
#import "NSArray+Decorator.h"
#import "TheBoxBinarySearch.h"
#import "TheBoxPredicates.h"

@interface HomeUIGridViewController ()


@end


@implementation HomeUIGridViewController

@synthesize locationLabel;
@synthesize searchBar;
@synthesize theBoxLocationService;

@synthesize items;
@synthesize theBox;
@synthesize imageCache;

- (void) dealloc
{
	[self.locationLabel release];
	[self.searchBar release];
	[self.theBoxLocationService release];
	[self.items release];
	[self.theBoxLocationService release];
	[self.theBox release];
	[self.imageCache release];
	[super dealloc];}

-(void) loadView
{
	[super loadView];
	self.items = [NSMutableArray array];
	self.imageCache = [[NSCache alloc] init];
	
	self.theBoxLocationService = [TheBoxLocationService theBox];
	[self.theBoxLocationService notifyDidFindPlacemark:self];
	[self.theBoxLocationService notifyDidFailWithError:self];	
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];

	TheBoxBuilder* builder = [[TheBoxBuilder alloc] init];
	[builder dataParser:nil];
	[builder responseParserDelegate:self];
	
	self.theBox = [builder build];
	self.theBox.delegate = self;
	
	[builder release];	
	
	id<TheBoxQuery> query = [[TheBoxQueries itemsQuery] retain];
	[theBox query:query];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification;
{
	id<TheBoxQuery> query = [[TheBoxQueries itemsQuery] retain];
	[theBox query:query];	
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
	NSLog(@"upload");
	[theSearchBar resignFirstResponder];
}

- (IBAction)upload:(id)sender 
{
	UploadUIViewController *uploadViewController = [[UploadUIViewController alloc] initWithNibName:@"Upload" bundle:nil];
	uploadViewController.theBoxDelegate = self;
	[self presentModalViewController:uploadViewController animated:YES];   
	[uploadViewController release];
}

#pragma mark thebox

- (void)query:(id<TheBoxQuery>)query ok:(NSString *)response
{
	[query release];
}

- (void)query:(id<TheBoxQuery>)query failed:(NSString *)response
{
	[query release];
}

/*
 * This method will be called after all the callbacks on 
 * [self element:with:] for each item.
 * 
 * At this time the items array has been updated and we can 
 * call [super setNeedsLayout] to update the grid view
 * 
 */
- (void)response:(NSString*)response ok:(id)data
{
	NSLog(@"got %@", data);	
	self.items = data;
	[super setNeedsLayout];
}

- (void)element:(NSInteger)theId with:(id)data
{
	NSLog(@"%@", data);
	
	NSDictionary* item = [data objectForKey:@"item"];
	NSNumber *categoryId = [item objectForKey:@"category_id"];
	
	TheBoxBinarySearch *search = [[TheBoxBinarySearch alloc] init];
	
	id<TheBoxPredicate> categoryPredicate = [TheBoxPredicates newCategoryIdPredicate:categoryId];
	
	NSDictionary* category = [search find:categoryPredicate on:self.items];

	if(category == nil){
		category = [self.items objectAtIndex:0];
	}
	
	NSMutableArray* categoryItems = [[category objectForKey:@"category"] objectForKey:@"items"];
	
	[categoryItems insertObject:item atIndex:0];
	
	[categoryPredicate release];
	[search release];
	[super setNeedsLayout];
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
-(UIView *)sectionView:(TheBoxUISectionView *)sectionView cellForIndex:(NSInteger)index
{		
	TheBoxUICell *theBoxCell = (TheBoxUICell*)[super sectionView:sectionView cellForIndex:index];
	
	NSArray *categoryItems = [[[self.items objectAtIndex:sectionView.index] objectForKey:@"category"] objectForKey:@"items"];
		
	//there should be a mapping between the index of the cell and the id of the item
	NSDictionary *item = [categoryItems objectAtIndex:index];
	
	NSNumber *identifier = [item objectForKey:@"id"];
	
	NSString *imageURL = [NSString stringWithFormat:@"http://0.0.0.0:3000/system/images/%d/thumb/%@.", [identifier intValue], [item objectForKey:@"image_file_name"]];
	NSString *when = [item objectForKey:@"when"];

	NSLog(@"%@", item);
	
	UIImage *cachedImage = [self.imageCache objectForKey:imageURL];
	
	if (cachedImage == nil) {
		NSURL *url = [NSURL URLWithString:imageURL];
		NSData* data = [NSData dataWithContentsOfURL:url];
		
		UIImage* image = [UIImage imageWithData:data];
		
		[self.imageCache setObject:image forKey:imageURL];
		cachedImage = image;
	}
	
	theBoxCell.itemImageView.image = cachedImage;
	theBoxCell.itemLabel.text = [NSString stringWithFormat:@"%@", when];	

return theBoxCell;
}

-(NSInteger)numberOfSectionsInGridView:(TheBoxUIGridView *)theGridView {
return [self.items count];
}

-(NSUInteger)numberOfColumnsInSection:(NSUInteger)index 
{
	if ([self.items count] == 0) {
		return 0;
	}
	
	if(index >= [self.items count]){
		return 0;
	}
	
	NSArray *itemsForCategory = [[[self.items objectAtIndex:index] objectForKey:@"category"] objectForKey:@"items"];
	
return [itemsForCategory count];
}

@end
