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
#import "TheBoxUICell.h"
#import "TheBoxQueries.h"
#import "UploadUIViewController.h"
#import "TheBoxBinarySearch.h"
#import "TheBoxPredicates.h"
#import "AFHTTPRequestOperation.h"
#import "DetailsUIViewController.h"
#import "NSArray+Decorator.h"
#import "UIImageView+AFNetworking.h"
#import "NSDictionary+TBDictionary.h"
#import "TheBoxUICell.h"
#import "TheBoxUIScrollView.h"
#import "TBItemView.h"

static NSString* const DEFAULT_ITEM_THUMB = @"default_item_thumb";
static NSString* const DEFAULT_ITEM_TYPE = @"png";

@interface HomeUIGridViewController ()
-(id)initWithBundle:(NSBundle *)nibBundleOrNil locationService:(TheBoxLocationService*)locationService;
@property(nonatomic, strong) NSArray *locations;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, strong) TheBoxLocationService *theBoxLocationService;
@property(nonatomic, strong) UIImage *defaultItemImage;

@end


@implementation HomeUIGridViewController

+(HomeUIGridViewController*)newHomeGridViewController
{    
    HomeUIGridViewController* homeGridViewController = [[HomeUIGridViewController alloc] initWithBundle:[NSBundle mainBundle] locationService:nil];
    
    homeGridViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Edinburgh" image:[UIImage imageNamed:@"group.png"] tag:0];

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:homeGridViewController selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    
return homeGridViewController;
}


-(id)initWithBundle:(NSBundle *)nibBundleOrNil locationService:(TheBoxLocationService*)locationService
{
    self = [super initWithNibName:nil bundle:nibBundleOrNil];
    
    if (self) 
    {
        self.locations = [NSArray array];
        self.items = [NSMutableArray array];

        self.theBoxLocationService = locationService;
        self.title = @"thebox";
        NSString* path = [nibBundleOrNil pathForResource:DEFAULT_ITEM_THUMB ofType:DEFAULT_ITEM_TYPE];
        self.defaultItemImage = [UIImage imageWithContentsOfFile:path];
    }
    
return self;
}

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    TheBoxUIScrollView* locationsView = [TheBoxUIScrollView newHorizontalScrollView:CGRectMake(CGPointZero.x, CGPointZero.y, screenBounds.size.width, 44.0) viewsOf:100];
    locationsView.datasource = self;
    locationsView.scrollViewDelegate = self;

    TheBoxUIScrollView* itemsView = [TheBoxUIScrollView newHorizontalScrollView:CGRectMake(CGPointZero.x, 44.0, screenBounds.size.width, 323.0) viewsOf:160.0];
    
    itemsView.datasource = self;
    itemsView.scrollViewDelegate = self;
    
    [view addSubview:locationsView];
    [view addSubview:itemsView];
    
    self.view = view;
    self.locationsView = locationsView;
    self.itemsView = itemsView;
}
-(void)viewDidLoad
{
    [super viewDidLoad];

	[[TheBoxQueries newGetLocations:self] start];
    
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

}

#pragma mark application events

- (void)applicationDidBecomeActive:(NSNotification *)notification;
{
	[[TheBoxQueries newItemsQuery:self] start];
}

#pragma mark TBLocationOperationDelegate

-(void)didSucceedWithLocations:(NSArray*)locations
{
    self.locations = locations;
    [self.locationsView flashScrollIndicators];
    [self.locationsView setNeedsLayout];
    [self.locationsView layoutIfNeeded];
}

-(void)didFailOnLocationWithError:(NSError*)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark TheBoxUIScrollViewDatasource

-(NSUInteger)numberOfViewsInScrollView:(TheBoxUIScrollView *)scrollView
{
    if(![self.locationsView isEqual:scrollView]){
       return [self.items count];
    }
    
return [self.locations count];
}

- (UIView *)viewInScrollView:(TheBoxUIScrollView *)scrollView ofFrame:(CGRect)frame atIndex:(NSInteger)index
{
    if(![self.locationsView isEqual:scrollView])
    {
        TBItemView* itemView = [TBItemView itemViewWithOwner:self];
        itemView.frame = frame;
        itemView.itemComments.dataSource = self;
    return itemView;
    }

    UILabel *storeLabel = [[UILabel alloc] initWithFrame:frame];
    storeLabel.numberOfLines = 0;
    storeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
return storeLabel;
}

#pragma mark TheBoxUIScrollViewDelegate

-(void)viewInScrollView:(TheBoxUIScrollView *)scrollView willAppearBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex
{
    if(![self.locationsView isEqual:scrollView]) {
        return;
    }

    NSUInteger average = (maximumVisibleIndex-1) + minimumVisibleIndex >> 1;
    
    NSDictionary* location = [self.locations objectAtIndex:average];
    
    [self locationInScrollView:scrollView willAppear:location];
}

-(void)viewInScrollView:(TheBoxUIScrollView *)scrollView willAppear:(UIView *)view atIndex:(NSUInteger)index
{
    if(![self.locationsView isEqual:scrollView])
    {
        NSDictionary *item = [[[self items] objectAtIndex:index] objectForKey:@"item"];

        TBItemView *imageView = (TBItemView*)view;
        //@"http://s3-eu-west-1.amazonaws.com/com.verylargebox.server/items/images/000/000/020/thumb/.jpg"
        [imageView.itemImageView setImageWithURL:[NSURL URLWithString:[item objectForKey:@"imageURL"]] placeholderImage:self.defaultItemImage];

    return;
    }

    NSDictionary *location = [[[self locations] objectAtIndex:index] objectForKey:@"location"];

    UILabel *label = (UILabel*)view;
    id name = [location objectForKey:@"name"];
    
    if([[NSNull null] isEqual:name]){
        name = @"";
    }
    
    label.text = name;
}

-(void)locationInScrollView:(TheBoxUIScrollView *)scrollView willAppear:(id)location
{
    NSDictionary* currentLocation = location;
    NSUInteger locationId = [[[currentLocation objectForKey:@"location"] objectForKey:@"id"] unsignedIntValue];

    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:
                              CGRectMake(CGPointZero.x, CGPointZero.y, [[UIScreen mainScreen] bounds].size.width, 323.0)];
    
    activityIndicator.tag = locationId;
    activityIndicator.backgroundColor = [UIColor blackColor];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [activityIndicator startAnimating];
    
    [self.itemsView addSubview:activityIndicator];
    [self.itemsView bringSubviewToFront:activityIndicator];
    
    [[TheBoxQueries newGetItemsGivenLocationId:locationId delegate:self] start];
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetic" size:8.0];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    cell.textLabel.text = @[@"10/01/2013 09:42 foo: fffffffff", @"10/01/2013 09:41 bar: bbbbbbbbb", @"10/01/2013 09:40 car: cccccccccc"][indexPath.row];
    
return cell;
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

-(void)didSucceedWithItems:(NSMutableArray*) items
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, items);

    [self.itemsView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(![[UIActivityIndicatorView class] isEqual:[obj class]]){
            return;
        }
        
        UIActivityIndicatorView *activityIndicator = obj;
        
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
    }];
    
	self.items = items;
    [self.itemsView flashScrollIndicators];
    [self.itemsView setNeedsLayout];
    [self.itemsView layoutIfNeeded];
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
 "created_at" = "2012-11-04T15:33:00Z";
 id = 213;
 imageURL = "http://s3-eu-west-1.amazonaws.com/com.verylargebox.server/items/images/000/000/213/thumb/.jpg?1352043179";
 "image_content_type" = "image/jpeg";
 "image_file_name" = ".jpg";
 "image_file_size" = 357962;
 iphoneImageURL = "http://s3-eu-west-1.amazonaws.com/com.verylargebox.server/items/images/000/000/213/iphone/.jpg?1352043179";
 location =         {
 "created_at" = "2012-11-04T15:00:25Z";
 foursquareid = 4b05881ff964a520ffb222e3;
 id = 250;
 lat = "55.94886495227988";
 lng = "-3.187588255306524";
 name = "The Cabaret Voltaire";
 "updated_at" = "2012-11-04T15:00:25Z";
 };
 "location_id" = 250;
 "updated_at" = "2012-11-04T15:33:00Z";
 when = "less than a minute ago";
 };
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
}

#pragma mark datasource
- (UIView *)gridView:(TheBoxUIGridView *)gridView viewOf:(UIView *)viewOf ofFrame:(CGRect)frame atRow:(NSUInteger)row atIndex:(NSUInteger)index 
{
    UIView* cell = [TheBoxUICell loadWithOwner:self];
    
    cell.frame = frame;

return cell;
}

-(void)gridView:(TheBoxUIGridView *)gridView viewOf:(UIView *)viewOf atRow:(NSInteger)row atIndex:(NSInteger)index willAppear:(UIView *)view
{
    TheBoxUICell *theBoxCell = (TheBoxUICell*)view;
    
	NSArray *locationItems = [[[self.items objectAtIndex:row] objectForKey:@"location"] objectForKey:@"items"];
    
	//there should be a mapping between the index of the cell and the id of the item
	NSDictionary *item = [locationItems objectAtIndex:index];
	
	NSString *imageURL = [item objectForKey:@"imageURL"];
	NSString *when = [item objectForKey:@"when"];
	
    [theBoxCell.itemImageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:self.defaultItemImage];
	theBoxCell.itemLabel.text = [NSString stringWithFormat:@"%@", when];	
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

-(void)didSelect:(TheBoxUIGridView *)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index
{
   	NSArray *locationItems = [[[self.items objectAtIndex:row] objectForKey:@"location"] objectForKey:@"items"];
    
	//there should be a mapping between the index of the cell and the id of the item
	NSMutableDictionary *item = [locationItems objectAtIndex:index];
 
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@, %s", [self class], __PRETTY_FUNCTION__]];
    
    DetailsUIViewController* detailsViewController = [DetailsUIViewController newDetailsViewController:item];
    detailsViewController.hidesBottomBarWhenPushed = YES;

    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBarButton;

    [self.navigationController pushViewController:detailsViewController animated:YES];
}

-(void)didSelectView:(TheBoxUIScrollView*)scrollView atIndex:(NSUInteger)index
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
