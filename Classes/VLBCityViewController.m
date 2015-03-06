//
//
//  VLBCityViewController.m
//  verylargebox 
//
//  Created by Markos Charatzas on 23/11/2010.
//  Copyright (c) 2010 (verylargebox.com). All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "VLBCityViewController.h"
#import "VLBQueries.h"
#import "VLBTakePhotoViewController.h"
#import "VLBBinarySearch.h"
#import "VLBDetailsViewController.h"
#import "NSArray+VLBDecorator.h"
#import "UIImageView+AFNetworking.h"
#import "NSDictionary+VLBDictionary.h"
#import "VLBLocationService.h"
#import "VLBTableViewDataSourceBuilder.h"
#import "VLBAlertViews.h"
#import "VLBDrawRects.h"
#import "VLBMacros.h"
#import "VLBErrorBlocks.h"
#import "VLBViewControllers.h"
#import "NSDictionary+VLBItem.h"
#import "NSDictionary+VLBLocation.h"
#import "VLBBoxAlertViews.h"
#import "CALayer+VLBLayer.h"

static NSInteger const FIRST_VIEW_TAG = -1;

@interface NSOperationQueue (VLBOperationQueue)
-(BOOL)vlb_isInProgress;
@end

@implementation NSOperationQueue (VLBOperationQueue)

-(BOOL)vlb_isInProgress {
    return [self operationCount] > 0;
}

@end

/*
 Using a UIButton to display a store given the requirements,
    tap on selected store to get directions
    have left, right padding on the store name as to distinguish with the adjacent ones
 
 
 */
@interface VLBCityViewController ()
@property(nonatomic, strong) VLBLocationService *theBoxLocationService;
@property(nonatomic, strong) CLPlacemark *placemark;
@property(nonatomic, strong) NSArray *localities;
@property(nonatomic, strong) NSArray *locations;
@property(nonatomic, assign) NSUInteger index;
@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, assign) NSUInteger numberOfRows;
@property(nonatomic, strong) NSOperationQueue *operationQueue;
@property(nonatomic, copy) VLBLocationServiceDirections didTapOnGetDirectionsButton;
@property(nonatomic, copy) NSString *localityName;
@property(nonatomic, strong) UIImage* placeholderImage;

-(id)initWithBundle:(NSBundle *)nibBundleOrNil locationService:(VLBLocationService *)locationService;
-(void)updateTitle:(NSString *)localityName;
-(void)reloadItems;
@end


@implementation VLBCityViewController

+(VLBCityViewController *)newCityViewController
{
    VLBLocationService* locationService = [VLBLocationService theBoxLocationService];
    VLBCityViewController* cityViewController = [[VLBCityViewController alloc] initWithBundle:[NSBundle mainBundle] locationService:locationService];
    
    cityViewController.automaticallyAdjustsScrollViewInsets = NO;
    cityViewController.navigationItem.rightBarButtonItem = [[VLBViewControllers new ]refreshButton:cityViewController
                                                                                            action:@selector(refreshLocations)];
    cityViewController.navigationItem.rightBarButtonItem.enabled = NO;
    
    UILabel* titleLabel = [[VLBViewControllers new] titleView:NSLocalizedString(@"navigationbar.title.city", @"Stores Nearby")];
    cityViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];

    cityViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tabbaritem.title.city", @"Nearby") image:[UIImage imageNamed:@"city.png"] tag:0];
    
return cityViewController;
}

- (void)dealloc
{
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    [self.theBoxLocationService dontNotifyDidFailWithError:self];
    [self.theBoxLocationService dontNotifyDidFailReverseGeocodeLocationWithError:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:[UIApplication sharedApplication]];
}


-(id)initWithBundle:(NSBundle *)nibBundleOrNil locationService:(VLBLocationService *)locationService
{
    self = [super initWithNibName:NSStringFromClass([VLBCityViewController class]) bundle:nibBundleOrNil];
    
    VLB_IF_NOT_SELF_RETURN_NIL();
    
    self.theBoxLocationService = locationService;
    self.locations = [NSArray array];
    self.items = [NSMutableArray array];
    self.operationQueue = [NSOperationQueue new];
    self.placeholderImage = [UIImage imageNamed:@"placeholder.png"];
    
return self;
}

-(void)drawRect:(CGRect)rect inView:(UIView *)view
{
    [[VLBDrawRects new] drawContextOfHexagonInRect:rect];
}

-(void)refreshLocations
{
    if(!self.placemark){
        [self.theBoxLocationService notifyDidFindPlacemark:self];
        [self.theBoxLocationService notifyDidFailWithError:self];
        [self.theBoxLocationService notifyDidFailReverseGeocodeLocationWithError:self];
        [self.theBoxLocationService startMonitoringSignificantLocationChanges];
    return;
    }
    //locality can be nil
    
    UIButton *refresh = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [refresh.imageView.layer vlb_rotate:VLBBasicAnimationBlockRotate];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [VLBQueries newGetLocationsGivenLocalityName:self.placemark.locality delegate:self];
}

- (void)updateTitle:(NSString *)localityName
{
		self.localityName = localityName;
    UILabel* titleView = (UILabel*) self.navigationItem.titleView;
    titleView.text = [NSString stringWithFormat:NSLocalizedString(@"navigationbar.city.title", @"Stores in %@"), localityName];
    [titleView sizeToFit];
    self.tabBarItem.title = localityName;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hexabump.png"]];
    self.locationsView.backgroundColor = [VLBColors colorDarkGrey];
    self.locationsView.showsHorizontalScrollIndicator = NO;
    //self.locationsView.enableSeeking = YES;
    
    self.locationsView.contentOffset = CGPointMake(-100.0f, 0.0f);
    [self.locationsView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];

    self.itemsView.contentInset = UIEdgeInsetsMake(164.0f, 0.0f, 48.0f, 0.0f);
    self.itemsView.showsVerticalScrollIndicator = YES;
    [self.itemsView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:[UIApplication sharedApplication]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //introduce VLBConditionals with a macro @conditional to execute a block
    if(!self.placemark){
        [self.theBoxLocationService notifyDidFindPlacemark:self];
        [self.theBoxLocationService notifyDidFailWithError:self];
        [self.theBoxLocationService notifyDidFailReverseGeocodeLocationWithError:self];
        [self.theBoxLocationService startMonitoringSignificantLocationChanges];
        
        MBProgressHUD *hud = [VLBHuds newWithViewLocationArrow:self.view];
        [hud show:YES];
    return;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    [self.theBoxLocationService dontNotifyDidFailWithError:self];
    [self.theBoxLocationService dontNotifyDidFailReverseGeocodeLocationWithError:self];

    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:[UIApplication sharedApplication]];
}

#pragma mark application events

- (void)applicationDidBecomeActive:(NSNotification *)notification;
{
	[self.theBoxLocationService startMonitoringSignificantLocationChanges];
}

/**
 @precondition self.locationsView
 */
-(void)highlightLocation
{
    for (UICollectionViewCell* cell in self.locationsView.visibleCells) {
        UILabel *button = cell.contentView.subviews[0];
        button.textColor = [UIColor lightGrayColor];
    }
    
    UILabel* locationButton = (UILabel*)[self.locationsView viewWithTag:FIRST_VIEW_TAG];
    
    if(self.index != 0){
        locationButton = (UILabel*)[self.locationsView viewWithTag:self.index];
    }
    
    locationButton.textColor = [UIColor whiteColor];
}

/**
  @precondition self.locations
 */
-(void)reloadItems
{
    [self.operationQueue cancelAllOperations];
    
    NSDictionary* currentLocation = [self.locations objectAtIndex:self.index];
    NSUInteger locationId = [[[currentLocation objectForKey:@"location"] objectForKey:@"id"] unsignedIntValue];
    
    [VLBQueries newGetItemsGivenLocationId:locationId page:VLB_Integer(1) delegate:self];
    [VLBQueries newGetItemsGivenLocationId:locationId delegate:self];
    MBProgressHUD *hud = [VLBHuds newWithView:self.view];
    [hud show:YES];
}

#pragma mark TBLocationOperationDelegate

-(void)didSucceedWithLocations:(NSArray*)locations givenParameters:(NSDictionary *)parameters
{
    UIButton *refresh = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [refresh.imageView.layer vlb_stopRotate];
    self.navigationItem.rightBarButtonItem.enabled = YES;

    if([locations vlb_isEmpty]){
        MBProgressHUD *hud = [VLBHuds newWithViewCamera:self.view locality:self.tabBarItem.title];
        [hud show:YES];
    return;
    }

    self.locations = locations;
    [self.locationsView reloadData];
//    static dispatch_once_t onceToken;
//
//    dispatch_once(&onceToken, ^{
//        [self.locationsView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.locations.count >> 1 inSection:1] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//    });

    [self highlightLocation];
    [self reloadItems];
}

-(void)didFailOnLocationWithError:(NSError*)error
{
    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

#pragma mark TBNSErrorDelegate
-(void)didFailWithCannonConnectToHost:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithNotConnectToInternet:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithTimeout:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

#pragma mark UICollectionViewDatasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if([self.locationsView isEqual:collectionView]){
        return 1;
    }
    
    return self.numberOfRows;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([self.locationsView isEqual:collectionView]){
        return [self.locations count];
    }
    
    if(self.items.count < 2){
        return 1;
    }

    if(section != (self.numberOfRows - 1)){
        return 2;
    }

return self.items.count%2==0?2:1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.locationsView isEqual:collectionView]){
        return [self locationsCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *item = [[[self items] objectAtIndex:(indexPath.section * 2) + indexPath.row] objectForKey:@"item"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    //@"http://s3-eu-west-1.amazonaws.com/com.verylargebox.server/items/images/000/000/020/thumb/.jpg"
    [imageView setImageWithURL:[NSURL URLWithString:[item objectForKey:@"imageURL"]]
              placeholderImage:self.placeholderImage];
    
    [cell.contentView addSubview:imageView];
    
return cell;
}

#pragma mark UICollectionViewDataSource

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.locationsView isEqual:collectionView]){
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        DDLogVerbose(@"%s %@", __PRETTY_FUNCTION__, @(indexPath.row));
        
        if(self.index == indexPath.row){
            return;
        }
        
        self.index = indexPath.row;
        
        [self highlightLocation];
        [self reloadItems];
        
    return;
    }
    
    //there should be a mapping between the index of the cell and the id of the item
	NSMutableDictionary *item = [[self.items objectAtIndex:(indexPath.section * 2) + indexPath.row] objectForKey:@"item"];
    
    [Flurry logEvent:@"didSelectItem" withParameters:@{
           VLBItemId: [item objectForKey:VLBItemId],
     VLBItemImageURL: [item vlb_objectForKey:VLBItemImageURL]}
     ];
    
    VLBDetailsViewController* detailsViewController = [VLBDetailsViewController newDetailsViewController:item];
    detailsViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

-(UICollectionViewCell *)locationsCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];

    NSDictionary *location = [[[self locations] objectAtIndex:indexPath.row] objectForKey:@"location"];

    UILabel *storeButton = [[UILabel alloc] initWithFrame:cell.bounds];
    storeButton.numberOfLines = 0;
    storeButton.lineBreakMode = NSLineBreakByWordWrapping;
    storeButton.textAlignment = NSTextAlignmentCenter;
    storeButton.font = [VLBTypography fontAvenirNextDemiBoldSixteen];
    storeButton.textColor = [UIColor lightGrayColor];
    storeButton.backgroundColor = [VLBColors colorDarkGrey];
    
    if(indexPath.row == 0){
        storeButton.tag = FIRST_VIEW_TAG;
    }
    else{
        storeButton.tag = indexPath.row;
    }
    
    id name = [location vlb_objectForKey:@"name" ifNil:@""];
    
    storeButton.text = name;
    [storeButton setBackgroundColor:[VLBColors colorDarkGrey]];
    
    [cell.contentView addSubview:storeButton];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mainScreenBounds = [UIScreen mainScreen].bounds.size;
    int halfSize = (int)mainScreenBounds.width >> 1;
    
    return CGSizeMake(halfSize, halfSize);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGSize mainScreenBounds = [UIScreen mainScreen].bounds.size;
    int halfSize = (int)mainScreenBounds.width >> 1;
    
    return mainScreenBounds.width - (halfSize * 2);
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
    DDLogVerbose(@"%s %@", __PRETTY_FUNCTION__, items);    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
	self.items = items;
    self.numberOfRows = round((float)self.items.count/2.0);
    [self.itemsView flashScrollIndicators];
    [self.itemsView reloadData];
}

-(void)didFailOnItemsWithError:(NSError*)error
{
    DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

#pragma mark VLBServiceDelegate
-(void)didFailUpdateToLocationWithError:(NSNotification *)notification
{
    //show appropriate error message when receiveing this due to nil location
    [self.theBoxLocationService dontNotifyDidFailWithError:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
    self.navigationItem.rightBarButtonItem.enabled = YES;

    DDLogError(@"%s", __PRETTY_FUNCTION__);
    [MBProgressHUD hideHUDForView:self.view animated:YES];

		NSError *error = [VLBNotifications error:notification];
		[VLBErrorBlocks locationErrorBlock:self.view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO](error);
}

-(void)didFindPlacemark:(NSNotification *)notification
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, notification);
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];    
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    self.placemark = [VLBNotifications place:notification];

    NSString *localityName = self.placemark.locality;
    
    [self updateTitle:localityName];

    [VLBQueries newGetLocationsGivenLocalityName:localityName delegate:self];
    MBProgressHUD *hud = [VLBHuds newWithView:self.view];
    [hud show:YES];
}

-(void)didFailReverseGeocodeLocationWithError:(NSNotification *)notification
{
    DDLogWarn(@"%s %@", __PRETTY_FUNCTION__, notification);
    [self.theBoxLocationService dontNotifyOnFindPlacemark:self];
    [self.theBoxLocationService stopMonitoringSignificantLocationChanges];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [MBProgressHUD hideHUDForView:self.view animated:YES];

		NSError *error = [VLBNotifications error:notification];
		[VLBErrorBlocks locationErrorBlock:self.view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO](error);
}

-(IBAction)didTapOnGetDirectionsButton:(id)sender
{
    if([self.locations vlb_isEmpty]){
        return;
    }
    
    NSDictionary *location = [[self.locations objectAtIndex:self.index] objectForKey:@"location"];
    id name = [location vlb_objectForKey:VLBLocationName ifNil:@""];

    VLBAlertViewBlock onOkGetDirections = ^(UIAlertView *alertView, NSInteger buttonIndex) {
        [Flurry logEvent:@"didGetDirections"
          withParameters:@{@"controller": @"VLBCityViewController", VLBLocationName:name}];
        
        [VLBLocationService decideOnDirections:[location vlb_coordinate]
                                       options:location]();
    };
    
    UIAlertView *alertView = [VLBBoxAlertViews location:name bar:onOkGetDirections];
    
    [alertView show];    
}

-(void)didTouchUpInsideStores
{

}

@end
