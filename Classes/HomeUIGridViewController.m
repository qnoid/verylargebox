/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 23/11/2010.
 *  Contributor(s): .-
 */
#import "HomeUIGridViewController.h"
#import "TheBoxNotifications.h"
#import "TheBoxUICell.h"
#import "TheBoxQueries.h"
#import "UploadUIViewController.h"
#import "TheBoxBinarySearch.h"
#import "TheBoxPredicates.h"
#import "AFHTTPRequestOperation.h"
#import "DetailsUIViewController.h"
#import "NSCache+TBCache.h"
#import "NSArray+Decorator.h"
#import "UIImageView+AFNetworking.h"
#import "NSDictionary+TBDictionary.h"

static NSString* const DEFAULT_ITEM_THUMB = @"default_item_thumb";
static NSString* const DEFAULT_ITEM_TYPE = @"png";

@interface HomeUIGridViewController ()
-(id)initWithBundle:(NSBundle *)nibBundleOrNil locationService:(TheBoxLocationService*)locationService;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, strong) TheBoxLocationService *theBoxLocationService;
@property(nonatomic, strong) UIImage *defaultItemImage;
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end


@implementation HomeUIGridViewController

+(HomeUIGridViewController*)newHomeGridViewController
{    
    HomeUIGridViewController* homeGridViewController = [[HomeUIGridViewController alloc] initWithBundle:[NSBundle mainBundle] locationService:nil];

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:homeGridViewController selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    
	AFHTTPRequestOperation *operation = [TheBoxQueries newItemsQuery:homeGridViewController];
	[operation start]; 
    
return homeGridViewController;
}

@synthesize gridView = _gridView;
@synthesize items;
@synthesize theBoxLocationService;
@synthesize defaultItemImage;
@synthesize activityIndicator;

-(id)initWithBundle:(NSBundle *)nibBundleOrNil locationService:(TheBoxLocationService*)locationService
{
    self = [super initWithNibName:@"HomeUIGridViewController" bundle:nibBundleOrNil];
    
    if (self) 
    {
        self.items = [NSMutableArray array];

        self.theBoxLocationService = locationService;
        self.title = @"thebox";
        NSString* path = [nibBundleOrNil pathForResource:DEFAULT_ITEM_THUMB ofType:DEFAULT_ITEM_TYPE];
        self.defaultItemImage = [UIImage imageWithContentsOfFile:path];
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:
                                  CGRectMake(CGPointZero.x, 
                                             44, 
                                             self.view.frame.size.width, 
                                             self.view.frame.size.height)];
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.view addSubview:activityIndicator];
    }
    
return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                     target:self
                                     action:@selector(launchFeedback)];
    self.navigationItem.leftBarButtonItem = actionButton;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                     target:self
                                     action:@selector(addItem)];
    
    self.navigationItem.rightBarButtonItem = addButton;

}

-(void)launchFeedback {
    [TestFlight openFeedbackView];
}

-(void)addItem 
{
    UploadUIViewController* uploadViewController = [UploadUIViewController newUploadUIViewController];
    uploadViewController.createItemDelegate = self;
    
    [self presentModalViewController:uploadViewController animated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.activityIndicator startAnimating];
}

#pragma mark application events

- (void)applicationDidBecomeActive:(NSNotification *)notification;
{
	AFHTTPRequestOperation *operation = [TheBoxQueries newItemsQuery:self];
	[operation start];
}

#pragma mark thebox

/*
 * This method will be called after all the callbacks on 
 * [self element:with:] for each item.
 * 
 * At this time the items array has been updated and we can 
 * call [self.gridView reload] to update the grid view
 * 
 [
 {
 "location": {
 "created_at": "2012-05-05T11:29:19Z",
 "distance": null,
 "id": 11,
 "lat": "55.94790220908779",
 "lng": "-3.186249732971191",
 "name": "Blackwell's",
 "updated_at": "2012-05-05T11:29:19Z",
 "items": [
     {
         "created_at": "2012-05-05T11:35:05Z",
         "id": 30,
         "image_content_type": "image/jpeg",
         "image_file_name": ".jpg",
         "image_file_size": 277323,
         "location_id": 11,
         "updated_at": "2012-05-05T11:35:05Z",
         "when": "8 days ago",
         "imageURL": "/system/items/images/000/000/030/thumb/.jpg",
         "iphoneImageURL": "/system/items/images/000/000/030/iphone/.jpg",
         "location": {
             "created_at": "2012-05-05T11:29:19Z",
             "distance": null,
             "id": 11,
             "lat": "55.94790220908779",
             "lng": "-3.186249732971191",
             "name": "Blackwell's",
             "updated_at": "2012-05-05T11:29:19Z"
        }
     },
     {
         "created_at": "2012-05-05T11:34:46Z",
         "id": 29,
         "image_content_type": "image/jpeg",
         "image_file_name": ".jpg",
         "image_file_size": 386772,
         "location_id": 11,
         "updated_at": "2012-05-05T11:34:46Z",
         "when": "8 days ago",
         "imageURL": "/system/items/images/000/000/029/thumb/.jpg",
         "iphoneImageURL": "/system/items/images/000/000/029/iphone/.jpg",
         "location": {
             "created_at": "2012-05-05T11:29:19Z",
             "distance": null,
             "id": 11,
             "lat": "55.94790220908779",
             "lng": "-3.186249732971191",
             "name": "Blackwell's",
             "updated_at": "2012-05-05T11:29:19Z"
         }
     }
     }]
 */

-(void)didSucceedWithItems:(NSMutableArray*) _items
{
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    
	self.items = _items;
	[self.gridView reload];
}

-(void)didFailOnItemsWithError:(NSError*)error
{
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);

    AFHTTPRequestOperation *operation = [TheBoxQueries newItemsQuery:self];
	[operation start];
}

-(void)didFailOnItemWithError:(NSError*)error
{
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);    
}

/**
 {
 "item": {
     "created_at": "2012-05-05T10:59:54Z",
     "id": 1,
     "image_content_type": "image/jpeg",
     "image_file_name": ".jpg",
     "image_file_size": 283149,
     "location_id": 171,
     "updated_at": "2012-05-05T10:59:54Z",
     "when": "8 days ago",
     "imageURL": "/system/items/images/000/000/001/thumb/.jpg",
     "iphoneImageURL": "/system/items/images/000/000/001/iphone/.jpg",
     "location": {
         "created_at": "2012-05-07T08:31:07Z",
         "distance": null,
         "id": 171,
         "lat": "55.945658",
         "lng": "-3.189601",
         "name": "Napiers",
         "updated_at": "2012-05-07T08:31:07Z"
     }
     }
 } */
-(void)didSucceedWithItem:(NSDictionary*)item
{
    NSLog(@"%s", __PRETTY_FUNCTION__);    
	NSLog(@"%@", item);
	
	id<TheBoxPredicate> locationPredicate = [TheBoxPredicates newLocationIdPredicate];
	TheBoxBinarySearch *search = [[TheBoxBinarySearch alloc] initWithPredicate:locationPredicate];
	
    item = [item objectForKey:@"item"];
    
    NSUInteger index = [search find:item on:self.items];
    
    if(index == NSNotFound){
        index = [self.items count];
        [self.items addObject:[NSMutableDictionary dictionaryWithObject:[item objectForKey:@"location"] forKey:@"location"]];
    }
    
	NSMutableDictionary* location = [[self.items objectAtIndex:index] objectForKey:@"location"];

	NSMutableArray* locationItems = [location tbObjectForKey:@"items" ifNil:[NSMutableArray arrayWithCapacity:1]];
	
	[locationItems insertObject:item atIndex:0];
    
	[location setObject:locationItems forKey:@"items"];
	
	[self.gridView reload];
}

#pragma mark datasource
- (UIView *)viewInGridView:(TheBoxUIGridView *)gridView inScrollView:(TheBoxUIScrollView *)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index 
{
	TheBoxUICell *theBoxCell = (TheBoxUICell*) [super viewInGridView:gridView inScrollView:scrollView atRow:row atIndex:index];

	NSArray *locationItems = [[[self.items objectAtIndex:row] objectForKey:@"location"] objectForKey:@"items"];
		
	//there should be a mapping between the index of the cell and the id of the item
	NSDictionary *item = [locationItems objectAtIndex:index];
	
	NSString *imageURL = [item objectForKey:@"imageURL"];
	NSString *when = [item objectForKey:@"when"];
	
    [theBoxCell.itemImageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:self.defaultItemImage];
	theBoxCell.itemLabel.text = [NSString stringWithFormat:@"%@", when];	

return theBoxCell;
}

-(NSUInteger)numberOfViewsInGridView:(TheBoxUIGridView *)gridView{
return [self.items count];
}

-(NSUInteger)numberOfViewsInGridView:(TheBoxUIGridView *)scrollView atIndex:(NSInteger)index
{
	NSArray *itemsForLocation = [[[self.items objectAtIndex:index] objectForKey:@"location"] objectForKey:@"items"];
    
    if([itemsForLocation tbIsEmpty]){
        return 0;
    }
	
return [itemsForLocation count];
}

-(CGSize)marginOf:(TheBoxUIScrollView*)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index{
return CGSizeMake(40.0, 0.0);
}

-(void)didSelect:(TheBoxUIScrollView *)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index
{
   	NSArray *locationItems = [[[self.items objectAtIndex:row] objectForKey:@"location"] objectForKey:@"items"];
    
	//there should be a mapping between the index of the cell and the id of the item
	NSMutableDictionary *item = [locationItems objectAtIndex:index];
 
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@, %s", [self class], __PRETTY_FUNCTION__]];
    
    DetailsUIViewController* detailsViewController = [DetailsUIViewController newDetailsViewController:item];

    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBarButton;

    [self.navigationController pushViewController:detailsViewController animated:YES];
}

-(NSUInteger)numberOfViewsInScrollView:(TheBoxUIScrollView *)scrollView {
return [self.items count];
}

@end
