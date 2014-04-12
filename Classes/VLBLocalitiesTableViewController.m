//
//  VLBLocalitiesTableViewController.m
//  verylargebox
//
//  Created by Markos Charatzas on 19/05/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBLocalitiesTableViewController.h"
#import "VLBTableViewDataSourceBuilder.h"
#import "VLBQueries.h"
#import "VLBHuds.h"
#import "VLBErrorBlocks.h"
#import "VLBViewControllers.h"


@interface VLBLocalitiesTableViewController ()
@property(nonatomic, strong) NSArray* localities;
@end

@implementation VLBLocalitiesTableViewController

+(instancetype)newLocalitiesViewController
{
    VLBLocalitiesTableViewController *availablePlacesViewController = [[VLBLocalitiesTableViewController alloc] initWithStyle:UITableViewStylePlain];

    UILabel* titleLabel = [[VLBViewControllers new] titleView:NSLocalizedString(@"navigationbar.title.localities", @"Select a location")];
    availablePlacesViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];

    availablePlacesViewController.navigationItem.leftBarButtonItem = [[VLBViewControllers new] closeButton:availablePlacesViewController action:@selector(dismissViewControllerAnimated)];

return availablePlacesViewController;
}

-(void)dismissViewControllerAnimated
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TBLocalityOperationDelegate
-(void)didSucceedWithLocalities:(NSArray *)localities
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    DDLogVerbose(@"%s %@", __PRETTY_FUNCTION__, localities);
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    self.localities = localities;
    [self.tableView reloadData];
}

-(void)didFailOnLocalitiesWithError:(NSError *)error
{
    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    MBProgressHUD *hud = [VLBHuds newWithView:self.view config:VLB_PROGRESS_HUD_CUSTOM_VIEW_CIRCLE_NO];
    hud.detailsLabelText = error.localizedDescription;
    [hud show:YES];
}

#pragma mark TBNSErrorDelegate
-(void)didFailWithCannonConnectToHost:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithNotConnectToInternet:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

-(void)didFailWithTimeout:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [VLBErrorBlocks localizedDescriptionOfErrorBlock:self.view](error);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    MBProgressHUD *hud = [VLBHuds newWithView:self.view];
    [hud show:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    //if on viewDidLoad, callback to #didFailOnLocalitiesWithError that calls #dismissViewControllerAnimated will raise fail.
    //Warning: Attempt to dismiss from view controller <UINavigationController: 0x2006cfc0> while a presentation or dismiss is in progress!

    [VLBQueries newGetLocalities:self];
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
    return self.localities.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.font = [VLBTypography fontLucidaGrandeEleven];
        cell.textLabel.textColor = [VLBColors colorPrimaryBlue];
    }
    
    cell.textLabel.text = [[[self.localities objectAtIndex:indexPath.row] objectForKey:@"locality"] objectForKey:@"name"];
    
return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *locality = [[self.localities objectAtIndex:indexPath.row] objectForKey:@"locality"];
    
    [self.delegate didSelectLocality:locality];
}


@end
