//
//  VLBIdentifyViewController.h
//  thebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "VLBButton.h"
#import "VLBVerifyUserOperationDelegate.h"
#import "VLBCreateUserOperationDelegate.h"
#import "VLBView.h"
#import "VLBAFHTTPRequestOperationCompletionBlocks.h"

@protocol VLBButton;

typedef NS_ENUM(NSInteger, VLBEmailStatus){
    VLBEmailStatusDefault,
    VLBEmailStatusError,
    VLBEmailStatusUnknown,
    VLBEmailStatusUnauthorised,
    VLBEmailStatusVerified
};

typedef void(^VLBEmailStatusBlock)(UITableViewCell* tableViewCell);

NS_INLINE
VLBEmailStatusBlock vlbEmailStatus(VLBEmailStatus emailStatus)
{
    switch (emailStatus) {
        case VLBEmailStatusDefault:
            return ^(UITableViewCell *tableViewCell){
                tableViewCell.textLabel.enabled = YES;
                tableViewCell.userInteractionEnabled = YES;
                tableViewCell.accessoryType = UITableViewCellAccessoryNone;
                tableViewCell.textLabel.textColor = [VLBColors colorLightGrey];
            };
        case VLBEmailStatusError:
            return ^(UITableViewCell *tableViewCell){
                UIImageView* accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh-mini.png"]];
                
                tableViewCell.textLabel.enabled = NO;
                tableViewCell.userInteractionEnabled = YES;
                tableViewCell.accessoryView = accessoryView;
                tableViewCell.textLabel.textColor = [VLBColors colorLightGrey];
            };            
        case VLBEmailStatusUnknown:
            return ^(UITableViewCell *tableViewCell){
                UIActivityIndicatorView* accessoryView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                [accessoryView startAnimating];
                
                tableViewCell.selected = NO;
                tableViewCell.userInteractionEnabled = NO;
                tableViewCell.textLabel.enabled = NO;
                tableViewCell.accessoryView = accessoryView;
                tableViewCell.textLabel.textColor = [VLBColors colorLightGrey];
            };
        case VLBEmailStatusUnauthorised:
            return ^(UITableViewCell *tableViewCell){
                UIImageView* accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x.png"]];
                
                tableViewCell.textLabel.enabled = NO;
                tableViewCell.userInteractionEnabled = YES;
                tableViewCell.accessoryView = accessoryView;
                tableViewCell.textLabel.textColor = [VLBColors colorLightGrey];
            };
        case VLBEmailStatusVerified:
            return ^(UITableViewCell *tableViewCell){
                UIImageView* accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];                
                tableViewCell.textLabel.enabled = YES;
                tableViewCell.userInteractionEnabled = YES;
                tableViewCell.accessoryView = accessoryView;
                tableViewCell.textLabel.textColor = [UIColor whiteColor];
            };
    }
}

/**
 
 
 Holds, in memory, an index of email statuses for each email account registered with thebox.
 */
@interface VLBIdentifyViewController : UIViewController <VLBVerifyUserOperationDelegate, VLBCreateUserOperationDelegate, UITableViewDelegate, VLBViewDrawRectDelegate>

@property (nonatomic, weak) IBOutlet VLBButton *identifyButton;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITableView *accountsTableView;
@property (nonatomic, weak) IBOutlet VLBButton *browseButton;

+(VLBIdentifyViewController *)newIdentifyViewController;

@end
