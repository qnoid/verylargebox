//
//  VLBLocalitiesTableViewController.m
//  thebox
//
//  Created by Markos Charatzas on 19/05/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBLocalitiesTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "VLBTableViewDataSourceBuilder.h"
#import "VLBTableViewDelegateBuilder.h"
#import "VLBQueries.h"
#import "AFHTTPRequestOperation.h"
#import "UINavigationItem+VLBNavigationItem.h"
#import "MBProgressHUD.h"
#import "VLBHuds.h"
#import "VLBErrorBlocks.h"
#import "VLBColors.h"

@interface VLBLocalitiesTableViewController ()
@property(nonatomic, strong) NSObject<UITableViewDataSource> *tableViewDataSource;
@property(nonatomic, strong) NSObject<UITableViewDelegate> *tableViewDelegate;
@end

@implementation VLBLocalitiesTableViewController

+(instancetype)newLocalitiesViewController
{
    VLBLocalitiesTableViewController *availablePlacesViewController = [[VLBLocalitiesTableViewController alloc] initWithStyle:UITableViewStylePlain];

    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Select a location";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [VLBTypography fontAvenirNextDemiBoldSixteen];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    availablePlacesViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];

    UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, 0, 30, 30)];
    [closeButton setImage:[UIImage imageNamed:@"down-arrow.png"] forState:UIControlStateNormal];
    [closeButton addTarget:availablePlacesViewController action:@selector(dismissViewControllerAnimated) forControlEvents:UIControlEventTouchUpInside];

    availablePlacesViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];

return availablePlacesViewController;
}

-(void)dismissViewControllerAnimated
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TBLocalityOperationDelegate
-(void)didSucceedWithLocalities:(NSArray *)localities
{
    DDLogVerbose(@"%s %@", __PRETTY_FUNCTION__, localities);
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    NSObject<UITableViewDataSource> *datasource = [[[[VLBTableViewDataSourceBuilder new] numberOfRowsInSection:^NSInteger(UITableView *tableView, NSInteger section) {
        return [localities count];
    }] cellForRowAtIndexPath:tbCellForRowAtIndexPath(^(UITableViewCell *cell, NSIndexPath* indexPath) {
        cell.textLabel.text = [[[localities objectAtIndex:indexPath.row] objectForKey:@"locality"] objectForKey:@"name"];
    })] newDatasource];
    
    self.tableViewDataSource = datasource;
    self.tableView.dataSource = self;
    
    __weak VLBLocalitiesTableViewController *wself = self;
    
    self.tableViewDelegate = [[[VLBTableViewDelegateBuilder new] didSelectRowAtIndexPath:^(UITableView *tableView, NSIndexPath *indexPath) {
        NSDictionary *locality = [[localities objectAtIndex:indexPath.row] objectForKey:@"locality"];
        
        [wself.delegate didSelectLocality:locality];
    }] newDelegate];
    
    self.tableView.delegate = self.tableViewDelegate;

    [self.tableView reloadData];
}

-(void)didFailOnLocalitiesWithError:(NSError *)error
{
    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    MBProgressHUD *hud = [VLBHuds newWithView:self.view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO];
    hud.detailsLabelText = error.localizedDescription;
    [hud show:YES];
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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hexabump.png"]];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    //if on viewDidLoad, callback to #didFailOnLocalitiesWithError that calls #dismissViewControllerAnimated will raise fail.
    //Warning: Attempt to dismiss from view controller <UINavigationController: 0x2006cfc0> while a presentation or dismiss is in progress!

    [[VLBQueries newGetLocalities:self] start];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tableViewDataSource tableView:tableView numberOfRowsInSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

@end
