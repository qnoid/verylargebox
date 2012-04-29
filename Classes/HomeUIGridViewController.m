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
#import "TheBoxUIAddView.h"

static NSString* const DEFAULT_ITEM_THUMB = @"default_item_thumb";
static NSString* const DEFAULT_ITEM_TYPE = @"png";
static CGFloat const kAddButtonHeight = 196.0;

@interface HomeUIGridViewController ()
-(id)initWithBundle:(NSBundle *)nibBundleOrNil locationService:(TheBoxLocationService*)locationService;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, strong) TheBoxLocationService *theBoxLocationService;
@property(nonatomic, strong) NSCache *imageCache;
@property(nonatomic, strong) UIImage *defaultItemImage;
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorForAddingSection;
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

@synthesize headerSection;
@synthesize addIcon;
@synthesize addButton;
@synthesize gridView = _gridView;
@synthesize scrollView = _scrollView;
@synthesize items;
@synthesize theBoxLocationService;
@synthesize imageCache;
@synthesize defaultItemImage;
@synthesize activityIndicatorForAddingSection;
@synthesize activityIndicator;

-(id)initWithBundle:(NSBundle *)nibBundleOrNil locationService:(TheBoxLocationService*)locationService
{
    self = [super initWithNibName:@"HomeUIGridViewController" bundle:nibBundleOrNil];
    
    if (self) 
    {
        self.items = [NSMutableArray array];
        self.imageCache = [[NSCache alloc] init];
        self.theBoxLocationService = locationService;
        self.title = @"TheBox";
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
    self.scrollView.scrollEnabled = NO;
    
    [self.gridView addObserver:self
                  forKeyPath:@"contentOffset"
                     options:NSKeyValueObservingOptionNew
                     context:NULL];    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.activityIndicator startAnimating];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    [self.scrollView setValue:[change valueForKey:NSKeyValueChangeNewKey] forKey:keyPath];
}

#pragma mark application events

- (void)applicationDidBecomeActive:(NSNotification *)notification;
{
	AFHTTPRequestOperation *operation = [TheBoxQueries newItemsQuery:self];
	[operation start];
}
#pragma IBActions
- (IBAction)addCategory:(id)sender
{
    self.addButton.enabled = NO;
    self.addIcon.hidden = YES;
    self.activityIndicatorForAddingSection = [[UIActivityIndicatorView alloc]initWithFrame:self.addIcon.frame];
    [self.activityIndicatorForAddingSection setBackgroundColor:[UIColor clearColor]];
    [self.activityIndicatorForAddingSection setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.headerSection addSubview:self.activityIndicatorForAddingSection];
    [self.activityIndicatorForAddingSection startAnimating];

    NSString* name = [NSString stringWithFormat:@"%d",[self.items count] + 1];
    AFHTTPRequestOperation* createCategoryOperation = [TheBoxQueries newCreateCategoryQuery:name delegate:self];
    
    [createCategoryOperation start];
}

#pragma mark TBCreateCategoryOperationDelegate

-(void)didSucceedWithCategory:(NSDictionary*)category
{
    self.addButton.enabled = YES;
    self.addIcon.hidden = NO;
    [self.activityIndicatorForAddingSection stopAnimating];
    [self.activityIndicatorForAddingSection removeFromSuperview];

    [self.items addObject:category];
    [self.gridView scrollToIndex:[self.items count]-1 animated:YES];
}

-(void)didFailOnCreateCategoryWithError:(NSError*)error
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);   
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
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    
	self.items = _items;
	[self.gridView reload];
    [self.scrollView setNeedsLayout];
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
	
	[self.gridView reload];
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

-(NSUInteger)numberOfViewsInScrollView:(TheBoxUIScrollView *)scrollView {
return [self.items count];
}

-(void)viewInScrollView:(TheBoxUIScrollView *)scrollView atIndex:(NSUInteger)index willAppear:(UIView*)view{}

-(UIView*)viewInScrollView:(TheBoxUIScrollView *)scrollView atIndex:(NSInteger)index
{
    TheBoxUIAddView *view = (TheBoxUIAddView*)[scrollView dequeueReusableView];
 
    CGRect frame = CGRectMake(
                              scrollView.bounds.origin.x, 
                              index * [self whatSize:scrollView], 
                              self.scrollView.frame.size.width, 
                              [self whatSize:scrollView]);

    if(view == nil) {
		view = [TheBoxUIAddView loadWithOwner:self];
    }
    
    view.frame = frame;

    view.category = [[self.items objectAtIndex:index] objectForKey:@"category"];
    view.createItemDelegate = self;

return view;
}

-(CGFloat)whatSize:(TheBoxUIScrollView *)scrollView{
    return kAddButtonHeight;
}

@end
