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
#import "NSArray+Decorator.h"
#import "TheBoxBinarySearch.h"
#import "TheBoxPredicates.h"
#import "AFHTTPRequestOperation.h"
#import "TBCategoriesOperationDelegate.h"
#import "TheBoxLocationService.h"
#import "TBCreateItemOperationDelegate.h"

@interface HomeUIGridViewController ()


@end


@implementation HomeUIGridViewController
{
    NSMutableArray *_items;
    TheBoxLocationService *_theBoxLocationService;
    TheBox *_theBox;
    NSCache *_imageCache;
    
}

@synthesize locationLabel;


-(void) loadView
{
	[super loadView];
	_items = [NSMutableArray array];
    NSCache* cache = [[NSCache alloc] init];
    
	_imageCache = cache;
	
    TheBoxLocationService* aBoxLocationService = [TheBoxLocationService theBox];
    
	_theBoxLocationService = aBoxLocationService;
	[_theBoxLocationService notifyDidFindPlacemark:self];
	[_theBoxLocationService notifyDidFailWithError:self];	
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];

	TheBoxBuilder* builder = [[TheBoxBuilder alloc] init];
	[builder dataParser:nil];
	
	_theBox = [builder build];
	
	
	AFHTTPRequestOperation *operation = [TheBoxQueries newItemsQuery:self];
	[operation start]; 
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

-(void)didSucceedWithItems:(NSMutableArray*)items
{
	_items = items;
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
	
    NSUInteger index = [search find:item on:_items];

    
	NSDictionary* category = [_items objectAtIndex:0];
    
    if(index != -1)
    {
        NSDictionary* item = [_items objectAtIndex:index];
        
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
	
	NSArray *categoryItems = [[[_items objectAtIndex:row] objectForKey:@"category"] objectForKey:@"items"];
		
	//there should be a mapping between the index of the cell and the id of the item
	__unsafe_unretained NSDictionary *item = [categoryItems objectAtIndex:index];
	
	__unsafe_unretained NSString *imageURL = [item objectForKey:@"imageURL"];
	NSString *when = [item objectForKey:@"when"];

	NSLog(@"%@", item);
	
	UIImage *cachedImage = [_imageCache objectForKey:[item objectForKey:@"id"]];
	
	if (cachedImage == nil) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [NSURL URLWithString:imageURL];
            NSData* data = [NSData dataWithContentsOfURL:url];
            
            UIImage* image = [UIImage imageWithData:data];
            [_imageCache setObject:image forKey:[item objectForKey:@"id"]];
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
return [_items count];
}

-(NSUInteger)numberOfViews:(TheBoxUIScrollView*)scrollView atIndex:(NSInteger)index
{
	if ([_items count] == 0) {
		return 0;
	}
	
	if(index >= [_items count]){
		return 0;
	}
	
	NSArray *itemsForCategory = [[[_items objectAtIndex:index] objectForKey:@"category"] objectForKey:@"items"];
	
return [itemsForCategory count];
}

-(CGSize)marginOf:(TheBoxUIScrollView*)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index{
return CGSizeMake(40.0, 0.0);
}

@end
