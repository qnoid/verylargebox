//
//  Copyright (c) 2010 (verylargebox.com). All rights reserved.
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 10/04/2012.
//
//

#import "VLBDetailsViewController.h"
#import "VLBLocationService.h"
#import "VLBNotifications.h"
#import "VLBStoresViewController.h"
#import "VLBQueries.h"
#import "AFHTTPRequestOperation.h"
#import "UIViewController+VLBViewController.h"

@interface VLBDetailsViewController ()
-(id)initWithBundle:(NSBundle *)nibBundleOrNil onItem:(NSDictionary*)item;
@property(nonatomic) VLBLocationService *theBoxLocationService;
@property(nonatomic) CLLocation *location;
@property(nonatomic, strong) NSMutableDictionary* item;
@end

@implementation VLBDetailsViewController

+(VLBDetailsViewController *)newDetailsViewController:(NSDictionary*)item
{
    VLBDetailsViewController *detailsViewController =
        [[VLBDetailsViewController alloc] initWithBundle:[NSBundle mainBundle] onItem:item];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text = [item objectForKey:@"location"] objectForKey:"@name"];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [VLBTypography fontAvenirNextDemiBoldSixteen];
    titleLabel.adjustsFontSizeToFitWidth = YES;    
    detailsViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];

return detailsViewController;
}

- (id)initWithBundle:(NSBundle *)nibBundleOrNil onItem:(NSMutableDictionary*)item;
{
    self = [super initWithNibName:NSStringFromClass([VLBDetailsViewController class]) bundle:nibBundleOrNil];
    if (!self) {
        return nil;
    }
    
    self.item = item;

return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIActivityIndicatorView *activityIndicator =
        [[UIActivityIndicatorView alloc] initWithFrame:self.itemImageView.frame];
    
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [activityIndicator startAnimating];
    
    [self.view addSubview:activityIndicator];

    NSString *imageURL = [self.item objectForKey:@"iphoneImageURL"];
    
	NSLog(@"%@", imageURL);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            NSURL *url = [NSURL URLWithString:imageURL];
            NSData* data = [NSData dataWithContentsOfURL:url];
            
            UIImage* image = [UIImage imageWithData:data];
        
            dispatch_sync(dispatch_get_main_queue(), ^{
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
                self.itemImageView.image = image;
            });
    });
    
    self.itemWhenLabel.text = [self.item objectForKey:@"when"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        cell.textLabel.font = [VLBTypography fontAvenirNextDemiBoldSixteen];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20.0;
}

@end
