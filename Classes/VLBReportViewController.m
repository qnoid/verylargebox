//
//  VLBReportViewController.m
//  verylargebox
//
//  Created by Markos Charatzas on 15/08/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "VLBReportViewController.h"
#import "VLBMacros.h"
#import "VLBViewControllers.h"
#import "VLBTypography.h"
#import "VLBColors.h"
#import "NSDictionary+VLBItem.h"
#import "VLBQueries.h"

@interface VLBReportViewController ()
@property(nonatomic, strong) NSDictionary* item;
@property(nonatomic, strong) NSArray* reasons;
@end

@implementation VLBReportViewController

+(instancetype)newReportViewController:(NSDictionary*)item
{
    VLBReportViewController *reportViewController = [[VLBReportViewController alloc] initWithBundle:[NSBundle mainBundle] item:item];
    
    UILabel* titleLabel = [[VLBViewControllers new] titleView:NSLocalizedString(@"navigationbar.title.report", @"Report objectionable content")];
    reportViewController.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];

    reportViewController.navigationItem.leftBarButtonItem =
    [[VLBViewControllers new] closeButton:reportViewController
                                   action:@selector(dismissViewControllerAnimated:)];

return reportViewController;
}

- (id)initWithBundle:(NSBundle *)nibBundleOrNil item:(NSDictionary*)item
{
    self = [super initWithNibName:@"VLBReportViewController" bundle:nibBundleOrNil];

    VLB_IF_NOT_SELF_RETURN_NIL();
    
    self.reasons = @[@{@"VLBReportText": NSLocalizedString(@"viewcontrolllers.report.sexuallyexplicit", @"This photo is sexually explicit"),
                       @"VLBReportStatus": @(VLBReportStatusSexuallyExplicity)},
                     @{@"VLBReportText": NSLocalizedString(@"viewcontrolllers.report.scam", @"This photo is spam or a scam"),
                       @"VLBReportStatus": @(VLBReportStatusSpam)},
                     @{@"VLBReportText": NSLocalizedString(@"viewcontrolllers.report.risk", @"This photo puts people at risk"),
                       @"VLBReportStatus": @(VLBReportStatusRisk)},
                     @{@"VLBReportText": NSLocalizedString(@"viewcontrolllers.report.invalid", @"This photo shouldn't be on verylargebox"),
                       @"VLBReportStatus": @(VLBReportStatusInvalid)}
                     ];
    
    self.item = item;
    
return self;
}

- (void)dismissViewControllerAnimated:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.reportReasonLabel.text = NSLocalizedString(@"viewcontrollers.report.reportReasonLabel.text", @"What is the reason for the report?");
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reasons.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"ReportCell";
    
    UITableViewCell *reportCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if(!reportCell){
        reportCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        reportCell.textLabel.font = [VLBTypography fontAvenirNextDemiBold:13.0];
        reportCell.textLabel.textColor = [UIColor whiteColor];
        reportCell.textLabel.numberOfLines = 0;
        reportCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    reportCell.textLabel.text = [self.reasons[indexPath.row] objectForKey:@"VLBReportText"];
    
return reportCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [VLBColors colorPrimaryBlue];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", self.item);
    enum VLBReportStatus reportStatus = [[self.reasons[indexPath.row] objectForKey:@"VLBReportStatus"] unsignedIntValue];
    
    [VLBQueries newReportItem:[self.item vlb_id]
                reportStatus:VLBReportStatusToString(reportStatus)
                  delegate:self];
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TBNSErrorDelegate
-(void)didFailWithCannonConnectToHost:(NSError *)error
{
    DDLogWarn(@"%s, %@", __PRETTY_FUNCTION__, error);
}

-(void)didFailWithNotConnectToInternet:(NSError *)error
{
    DDLogWarn(@"%s, %@", __PRETTY_FUNCTION__, error);
}

-(void)didFailWithTimeout:(NSError *)error
{
    DDLogWarn(@"%s, %@", __PRETTY_FUNCTION__, error);
}

#pragma mark VLBReportOperationDelegate
-(void)didFailOnReportWithError:(NSError *)error
{
    DDLogWarn(@"%s, %@", __PRETTY_FUNCTION__, error); 
}

-(void)didSucceedOnReport
{
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
}

@end
