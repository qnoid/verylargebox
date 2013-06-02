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
#import "UIScrollView+SVPullToRefresh.h"
#import "UIViewController+TBViewController.h"
#import "QNDAnimations.h"
#import "QNDAnimatedView.h"
#import "TBProgressView.h"

static NSString* const DEFAULT_ITEM_THUMB = @"default_item_thumb";
static NSString* const DEFAULT_ITEM_TYPE = @"png";

@interface TBProfileViewController ()
@property(nonatomic, weak) TheBoxUIScrollView* itemsView;
@property(nonatomic, weak) UIView<QNDAnimatedView> *notificationAnimatedView;
@property(nonatomic, weak) UIProgressView *progressView;
@property(nonatomic, strong) NSDictionary* residence;
@property(nonatomic, strong) NSMutableArray* items;
@property(nonatomic, strong) UIImage *defaultItemImage;
@property(nonatomic, copy) TBUserItemViewGetDirections didTapOnGetDirectionsButton;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil residence:(NSDictionary*)residence didTapOnGetDirectionsButton:(TBUserItemViewGetDirections)didTapOnGetDirectionsButton;
@end

@implementation TBProfileViewController

+(TBProfileViewController*)newProfileViewController:(NSDictionary*)residence email:(NSString*)email
{
    TBProfileViewController* profileViewController = [[TBProfileViewController alloc] initWithBundle:[NSBundle mainBundle]
                                                                                           residence:residence
                                                                         didTapOnGetDirectionsButton:tbUserItemViewGetDirections()];
    
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

-(id)initWithBundle:(NSBundle *)nibBundleOrNil residence:(NSDictionary*)residence didTapOnGetDirectionsButton:(TBUserItemViewGetDirections)didTapOnGetDirectionsButton
{
    self = [super initWithNibName:NSStringFromClass([TBProfileViewController class]) bundle:nibBundleOrNil];
    
    if (!self) {
        return nil;
    }
    
    self.residence = residence;
    self.items = [NSMutableArray array];
    NSString* path = [nibBundleOrNil pathForResource:DEFAULT_ITEM_THUMB ofType:DEFAULT_ITEM_TYPE];
    self.defaultItemImage = [UIImage imageWithContentsOfFile:path];
    self.didTapOnGetDirectionsButton = didTapOnGetDirectionsButton;

return self;
}

-(void)loadView
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];

    UIView<QNDAnimatedView> *notificationAnimatedView =
        [[QNDAnimations new] newViewAnimated:CGRectMake(0, -44, 320, 44)];
    notificationAnimatedView.backgroundColor = [UIColor blackColor];
    notificationAnimatedView.hidden = YES;
    
    TBProgressView *progressView = [[TBProgressView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [notificationAnimatedView addSubview:progressView];
    
    TheBoxUIScrollView* itemsView = [[[[TheBoxUIScrollViewBuilder alloc] initWith:
                                     CGRectMake(CGPointZero.x, CGPointZero.y, screenBounds.size.width, 367.0) viewsOf:320.0] allowSelection] newVerticalScrollView];
    
    itemsView.backgroundColor = [UIColor whiteColor];
    itemsView.datasource = self;
    itemsView.scrollViewDelegate = self;
    itemsView.scrollsToTop = YES;

    self.view = itemsView;
    [self.view addSubview:notificationAnimatedView];
    self.itemsView = itemsView;
    self.notificationAnimatedView = notificationAnimatedView;
    self.progressView = progressView.progressView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    __weak TBProfileViewController *wself = self;
    
    [self.itemsView addPullToRefreshWithActionHandler:^{
        [[TheBoxQueries newGetItemsGivenUserId:[[wself.residence objectForKey:@"user_id"] unsignedIntValue] delegate:wself] start];
    }];
    
    [self.itemsView triggerPullToRefresh];
}

-(void)viewWillAppear:(BOOL)animated
{
}

-(void)viewWillDisappear:(BOOL)animated
{
}

-(void)viewDidAppear:(BOOL)animated
{
    //[self.itemsView setContentOffset:CGPointMake(0, 0) animated:YES];
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
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, items);
    self.items = items;
    [self.itemsView setNeedsLayout];
    [self.itemsView.pullToRefreshView stopAnimating];
}

-(void)didFailOnItemsWithError:(NSError *)error
{
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
    [self.itemsView.pullToRefreshView stopAnimating];
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

-(void)didStartUploadingItem
{
    self.notificationAnimatedView.hidden = NO;
    [self.notificationAnimatedView animateWithDuration:0.5 animation:^(UIView *view) {
        view.frame = CGRectMake(0, 0, 320, 44);
    }];
}

-(void)bytesWritten:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    [self.progressView setProgress:(float)totalBytesWritten / (float)totalBytesExpectedToWrite
                          animated:YES];
}

-(void)didSucceedWithItem:(NSDictionary*)item
{
    [self.notificationAnimatedView rewind:^(BOOL finished) {
        self.notificationAnimatedView.hidden = YES;
    }];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
	NSLog(@"%@", item);
    [self.items addObject:item];
    [self.itemsView setNeedsLayout];
}

-(void)didFailOnItemWithError:(NSError*)error
{
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
}

#pragma mark TheBoxUIScrollViewDelegate

-(void)didLayoutSubviews:(UIScrollView *)scrollView{
    
}

-(void)viewInScrollView:(TheBoxUIScrollView *)scrollView willAppearBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex{
    
}

-(void)scrollView:(UIScrollView *)scrollView willStopAt:(NSUInteger)index{
    
}

-(void)didSelectView:(TheBoxUIScrollView *)scrollView atIndex:(NSUInteger)inde point:(CGPoint)point {
    
}

#pragma mark TheBoxUIScrollViewDatasource

-(NSUInteger)numberOfViewsInScrollView:(TheBoxUIScrollView *)scrollView{
    return [self.items count];
}

-(UIView *)viewInScrollView:(TheBoxUIScrollView *)scrollView ofFrame:(CGRect)frame atIndex:(NSUInteger)index {
return [[TBUserItemView alloc] initWithFrame:frame];
}

-(void)viewInScrollView:(TheBoxUIScrollView *)scrollView willAppear:(UIView *)view atIndex:(NSUInteger)index
{
    NSDictionary* item = [[self.items objectAtIndex:index] objectForKey:@"item"];
    
    TBUserItemView* userItemView = (TBUserItemView*)view;
    [userItemView.itemImageView setImageWithURL:[NSURL URLWithString:[item objectForKey:@"iphoneImageURL"]] placeholderImage:self.defaultItemImage];
    userItemView.whenLabel.text = [item objectForKey:@"when"];
    
    /**
     {
     "created_at" = "2013-03-07T19:58:26Z";
     foursquareid = 4b082a2ff964a520380523e3;
     id = 265;
     lat = "55.94223";
     lng = "-3.18421";
     name = "The Dagda Bar";
     "updated_at" = "2013-03-07T19:58:26Z";
     }
    */
    NSDictionary *location = [item objectForKey:@"location"];
    
    id name = [location objectForKey:@"name"];
    if([[NSNull null] isEqual:name]){
        name = @"";
    }

    userItemView.storeLabel.text = name;
    
    __weak TBProfileViewController *wself = self;
    
    userItemView.didTapOnGetDirectionsButton = ^(CLLocationCoordinate2D destination, NSDictionary *options){
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@, %@", [self class], @"didTapOnGetDirectionsButton"]];

        wself.didTapOnGetDirectionsButton(CLLocationCoordinate2DMake([[location objectForKey:@"lat"] floatValue],
                                                                     [[location objectForKey:@"lng"] floatValue]),
                                          location);
    };

}

@end
