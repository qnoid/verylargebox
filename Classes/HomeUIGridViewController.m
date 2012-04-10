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
#import "TheBoxQueries.h"
#import "UploadUIViewController.h"
#import "NSArray+Decorator.h"
#import "TheBoxBinarySearch.h"
#import "TheBoxPredicates.h"
#import "AFHTTPRequestOperation.h"
#import "TBCategoriesOperationDelegate.h"
#import "TheBoxLocationService.h"
#import "TBCreateItemOperationDelegate.h"

@interface HomeUIGridViewController ()
-(id)initWithBundle:(NSBundle *)nibBundleOrNil locationService:(TheBoxLocationService*)locationService;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, strong) TheBoxLocationService *theBoxLocationService;
@property(nonatomic, strong) NSCache *imageCache;
@end


@implementation HomeUIGridViewController

+(HomeUIGridViewController*)newHomeGridViewController
{    
    TheBoxLocationService *theBoxLocationService = [TheBoxLocationService theBox];

    HomeUIGridViewController* homeGridViewController = [[HomeUIGridViewController alloc] initWithBundle:[NSBundle mainBundle] locationService:theBoxLocationService];
    [theBoxLocationService notifyDidFindPlacemark:homeGridViewController];
	[theBoxLocationService notifyDidFailWithError:homeGridViewController];	

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:homeGridViewController selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    
	AFHTTPRequestOperation *operation = [TheBoxQueries newItemsQuery:homeGridViewController];
	[operation start]; 
    
return homeGridViewController;
}

@synthesize locationLabel;
@synthesize items;
@synthesize theBoxLocationService;
@synthesize imageCache;

-(id)initWithBundle:(NSBundle *)nibBundleOrNil locationService:(TheBoxLocationService*)locationService
{
    self = [super initWithNibName:@"HomeUIGridViewController" bundle:nibBundleOrNil];
    
    if (self) 
    {
        self.items = [NSMutableArray array];
        self.imageCache = [[NSCache alloc] init];
        self.theBoxLocationService = locationService;
    }
    
return self;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification;
{
	AFHTTPRequestOperation *operation = [TheBoxQueries newItemsQuery:self];
	[operation start];
}

- (IBAction)upload:(id)sender 
{
	UploadUIViewController *uploadViewController = [UploadUIViewController newUploadUIViewController];
	uploadViewController.createItemDelegate = self;
	[self presentModalViewController:uploadViewController animated:YES];   
}

#pragma mark thebox

/*
 * This method will be called after all the callbacks on 
 * [self element:with:] for each item.
 * 
 * At this time the items array has been updated and we can 
 * call [super setNeedsLayout] to update the grid view
 * 
 
     [
     {
     "category": {
     "created_at": "2012-03-31T16:15:01Z",
     "id": 1,
     "name": "hats",
     "updated_at": "2012-03-31T16:15:01Z",
         "items": [
         {
         "category_id": 1,
         "created_at": "2012-03-31T16:15:01Z",
         "id": 1,
         "image_content_type": "image/jpeg",
         "image_file_name": "hat.jpg",
         "image_file_size": 1938325,
         "name": "hat",
         "updated_at": "2012-03-31T16:15:01Z",
         "when": "about 1 hour ago",
         "imageURL": "http://s3-eu-west-1.amazonaws.com/com.verylargebox.server/items/images/000/000/001/thumb/hat.jpg"
         }
         ]
         }
     }
     ]
 */

-(void)didSucceedWithItems:(NSMutableArray*) _items
{
	self.items = _items;
	[super reloadData];
}

-(void)didFailOnItemsWithError:(NSError*)error
{
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
}

-(void)didFailOnItemWithError:(NSError*)error
{
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);    
}

-(void)didSucceedWithItem:(NSDictionary*)data
{
	NSLog(@"%@", data);
	
	NSDictionary* item = [data objectForKey:@"item"];
	
	TheBoxBinarySearch *search = [[TheBoxBinarySearch alloc] init];
	
	id<TheBoxPredicate> categoryPredicate = [TheBoxPredicates newCategoryIdPredicate];
	
    NSUInteger index = [search find:item on:self.items];

    
	NSDictionary* category = [self.items objectAtIndex:0];
    
    if(index != -1)
    {
        NSDictionary* item = [self.items objectAtIndex:index];
        
        category = [item objectForKey:@"category"];        
    }

	NSMutableArray* categoryItems = [[category objectForKey:@"category"] objectForKey:@"items"];
	
	[categoryItems insertObject:item atIndex:0];
    
	[[category objectForKey:@"category"] setObject:categoryItems forKey:@"items"];
	
	[super reloadData];
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
-(UIView *)viewOf:(TheBoxUIScrollView *)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index
{		
	TheBoxUICell *theBoxCell = (TheBoxUICell*)[super viewOf:scrollView atRow:row atIndex:index];
	
	NSArray *categoryItems = [[[self.items objectAtIndex:row] objectForKey:@"category"] objectForKey:@"items"];
		
	//there should be a mapping between the index of the cell and the id of the item
	NSDictionary *item = [categoryItems objectAtIndex:index];
	
	NSString *imageURL = [item objectForKey:@"imageURL"];
	NSString *when = [item objectForKey:@"when"];

	NSLog(@"%@", item);
	
	UIImage *cachedImage = [self.imageCache objectForKey:[item objectForKey:@"id"]];
	
	if (cachedImage == nil) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [NSURL URLWithString:imageURL];
            NSData* data = [NSData dataWithContentsOfURL:url];
            
            UIImage* image = [UIImage imageWithData:data];
            [self.imageCache setObject:image forKey:[item objectForKey:@"id"]];
            theBoxCell.itemImageView.image = image;
        });		
	}
    else {
        theBoxCell.itemImageView.image = cachedImage;
    }
	
	theBoxCell.itemLabel.text = [NSString stringWithFormat:@"%@", when];	

return theBoxCell;
}

-(NSUInteger)numberOfViews:(TheBoxUIScrollView *)gridView{
return [self.items count];
}

-(NSUInteger)numberOfViews:(TheBoxUIScrollView*)scrollView atIndex:(NSInteger)index
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

-(CGSize)marginOf:(TheBoxUIScrollView*)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index{
return CGSizeMake(40.0, 0.0);
}

@end
