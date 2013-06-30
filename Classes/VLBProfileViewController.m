//
//  VLBProfileViewController.m
//  thebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import "VLBProfileViewController.h"
#import "VLBTakePhotoViewController.h"
#import "VLBPredicates.h"
#import "UIImageView+AFNetworking.h"
#import "VLBUserItemView.h"
#import "VLBQueries.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIViewController+VLBViewController.h"
#import "QNDAnimations.h"
#import "QNDAnimatedView.h"
#import "VLBProgressView.h"
#import "VLBAlertViews.h"
#import "NSDictionary+VLBResidence.h"
#import "VLBMacros.h"
#import "VLBErrorBlocks.h"
#import "VLBTheBox.h"
#import "VLBTypography.h"
#import "DDLog.h"

static NSString* const DEFAULT_ITEM_THUMB = @"default_item_thumb";
static NSString* const DEFAULT_ITEM_TYPE = @"png";


@interface VLBProfileViewController ()
@property(nonatomic, weak) VLBScrollView * itemsView;
@property(nonatomic, weak) UIView<QNDAnimatedView> *notificationAnimatedView;
@property(nonatomic, weak) UIProgressView *progressView;
@property(nonatomic, strong) NSDictionary* residence;
@property(nonatomic, strong) NSMutableArray* items;
@property(nonatomic, strong) UIImage *defaultItemImage;
@property(nonatomic, strong) NSString* locality;
@property(nonatomic, strong) NSDictionary* location;
@property(nonatomic, strong) NSOperationQueue *operationQueue;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil residence:(NSDictionary*)residence;
@end

@implementation VLBProfileViewController

+(VLBProfileViewController *)newProfileViewController:(NSDictionary*)residence email:(NSString*)email
{
    VLBProfileViewController * profileViewController = [[VLBProfileViewController alloc] initWithBundle:[NSBundle mainBundle]
                                                                                           residence:residence];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text = email;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [VLBTypography fontAvenirNextDemiBoldSixteen];
    titleLabel.adjustsFontSizeToFitWidth = YES;    
    profileViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    profileViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"You" image:[UIImage imageNamed:@"user.png"] tag:0];

    UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, 0, 30, 30)];
    [closeButton setImage:[UIImage imageNamed:@"down-arrow.png"] forState:UIControlStateNormal];
    [closeButton addTarget:profileViewController action:@selector(close) forControlEvents:UIControlEventTouchUpInside];

    profileViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    UIButton* addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setFrame:CGRectMake(0, 0, 30, 30)];
    [addButton setImage:[UIImage imageNamed:@"camera-mini.png"] forState:UIControlStateNormal];
    [addButton addTarget:profileViewController action:@selector(addItem) forControlEvents:UIControlEventTouchUpInside];

    profileViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];

return profileViewController;
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil residence:(NSDictionary*)residence
{
    self = [super initWithNibName:NSStringFromClass([VLBProfileViewController class]) bundle:nibBundleOrNil];
    
    if (!self) {
        return nil;
    }
    
    self.residence = residence;
    self.items = [NSMutableArray array];
    NSString* path = [nibBundleOrNil pathForResource:DEFAULT_ITEM_THUMB ofType:DEFAULT_ITEM_TYPE];
    self.defaultItemImage = [UIImage imageWithContentsOfFile:path];
    self.operationQueue = [NSOperationQueue new];

return self;
}

-(void)loadView
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];

    UIView<QNDAnimatedView> *notificationAnimatedView =
        [[QNDAnimations new] newViewAnimated:CGRectMake(0, -44, 320, 44)];
    notificationAnimatedView.backgroundColor = [UIColor blackColor];
    notificationAnimatedView.hidden = YES;
    
    VLBProgressView *progressView = [[VLBProgressView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [notificationAnimatedView addSubview:progressView];
    
    VLBScrollView * itemsView = [[[[VLBScrollViewBuilder alloc] initWith:
                                     CGRectMake(screenBounds.origin.x, screenBounds.origin.y, screenBounds.size.width, 367.0) viewsOf:416] allowSelection] newVerticalScrollView];
    
    itemsView.backgroundColor = [UIColor whiteColor];
    itemsView.datasource = self;
    itemsView.scrollViewDelegate = self;
    itemsView.scrollsToTop = YES;

    self.view = itemsView;
    [self.view addSubview:notificationAnimatedView];
    self.itemsView = itemsView;
    self.notificationAnimatedView = notificationAnimatedView;
    self.progressView = progressView.progressView;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hexabump.png"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    __weak VLBProfileViewController *wself = self;

    [self.itemsView addPullToRefreshWithActionHandler:^{
        [self.operationQueue addOperation:[VLBQueries newGetItemsGivenUserId:[wself.residence vlb_residenceUserId] page:VLB_Integer(1) delegate:wself]];
        [self.operationQueue addOperation:[VLBQueries newGetItemsGivenUserId:[wself.residence vlb_residenceUserId] delegate:wself]];
    }];
    self.itemsView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;    
    self.itemsView.pullToRefreshView.arrowColor = [UIColor whiteColor];
    self.itemsView.pullToRefreshView.textColor = [UIColor whiteColor];
    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addItem
{
    //thebox should be a property
    VLBTakePhotoViewController * takePhotoViewController = [VLBTakePhotoViewController newUploadUIViewController:[VLBTheBox newTheBox:self.residence] userId:[self.residence vlb_residenceUserId]];
    
    takePhotoViewController.createItemDelegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:takePhotoViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark AmazonServiceRequestDelegate
-(void)request:(AmazonServiceRequest *)request didSendData:(NSInteger)bytesWritten
totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
	[self bytesWritten:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
}

-(void)bytesWritten:(NSInteger)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite
{
    [self.progressView setProgress:(float)totalBytesWritten / (float)totalBytesExpectedToWrite animated:YES];
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
	AFHTTPRequestOperation *itemQuery = [VLBQueries newPostItemQuery:[[request url] absoluteString]
                                                            location:self.location
                                                            locality:self.locality
                                                                user:[self.residence vlb_residenceUserId]
                                                            delegate:self];

	[self.operationQueue addOperation:itemQuery];
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error{
	[self didFailOnItemWithError:error];
}

#pragma mark TBItemsOperationDelegate
-(void)didSucceedWithItems:(NSMutableArray *)items
{
    DDLogVerbose(@"%s, %@", __PRETTY_FUNCTION__, items);
    self.items = items;
    [self.itemsView setNeedsLayout];
    [self.itemsView.pullToRefreshView stopAnimating];
}

-(void)didFailOnItemsWithError:(NSError *)error
{
    DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
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

-(void)didStartUploadingItem:(NSDictionary*) location locality:(NSString*) locality
{
	self.location = location;
	self.locality = locality;

    self.notificationAnimatedView.hidden = NO;
    [self.notificationAnimatedView animateWithDuration:0.5 animation:^(UIView *view) {
        view.frame = CGRectMake(0, 0, 320, 44);
    }];
}



-(void)didSucceedWithItem:(NSDictionary*)item
{
    [self.notificationAnimatedView rewind:^(BOOL finished) {
        self.notificationAnimatedView.hidden = YES;
    }];
    
    DDLogVerbose(@"%s %@", __PRETTY_FUNCTION__, item);
    [self.items addObject:item];
    [self.itemsView setNeedsLayout];
}

-(void)didFailOnItemWithError:(NSError*)error
{
    DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
    [self.notificationAnimatedView rewind:^(BOOL finished) {
        self.notificationAnimatedView.hidden = YES;
    }];
    
    VLBAlertViewDelegate *alertViewDelegate = [VLBAlertViews newAlertViewDelegateOnOkDismiss];
    UIAlertView *alertView = [VLBAlertViews newAlertViewWithOk:@"Upload Fail"
                                                       message:error.localizedDescription];
    alertView.delegate = alertViewDelegate;
    
    [alertView show]; 
}

#pragma mark TBNSErrorDelegate
-(void)didFailWithCannonConnectToHost:(NSError *)error
{
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithNotConnectToInternet:(NSError *)error
{
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithTimeout:(NSError *)error
{
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

#pragma mark TheBoxUIScrollViewDelegate

-(void)didLayoutSubviews:(UIScrollView *)scrollView{
    
}

-(void)viewInScrollView:(VLBScrollView *)scrollView willAppearBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex{
    
}

-(void)scrollView:(UIScrollView *)scrollView willStopAt:(NSUInteger)index{
    
}

-(void)didSelectView:(VLBScrollView *)scrollView atIndex:(NSUInteger)inde point:(CGPoint)point {
    
}

#pragma mark TheBoxUIScrollViewDatasource

-(NSUInteger)numberOfViewsInScrollView:(VLBScrollView *)scrollView{
    return [self.items count];
}

-(UIView *)viewInScrollView:(VLBScrollView *)scrollView ofFrame:(CGRect)frame atIndex:(NSUInteger)index {
return [[VLBUserItemView alloc] initWithFrame:frame];
}

-(void)viewInScrollView:(VLBScrollView *)scrollView willAppear:(UIView *)view atIndex:(NSUInteger)index
{
    NSDictionary* item = [[self.items objectAtIndex:index] objectForKey:@"item"];
    
    VLBUserItemView * userItemView = (VLBUserItemView *)view;
    [userItemView viewWillAppear:item];
}

@end
