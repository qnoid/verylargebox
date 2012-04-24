/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 23/11/10.
 *  Contributor(s): .-
 */
#import "HomeUIGridViewController.h"
#import "TheBoxLocationService.h"
#import "TheBoxNotifications.h"
#import "TheBoxUICell.h"
#import "TheBoxQueries.h"
#import "UploadUIViewController.h"
#import "TheBoxBinarySearch.h"
#import "TheBoxPredicates.h"
#import "AFHTTPRequestOperation.h"
#import "DetailsUIViewController.h"
#import "NSCache+TBCache.h"

static NSString* const DEFAULT_ITEM_THUMB = @"default_item_thumb";

@interface HomeUIGridViewController ()
-(id)initWithBundle:(NSBundle *)nibBundleOrNil locationService:(TheBoxLocationService*)locationService;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, strong) TheBoxLocationService *theBoxLocationService;
@property(nonatomic, strong) NSCache *imageCache;
@property(nonatomic, strong) UIImage *defaultItemImage;
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

@synthesize header;
@synthesize gridView = _gridView;
@synthesize items;
@synthesize theBoxLocationService;
@synthesize imageCache;
@synthesize defaultItemImage;

-(id)initWithBundle:(NSBundle *)nibBundleOrNil locationService:(TheBoxLocationService*)locationService
{
    self = [super initWithNibName:@"HomeUIGridViewController" bundle:nibBundleOrNil];
    
    if (self) 
    {
        self.items = [NSMutableArray array];
        self.imageCache = [[NSCache alloc] init];
        self.theBoxLocationService = locationService;
        self.title = @"TheBox";
        NSString* path = [nibBundleOrNil pathForResource:DEFAULT_ITEM_THUMB ofType:@"jpg"];
        self.defaultItemImage = [UIImage imageWithContentsOfFile:path];
        
    }
    
return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];//write test
    UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(upload:)];    
    self.navigationItem.rightBarButtonItem = addItem;    
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
	[self.gridView setNeedsLayout];
}

-(void)didFailOnItemsWithError:(NSError*)error
{
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
}

-(void)didFailOnItemWithError:(NSError*)error
{
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);    
}

/**
 {
 item =     {
 "category_id" = 2;
 "created_at" = "2012-04-18T07:54:50Z";
 id = 122;
 imageURL = "/system/items/images/000/000/122/thumb/.jpg?1334735688";
 "image_content_type" = "image/jpeg";
 "image_file_name" = ".jpg";
 "image_file_size" = 1678390;
 location =         {
 "created_at" = "2012-04-18T07:54:50Z";
 id = 121;
 "item_id" = 122;
 latitude = "55.960976";
 longitude = "-3.189527";
 name = "<null>";
 "updated_at" = "2012-04-18T07:54:50Z";
 };
 name = "";
 "updated_at" = "2012-04-18T07:54:50Z";
 when = "less than a minute ago";
 };
 }
 */
-(void)didSucceedWithItem:(NSDictionary*)item
{
    NSLog(@"%s", __PRETTY_FUNCTION__);    
	NSLog(@"%@", item);
	
	id<TheBoxPredicate> categoryPredicate = [TheBoxPredicates newCategoryIdPredicate];
	TheBoxBinarySearch *search = [[TheBoxBinarySearch alloc] initWithPredicate:categoryPredicate];
	
    item = [item objectForKey:@"item"];
    
    NSUInteger index = [search find:item on:self.items];
    
    if(index == NSNotFound){
        index = 0;
    }
    
	NSMutableDictionary* category = [[self.items objectAtIndex:index] objectForKey:@"category"];

	NSMutableArray* categoryItems = [category objectForKey:@"items"];
	
	[categoryItems insertObject:item atIndex:0];
    
	[category setObject:categoryItems forKey:@"items"];
	
	[self.gridView setNeedsLayout];
}

#pragma mark location based
-(void)didFindPlacemark:(NSNotification *)notification
{
	MKPlacemark *place = [TheBoxNotifications place:notification];
	NSString *city = place.locality;
	
	self.header.text = [NSString stringWithFormat:self.header.text, city];		
}

-(void)didFailWithError:(NSNotification *)notification
{
	NSError *error = [TheBoxNotifications error:notification];
	
	NSLog(@"%@", error);
	
	self.header.text = [NSString stringWithFormat:@"Unable to lookup location"];		
}

#pragma mark datasource
- (UIView *)viewInGridView:(TheBoxUIGridView *)gridView inScrollView:(TheBoxUIScrollView *)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index 
{
	TheBoxUICell *theBoxCell = (TheBoxUICell*) [super viewInGridView:gridView inScrollView:scrollView atRow:row atIndex:index];

	NSArray *categoryItems = [[[self.items objectAtIndex:row] objectForKey:@"category"] objectForKey:@"items"];
		
	//there should be a mapping between the index of the cell and the id of the item
	NSDictionary *item = [categoryItems objectAtIndex:index];
	
	NSString *imageURL = [item objectForKey:@"imageURL"];
	NSString *when = [item objectForKey:@"when"];
	
	UIImage *cachedImage = [self.imageCache tbObjectForKey:[item objectForKey:@"id"] ifNilReturn:self.defaultItemImage];
	
	if (cachedImage == self.defaultItemImage) 
    {
        NSLog(@"cache miss");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            
            NSURL *url = [NSURL URLWithString:imageURL];
            NSData* data = [NSData dataWithContentsOfURL:url];
            
            UIImage* image = [UIImage imageWithData:data];
            
            if(image == nil){
                return;
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.imageCache setObject:image forKey:[item objectForKey:@"id"]];
                theBoxCell.itemImageView.image = image;
            });
        });		
	}

    theBoxCell.itemImageView.image = cachedImage;
	theBoxCell.itemLabel.text = [NSString stringWithFormat:@"%@", when];	

return theBoxCell;
}

-(NSUInteger)numberOfViewsInGridView:(TheBoxUIGridView *)gridView{
return [self.items count];
}

-(NSUInteger)numberOfViewsInGridView:(TheBoxUIGridView *)scrollView atIndex:(NSInteger)index
{
	NSArray *itemsForCategory = [[[self.items objectAtIndex:index] objectForKey:@"category"] objectForKey:@"items"];
	
return [itemsForCategory count];
}

-(CGSize)marginOf:(TheBoxUIScrollView*)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index{
return CGSizeMake(40.0, 0.0);
}

-(void)didSelect:(TheBoxUIScrollView *)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index
{
   	NSArray *categoryItems = [[[self.items objectAtIndex:row] objectForKey:@"category"] objectForKey:@"items"];
    
	//there should be a mapping between the index of the cell and the id of the item
	NSDictionary *item = [categoryItems objectAtIndex:index];
 
    NSLog(@"%s%@", __PRETTY_FUNCTION__, item);
    
    DetailsUIViewController* detailsViewController = [DetailsUIViewController newDetailsViewController:item];

    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBarButton;

    [self.navigationController pushViewController:detailsViewController animated:YES];
}
@end
