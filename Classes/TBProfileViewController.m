//
//  TBProfileViewController.m
//  thebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import "TBProfileViewController.h"
#import "UploadUIViewController.h"
#import "TheBoxPredicates.h"
#import "UIImageView+AFNetworking.h"
#import "TBUserItemView.h"
#import "TheBoxQueries.h"

static NSString* const DEFAULT_ITEM_THUMB = @"default_item_thumb";
static NSString* const DEFAULT_ITEM_TYPE = @"png";

@interface TBProfileViewController ()
@property(nonatomic, strong) NSDictionary* residence;
@property(nonatomic, strong) NSMutableArray* items;
@property(nonatomic, strong) UIImage *defaultItemImage;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil residence:(NSDictionary*)residence;
@end

@implementation TBProfileViewController

+(TBProfileViewController*)newProfileViewController:(NSDictionary*)residence email:(NSString*)email
{
    TBProfileViewController* profileViewController = [[TBProfileViewController alloc] initWithBundle:[NSBundle mainBundle] residence:residence];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text = email;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;    
    profileViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    profileViewController.title = email;
    profileViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"You" image:[UIImage imageNamed:@"user.png"] tag:0];

    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Close"
                                     style:UIBarButtonItemStylePlain
                                     target:profileViewController
                                     action:@selector(close)];
    
    profileViewController.navigationItem.leftBarButtonItem = closeButton;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:profileViewController
                                  action:@selector(addItem)];
    
    profileViewController.navigationItem.rightBarButtonItem = addButton;

return profileViewController;
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil residence:(NSDictionary*)residence
{
    self = [super initWithNibName:NSStringFromClass([TBProfileViewController class]) bundle:nibBundleOrNil];
    
    if (!self) {
        return nil;
    }
    
    self.residence = residence;
    self.items = [NSMutableArray array];
    NSString* path = [nibBundleOrNil pathForResource:DEFAULT_ITEM_THUMB ofType:DEFAULT_ITEM_TYPE];
    self.defaultItemImage = [UIImage imageWithContentsOfFile:path];

return self;
}

-(void)loadView
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];

    UILabel* refreshView = [[UILabel alloc] initWithFrame:CGRectMake(0, -64.0, screenBounds.size.width, 64.0)];
    refreshView.text = @"Release to refresh";
    
    TheBoxUIScrollView* itemsView = [TheBoxUIScrollView newVerticalScrollView:
                                     CGRectMake(CGPointZero.x, CGPointZero.y, screenBounds.size.width, 367.0) viewsOf:350.0];
    
    itemsView.backgroundColor = [UIColor whiteColor];
    itemsView.datasource = self;
    itemsView.scrollViewDelegate = self;
    itemsView.contentInset = UIEdgeInsetsMake(64.0,0.0,0.0,0.0);
    
    self.view = itemsView;
    [self.view addSubview:refreshView];
    self.itemsView = itemsView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[TheBoxQueries newGetItemsGivenUserId:[[self.residence objectForKey:@"user_id"] unsignedIntValue] delegate:self] start];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.itemsView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)close
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)addItem
{
    UploadUIViewController* uploadViewController = [UploadUIViewController newUploadUIViewController:[[self.residence objectForKey:@"user_id"] unsignedIntValue]];
    uploadViewController.createItemDelegate = self;
    
    [self presentModalViewController:uploadViewController animated:YES];
}

#pragma mark TBItemsOperationDelegate
-(void)didSucceedWithItems:(NSMutableArray *)items
{
    self.items = items;
    [self.itemsView setNeedsLayout];
}

-(void)didFailOnItemsWithError:(NSError *)error
{
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
}

/**
{
    "item": {
        "created_at": "2013-02-02T21:53:53Z",
        "id": 223,
        "image_content_type": "image/jpeg",
        "image_file_name": ".jpg",
        "image_file_size": 387436,
        "location_id": 258,
        "updated_at": "2013-02-02T21:53:55Z",
        "user_id": 1,
        "when": "less than a minute ago",
        "imageURL": "http://s3-eu-west-1.amazonaws.com/com.verylargebox.server/items/images/000/000/223/thumb/.jpg",
        "iphoneImageURL": "http://s3-eu-west-1.amazonaws.com/com.verylargebox.server/items/images/000/000/223/iphone/.jpg",
        "location": {
            "created_at": "2013-02-02T19:41:49Z",
            "foursquareid": "4b49b8d1f964a520d57226e3",
            "id": 258,
            "lat": "55.944493",
            "lng": "-3.183833",
            "name": "Kilimanjaro Coffee",
            "updated_at": "2013-02-02T19:41:49Z"
        }
    }
}
 */
-(void)didSucceedWithItem:(NSDictionary*)item
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
	NSLog(@"%@", item);
    [self.items addObject:item];
    [self.itemsView setNeedsLayout];
}

-(void)didFailOnItemWithError:(NSError*)error
{
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
}

#pragma mark TheBoxUIScrollViewDatasource

-(void)didLayoutSubviews:(UIScrollView *)scrollView{
    
}

-(void)viewInScrollView:(TheBoxUIScrollView *)scrollView willAppearBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex{
    
}

-(void)scrollView:(UIScrollView *)scrollView willStopAt:(NSUInteger)index{
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"Will refresh items");
    [[TheBoxQueries newGetItemsGivenUserId:[[self.residence objectForKey:@"user_id"] unsignedIntValue] delegate:self] start];
}

-(NSUInteger)numberOfViewsInScrollView:(TheBoxUIScrollView *)scrollView{
    return [self.items count];
}

-(UIView *)viewInScrollView:(TheBoxUIScrollView *)scrollView ofFrame:(CGRect)frame atIndex:(NSUInteger)index
{
    TBUserItemView* userItemView = [TBUserItemView userItemViewWithOwner:self];
    userItemView.frame = frame;
    
return userItemView;
}

-(void)viewInScrollView:(TheBoxUIScrollView *)scrollView willAppear:(UIView *)view atIndex:(NSUInteger)index
{
    NSDictionary* item = [[self.items objectAtIndex:index] objectForKey:@"item"];
    
    TBUserItemView* userItemView = (TBUserItemView*)view;
    [userItemView.itemImageView setImageWithURL:[NSURL URLWithString:[item objectForKey:@"iphoneImageURL"]] placeholderImage:self.defaultItemImage];
    userItemView.whenLabel.text = [item objectForKey:@"when"];
}

-(void)didSelectView:(TheBoxUIScrollView *)scrollView atIndex:(NSUInteger)index{
    
}
@end
