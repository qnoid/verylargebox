//
//  VLBFeedViewController.m
//  verylargebox
//
//  Created by Markos Charatzas on 25/05/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBFeedViewController.h"
#import "VLBLocationService.h"
#import "VLBFeedItemView.h"
#import "VLBQueries.h"
#import "VLBNotifications.h"
#import "VLBHuds.h"
#import "VLBMacros.h"
#import "VLBErrorBlocks.h"
#import "VLBPredicates.h"
#import "VLBViewControllers.h"
#import "NSArray+VLBDecorator.h"
#import "CALayer+VLBLayer.h"

@interface VLBFeedViewController ()

@property(nonatomic, strong) NSString *locality;
@property(nonatomic, strong) VLBLocationService *theBoxLocationService;
@property(nonatomic, strong) NSDictionary* residence;
@property(nonatomic, strong) NSMutableArray* items;
@property(nonatomic, strong) NSOperationQueue *operationQueue;

-(id)initWithBundle:(NSBundle *)nibBundleOrNil;
@end

@implementation VLBFeedViewController

+(VLBFeedViewController *)newFeedViewController
{
    VLBFeedViewController* feedViewController = [[VLBFeedViewController alloc] initWithBundle:[NSBundle mainBundle]];
    
    feedViewController.navigationItem.rightBarButtonItem = [[VLBViewControllers new ]refreshButton:feedViewController
                                                                                            action:@selector(refreshFeed)];

    UIButton* titleButton = [[VLBViewControllers new] attributedTitleButton:NSLocalizedString(@"navigationbar.title.recent", @"Recent")
                                                                     target:feedViewController
                                                                     action:@selector(didTouchUpInsideRecent)];
    feedViewController.navigationItem.titleView = titleButton;
    
    feedViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tabbaritem.title.recent", @"Recent") image:[UIImage imageNamed:@"clock.png"] tag:2];
    
return feedViewController;
}

-(void)dealloc
{
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    [self.theBoxLocationService dontNotifyDidFailWithError:self];
    [self.theBoxLocationService dontNotifyDidFailReverseGeocodeLocationWithError:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([VLBFeedViewController class]) bundle:nibBundleOrNil];
    
    VLB_IF_NOT_SELF_RETURN_NIL();
    
    self.theBoxLocationService = [VLBLocationService theBoxLocationService];
    self.items = [NSMutableArray array];
    self.operationQueue = [NSOperationQueue new];

    return self;
}

-(void)refreshFeed
{
    UIButton *refresh = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [refresh.imageView.layer vlb_rotate:VLBBasicAnimationBlockRotate];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self.operationQueue addOperation:[VLBQueries newGetItems:self.locality page:VLB_Integer(1) delegate:self]];
    [self.operationQueue addOperation:[VLBQueries newGetItems:self.locality delegate:self]];
}

-(void)updateTitle:(NSString*)localityName
{
    UIButton* titleView = (UIButton*) self.navigationItem.titleView;
    VLBTitleButtonAttributed(titleView, [NSString stringWithFormat:NSLocalizedString(@"tabbaritem.title.recentin", @"Recent in %@"), localityName]);
    [titleView sizeToFit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = self.feedView.backgroundColor =
        [UIColor colorWithPatternImage:[UIImage imageNamed:@"hexabump.png"]];
    
    self.feedView.scrollsToTop = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    //introduce VLBConditionals with a macro @conditional to execute a block
    [[VLBPredicates new] ifNil:self.locality then:^{
        [self.theBoxLocationService notifyDidFindPlacemark:self];
        [self.theBoxLocationService notifyDidFailWithError:self];
        [self.theBoxLocationService notifyDidFailReverseGeocodeLocationWithError:self];
        
        MBProgressHUD *hud = [VLBHuds newWithViewLocationArrow:self.view];
        [hud show:YES];
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [[VLBPredicates new] ifNil:self.locality then:^{
        [self.theBoxLocationService startMonitoringSignificantLocationChanges];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)didTouchUpInsideRecent
{
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    VLBLocalitiesTableViewController *localitiesViewController = [VLBLocalitiesTableViewController newLocalitiesViewController];
    localitiesViewController.delegate = self;
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:localitiesViewController];
    navigationController.navigationBar.translucent = YES;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark TBItemsOperationDelegate
-(void)didSucceedWithItems:(NSMutableArray *)items
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    DDLogVerbose(@"%@", items);
    UIButton *refresh = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [refresh.imageView.layer vlb_stopRotate];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    self.items = items;
    [self.feedView setNeedsLayout];
    [self.feedView flashScrollIndicators];
    
    if([items vlb_isEmpty]){
        MBProgressHUD *hud = [VLBHuds newWithView:self.view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO];
        hud.labelText = NSLocalizedString(@"huds.feed.selectlocation.title", @"No items found");
        hud.detailsLabelText = NSLocalizedString(@"huds.feed.selectlocation.details", @"Select a location by tapping on the navigation bar.");
        [hud show:YES];
    }
}

-(void)didFailOnItemsWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

#pragma mark TBNSErrorDelegate
-(void)didFailWithCannonConnectToHost:(NSError *)error
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithNotConnectToInternet:(NSError *)error
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithTimeout:(NSError *)error
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

#pragma mark VLBScrollViewDelegate

-(VLBScrollViewOrientation)orientation:(VLBScrollView*)scrollView{
return VLBScrollViewOrientationVertical;
}

-(CGFloat)viewsOf:(VLBScrollView *)scrollView{
    return 467.0;
}

-(void)didLayoutSubviews:(VLBScrollView *)scrollView{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)viewInScrollView:(VLBScrollView *)scrollView willAppearBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex{
    
}

-(void)scrollView:(UIScrollView *)scrollView willStopAt:(NSUInteger)index{
    
}

#pragma mark VLBScrollViewDatasource

-(NSUInteger)numberOfViewsInScrollView:(VLBScrollView *)scrollView{
    return [self.items count];
}

-(UIView *)viewInScrollView:(VLBScrollView *)scrollView ofFrame:(CGRect)frame atIndex:(NSUInteger)index
{
    VLBFeedItemView *feedItemView = [[VLBFeedItemView alloc] initWithFrame:frame];
    feedItemView.parentViewController = self;
    
return feedItemView;
}

-(void)viewInScrollView:(VLBScrollView *)scrollView willAppear:(UIView *)view atIndex:(NSUInteger)index
{
    NSDictionary* item = [[self.items objectAtIndex:index] objectForKey:@"item"];
    
    VLBFeedItemView * userItemView = (VLBFeedItemView *)view;
    [userItemView viewWillAppear:item];
}

#pragma mark VLBLocationServiceDelegate
-(void)didFindPlacemark:(NSNotification *)notification
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
	NSString *locality = [VLBNotifications place:notification].locality;
    
    [self updateTitle:locality];
    
    self.locality = locality;
    [self refreshFeed];
}

-(void)didFailUpdateToLocationWithError:(NSNotification *)notification
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
    DDLogWarn(@"%s", __PRETTY_FUNCTION__);
    NSError *error = [VLBNotifications error:notification];

    [VLBErrorBlocks locationErrorBlock:self.view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO](error);
}


-(void)didFailReverseGeocodeLocationWithError:(NSNotification *)notification
{
    //this can also happen if the request has been cancelled.
    //check the code under VLBFeedViewController in case we stopMonitoringChanges early, before placemark resolution.
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];

    DDLogWarn(@"%s", __PRETTY_FUNCTION__);
    VLBLocalitiesTableViewController *localitiesViewController = [VLBLocalitiesTableViewController newLocalitiesViewController];
    localitiesViewController.delegate = self;
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:localitiesViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark TBLocalitiesTableViewControllerDelegate

-(void)didSelectLocality:(NSDictionary *)locality
{
    NSString *localityName = [locality objectForKey:@"name"];

    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self updateTitle:localityName];
    
    self.locality = localityName;
    
    [self.operationQueue addOperation:[VLBQueries newGetItems:self.locality page:VLB_Integer(1) delegate:self]];
    [self.operationQueue addOperation:[VLBQueries newGetItems:self.locality delegate:self]];
    MBProgressHUD *hud = [VLBHuds newWithView:self.view];
    [hud show:YES];
}
@end
