//
//  VLBTableViewCells.m
//  verylargebox
//
//  Created by Markos Charatzas on 22/07/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//
#import "VLBTableViewCells.h"
#import "VLBTypography.h"

@implementation VLBTableViewCells

+(UITableViewCell*)newEmailTableViewCell
{
    UITableViewCell *emailCell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VLBEmailTableViewCell"];
    emailCell.textLabel.font = [VLBTypography fontAvenirNextDemiBoldTweenty];
    emailCell.textLabel.adjustsFontSizeToFitWidth = YES;
    UIView* selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [VLBColors colorPrimaryBlue];
    emailCell.selectedBackgroundView = selectedBackgroundView;
    vlbEmailStatus(VLBEmailStatusDefault)(emailCell);
    
return emailCell;
}

@end
