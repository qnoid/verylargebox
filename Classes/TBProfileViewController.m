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

@interface TBProfileViewController ()
-(id)initWithBundle:(NSBundle *)nibBundleOrNil;
@end

@implementation TBProfileViewController

+(TBProfileViewController*)newProfileViewController
{
    TBProfileViewController* profileViewController = [[TBProfileViewController alloc] initWithBundle:[NSBundle mainBundle]];
    profileViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"You" image:[UIImage imageNamed:@"user.png"] tag:0];

return profileViewController;
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TBProfileViewController" bundle:nibBundleOrNil];
    
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)viewDidLoad
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
}

-(void)didFailOnItemWithError:(NSError*)error
{
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
}

@end
