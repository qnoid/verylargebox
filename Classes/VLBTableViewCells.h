//
//  VLBTableViewCells.h
//  verylargebox
//
//  Created by Markos Charatzas on 22/07/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLBColors.h"

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
                UIImageView* accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exclamation-mark.png"]];
                
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

@interface VLBTableViewCells : NSObject

+(UITableViewCell*)newEmailTableViewCell;

@end
