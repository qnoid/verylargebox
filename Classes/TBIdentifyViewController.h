//
//  TBIdentifyViewController.h
//  thebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TBButton.h"
#import "TBVerifyUserOperationDelegate.h"
#import "TBCreateUserOperationDelegate.h"
#import "TBView.h"
#import "TBAFHTTPRequestOperationCompletionBlocks.h"

@protocol TBButton;

typedef NS_ENUM(NSInteger, TBEmailStatus){
    TBEmailStatusDefault,
    TBEmailStatusError,
    TBEmailStatusUnknown,
    TBEmailStatusUnauthorised,
    TBEmailStatusVerified
};

typedef void(^TBEmailStatusBlock)(UITableViewCell* tableViewCell);

NS_INLINE
TBEmailStatusBlock tbBmailStatus(TBEmailStatus emailStatus)
{
    switch (emailStatus) {
        case TBEmailStatusDefault:
            return ^(UITableViewCell *tableViewCell){
                tableViewCell.textLabel.enabled = YES;
                tableViewCell.userInteractionEnabled = YES;
                tableViewCell.accessoryType = UITableViewCellAccessoryNone;
            };
        case TBEmailStatusError:
            return ^(UITableViewCell *tableViewCell){
                UIImageView* accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh.png"]];
                
                tableViewCell.textLabel.enabled = NO;
                tableViewCell.userInteractionEnabled = YES;
                tableViewCell.accessoryView = accessoryView;
            };            
        case TBEmailStatusUnknown:
            return ^(UITableViewCell *tableViewCell){
                UIActivityIndicatorView* accessoryView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [accessoryView startAnimating];
                
                tableViewCell.selected = NO;
                tableViewCell.userInteractionEnabled = NO;
                tableViewCell.textLabel.enabled = NO;
                tableViewCell.accessoryView = accessoryView;
            };
        case TBEmailStatusUnauthorised:
            return ^(UITableViewCell *tableViewCell){
                UIImageView* accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"x.png"]];
                
                tableViewCell.textLabel.enabled = NO;
                tableViewCell.userInteractionEnabled = YES;
                tableViewCell.accessoryView = accessoryView;
            };
        case TBEmailStatusVerified:
            return ^(UITableViewCell *tableViewCell){
                UIImageView* accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];                
                tableViewCell.textLabel.enabled = YES;
                tableViewCell.userInteractionEnabled = YES;
                tableViewCell.accessoryView = accessoryView;
            };
    }
}

@interface TBIdentifyViewController : UIViewController <TBVerifyUserOperationDelegate, TBCreateUserOperationDelegate, UITableViewDelegate, TBViewDrawRectDelegate>

@property (nonatomic, weak) IBOutlet TBButton *identifyButton;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITableView *accountsTableView;
@property (nonatomic, weak) IBOutlet TBButton *showMoreButton;
@property (nonatomic, weak) IBOutlet TBButton *browseButton;

+(TBIdentifyViewController*)newIdentifyViewController;

@end
