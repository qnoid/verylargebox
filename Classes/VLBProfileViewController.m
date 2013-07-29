//
//  VLBProfileViewController.m
//  verylargebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import "VLBProfileViewController.h"
#import "VLBPredicates.h"
#import "UIImageView+AFNetworking.h"
#import "VLBUserItemView.h"
#import "VLBQueries.h"
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
#import "VLBDrawRects.h"
#import "VLBButton.h"
#import "VLBViewControllers.h"
#import "VLBNotificationView.h"
#import "VLBUserProfileViewController.h"
#import "VLBColors.h"
#import "VLBTakePhotoButton.h"

static NSString* const DEFAULT_ITEM_THUMB = @"default_item_thumb";
static NSString* const DEFAULT_ITEM_TYPE = @"png";

@interface VLBProfileViewController ()
@property(nonatomic, weak) UIView<QNDAnimatedView> *notificationAnimatedView;
@property(nonatomic, weak) UIProgressView *progressView;

@property(nonatomic, weak) VLBTheBox *thebox;

@property(nonatomic, strong) NSMutableOrderedSet* items;
@property(nonatomic, strong) UIImage *defaultItemImage;
@property(nonatomic, strong) NSString* locality;
@property(nonatomic, strong) NSDictionary* location;
@property(nonatomic, strong) NSOperationQueue *operationQueue;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil thebox:(VLBTheBox*)thebox;
@end

@implementation VLBProfileViewController

+(VLBProfileViewController *)newProfileViewController:(VLBTheBox*)thebox email:(NSString*)email
{
    VLBProfileViewController *profileViewController =
        [[VLBProfileViewController alloc] initWithBundle:[NSBundle mainBundle]
                                                  thebox:thebox];

    profileViewController.navigationItem.rightBarButtonItem = [[VLBViewControllers new ]refreshButton:profileViewController
                                                                                            action:@selector(refreshFeed)];

    UIButton* titleButton = [[VLBViewControllers new] attributedTitleButton:email
                                                           target:profileViewController
                                                           action:@selector(presentUserSettingsViewController)];


    profileViewController.navigationItem.titleView = titleButton;
    
    profileViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"You" image:[UIImage imageNamed:@"user.png"] tag:0];

return profileViewController;
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil thebox:(VLBTheBox*)thebox
{
    self = [super initWithNibName:NSStringFromClass([VLBProfileViewController class]) bundle:nibBundleOrNil];
    

    VLB_IF_NOT_SELF_RETURN_NIL();
    
	self.thebox = thebox;
    self.items = [NSMutableOrderedSet orderedSetWithCapacity:10];
    NSString* path = [nibBundleOrNil pathForResource:DEFAULT_ITEM_THUMB ofType:DEFAULT_ITEM_TYPE];
    self.defaultItemImage = [UIImage imageWithContentsOfFile:path];
    self.operationQueue = [NSOperationQueue new];

return self;
}

-(void)refreshFeed
{
    MBProgressHUD* hud = [VLBHuds newWithView:self.view];
    [hud show:YES];

    [self.operationQueue addOperation:[VLBQueries newGetItemsGivenUserId:[self.thebox userId] page:VLB_Integer(1) delegate:self]];
    [self.operationQueue addOperation:[VLBQueries newGetItemsGivenUserId:[self.thebox userId] delegate:self]];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void)presentUserSettingsViewController
{
    UINavigationController *newUserSettingsViewController = [[UINavigationController alloc] initWithRootViewController:[self.thebox newUserProfileViewController]];
    [self.navigationController presentViewController:newUserSettingsViewController animated:YES completion:nil];

}

-(void)didTouchUpInsideDiscard:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hexabump.png"]];
    
    VLBTakePhotoButton *view = [[VLBTakePhotoButton alloc] initWithFrame:CGRectMake(0, -44, self.itemsView.bounds.size.width, 44)];
    [view addTarget:self action:@selector(refreshFeed)];
    [self.itemsView addSubview:view];
    self.itemsView.contentInset = UIEdgeInsetsMake(88, 0, 0, 0);
    
    self.itemsView.scrollsToTop = YES;

    [self refreshFeed];
}

-(void)viewWillAppear:(BOOL)animated
{
}

-(void)viewWillDisappear:(BOOL)animated
{
}

-(void)viewDidAppear:(BOOL)animated
{

}

-(IBAction)didTouchUpInsideTakePhotoButton
{
    [Flurry logEvent:@"didTouchUpInsideTakePhoto"];

    VLBTakePhotoViewController *takePhotoViewController = [self.thebox newTakePhotoViewController];
    takePhotoViewController.delegate = self;
    
    VLBNotificationView *notificationView = [VLBNotificationView newView];
    takePhotoViewController.createItemDelegate = notificationView;
    notificationView.delegate = self;
    [self.view addSubview:notificationView];

    [self presentViewController:takePhotoViewController animated:YES completion:nil];
}

-(void)didCompleteUploading:(VLBNotificationView *)notificationView at:(NSString *)itemURL
{
	AFHTTPRequestOperation *itemQuery = [VLBQueries newPostItemQuery:itemURL
                                                            location:self.location
                                                            locality:self.locality
                                                                user:[self.thebox userId]
                                                            delegate:notificationView];

	[self.operationQueue addOperation:itemQuery];
}

-(void)didStartUploadingItem:(UIImage*)itemImage key:(NSString*)key location:(NSDictionary*) location locality:(NSString*) locality
{
	self.location = location;
	self.locality = locality;    
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
    [self.itemsView scrollRectToVisible:CGRectMake(0, -44.0, self.itemsView.bounds.size.width, self.itemsView.bounds.size.height) animated:YES];

    DDLogVerbose(@"%s %@", __PRETTY_FUNCTION__, item);
    if(self.items.count == 0){
        [self.items addObject:item];
    }
    else{
	    [self.items insertObject:item atIndex:0];
    }
    [self.itemsView setNeedsLayout];
}

-(void)didFailOnItemWithError:(NSError*)error
{
    DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

#pragma mark TBNSErrorDelegate
-(void)didFailWithCannonConnectToHost:(NSError *)error
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithNotConnectToInternet:(NSError *)error
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithTimeout:(NSError *)error
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}


#pragma mark TBItemsOperationDelegate
-(void)didSucceedWithItems:(NSMutableArray *)items
{
    [self.itemsView scrollRectToVisible:CGRectMake(0, -44.0, self.itemsView.bounds.size.width, self.itemsView.bounds.size.height) animated:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    DDLogVerbose(@"%s, %@", __PRETTY_FUNCTION__, items);
    self.items = [NSMutableOrderedSet orderedSetWithCapacity:items.count];
	[self.items addObjectsFromArray:items];
    [self.itemsView setNeedsLayout];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

-(void)didFailOnItemsWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

#pragma mark VLBScrollViewDelegate

-(VLBScrollViewOrientation)orientation:(VLBScrollView*)scrollView{
return VLBScrollViewOrientationVertical;
}

-(CGFloat)viewsOf:(VLBScrollView *)scrollView{
    return 428.0;
}

-(void)didLayoutSubviews:(VLBScrollView *)scrollView{
    
}

-(void)viewInScrollView:(VLBScrollView *)scrollView willAppearBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex{
    
}

-(void)scrollView:(UIScrollView *)scrollView willStopAt:(NSUInteger)index{
    
}


#pragma mark VLBScrollViewDatasource

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
