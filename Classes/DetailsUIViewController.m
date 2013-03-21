/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 10/04/2012.
 *  Contributor(s): .-
 */
#import "DetailsUIViewController.h"
#import "TheBoxLocationService.h"
#import "TheBoxNotifications.h"
#import "LocationUIViewController.h"
#import "TheBoxQueries.h"
#import "AFHTTPRequestOperation.h"
#import "UIViewController+TBViewController.h"

@interface DetailsUIViewController ()
-(id)initWithBundle:(NSBundle *)nibBundleOrNil onItem:(NSDictionary*)item;
@property(nonatomic) TheBoxLocationService *theBoxLocationService;
@property(nonatomic) CLLocation *location;
@property(nonatomic, strong) NSMutableDictionary* item;
@end

@implementation DetailsUIViewController

+(DetailsUIViewController*)newDetailsViewController:(NSDictionary*)item
{
    DetailsUIViewController* detailsViewController = 
        [[DetailsUIViewController alloc] initWithBundle:[NSBundle mainBundle] onItem:item];
    
return detailsViewController;
}

- (id)initWithBundle:(NSBundle *)nibBundleOrNil onItem:(NSMutableDictionary*)item;
{
    self = [super initWithNibName:@"DetailsUIViewController" bundle:nibBundleOrNil];
    if (!self) {
        return nil;
    }
    
    self.item = item;
    self.title = [self.item objectForKey:@"name"];
    self.title = @"Details";

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
        cell.textLabel.font = [UIFont fontWithName:@"Gil Sans" size:12.0];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    cell.textLabel.text = @[@"foo: fffffffff", @"bar: bbbbbbbbb", @"car: cccccccccc"][indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20.0;
}

@end
