//
//  VLBReportViewController.h
//  verylargebox
//
//  Created by Markos Charatzas on 15/08/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLBReportOperationDelegate.h"

NS_ENUM(NSUInteger, VLBReportStatus)
{
    VLBReportStatusSexuallyExplicity,
    VLBReportStatusSpam,
    VLBReportStatusRisk,
    VLBReportStatusInvalid
};

NS_INLINE
NSString* VLBReportStatusToString(enum VLBReportStatus reportStatus)
{
    switch(reportStatus) {
        case VLBReportStatusSexuallyExplicity:
            return @"VLBReportStatusSexuallyExplicity";
            break;
        case VLBReportStatusSpam:
            return @"VLBReportStatusSpam";
            break;
        case VLBReportStatusRisk:
            return @"VLBReportStatusRisk";
            break;
        case VLBReportStatusInvalid:
            return @"VLBReportStatusInvalid";
            break;
    }
}

@interface VLBReportViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, VLBReportOperationDelegate>

@property(nonatomic, weak) IBOutlet UILabel *reportReasonLabel;

+(instancetype)newReportViewController:(NSDictionary*)item;

@end
