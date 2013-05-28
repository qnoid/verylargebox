//
//  TBLocalitiesTableViewController.m
//  thebox
//
//  Created by Markos Charatzas on 19/05/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "TBLocalitiesTableViewController.h"
#import "TBUITableViewDataSourceBuilder.h"
#import "TBUITableViewDelegateBuilder.h"
#import "TheBoxQueries.h"
#import "AFHTTPRequestOperation.h"
#import "UINavigationItem+TBNavigationItem.h"
#import "MBProgressHUD.h"

@interface TBLocalitiesTableViewController ()
@property(nonatomic, strong) NSObject<UITableViewDataSource> *tableViewDataSource;
@property(nonatomic, strong) NSObject<UITableViewDelegate> *tableViewDelegate;
@end

@implementation TBLocalitiesTableViewController

+(instancetype)newLocalitiesViewController
{
    TBLocalitiesTableViewController *availablePlacesViewController = [[TBLocalitiesTableViewController alloc] initWithStyle:UITableViewStylePlain];

    [availablePlacesViewController.navigationItem tb_addActionOnBarButtonItem:TBNavigationItemActionDismissViewControllerAnimatedOnLeftBarButtonItem target:availablePlacesViewController];

    availablePlacesViewController.title = @"Select a location for thebox";
    
return availablePlacesViewController;
}

#pragma mark TBLocalityOperationDelegate
-(void)didSucceedWithLocalities:(NSArray *)localities
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, localities);
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    NSObject<UITableViewDataSource> *datasource = [[[[TBUITableViewDataSourceBuilder new] numberOfRowsInSection:^NSInteger(UITableView *tableView, NSInteger section) {
        return [localities count];
    }] cellForRowAtIndexPath:tbCellForRowAtIndexPath(^(UITableViewCell *cell, NSIndexPath* indexPath) {
        cell.textLabel.text = [[[localities objectAtIndex:indexPath.row] objectForKey:@"locality"] objectForKey:@"name"];
    })] newDatasource];
    
    self.tableViewDataSource = datasource;
    self.tableView.dataSource = datasource;
    
    __weak TBLocalitiesTableViewController *wself = self;
    
    self.tableViewDelegate = [[[TBUITableViewDelegateBuilder new] didSelectRowAtIndexPath:^(UITableView *tableView, NSIndexPath *indexPath) {
        NSDictionary *locality = [[localities objectAtIndex:indexPath.row] objectForKey:@"locality"];
        
        [wself.delegate didSelectLocality:locality];
    }] newDelegate];
    
    self.tableView.delegate = self.tableViewDelegate;

    [self.tableView reloadData];
}

-(void)dismissViewControllerAnimated
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didFailOnLocalitiesWithError:(NSError *)error
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:hud];
    
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle-no.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.detailsLabelText = error.localizedDescription;
    
    [hud show:YES];
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

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    //if on viewDidLoad, callback to #didFailOnLocalitiesWithError that calls #dismissViewControllerAnimated will raise fail.
    //Warning: Attempt to dismiss from view controller <UINavigationController: 0x2006cfc0> while a presentation or dismiss is in progress!

    [[TheBoxQueries newGetLocalities:self] start];
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

@end
