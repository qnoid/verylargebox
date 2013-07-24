//
// 	VLBViewControllers.m
//  verylargebox
//
//  Created by Markos Charatzas on 05/07/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBViewControllers.h"
#import "VLBTypography.h"
#import "VLBColors.h"

@implementation VLBViewControllers

VLBTitleLabel const VLBTitleLabelNavigation = ^(UILabel *titleLabel)
{
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [VLBTypography fontAvenirNextDemiBoldSixteen];
    titleLabel.adjustsFontSizeToFitWidth = YES;
};

VLBTitleLabel const VLBTitleLabelPrimaryBlue = ^(UILabel *titleLabel)
{
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [VLBTypography fontAvenirNextDemiBoldTweenty];
    titleLabel.minimumScaleFactor = 10;
    titleLabel.adjustsFontSizeToFitWidth = YES;
};

-(UIBarButtonItem*)barButtonItem:(id)target action:(SEL)action imageNamed:(NSString*) imageNamed
{
    UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, 0, 30, 30)];
    [closeButton setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
    [closeButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
return [[UIBarButtonItem alloc] initWithCustomView:closeButton];
}

-(UILabel*)titleView:(NSString*)text
{
    UILabel* titleLabel = [[UILabel alloc] init];
    VLBTitleLabelNavigation(titleLabel);
    titleLabel.text = text;

return titleLabel;
}

-(UIButton*)titleButton:(NSString*)text target:(id)target action:(SEL)action
{
    UIButton* titleButon = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButon addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    VLBTitleLabelNavigation(titleButon.titleLabel);
    [titleButon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [titleButon setTitle:text forState:UIControlStateNormal];
    [titleButon.titleLabel sizeToFit];

return titleButon;
}

-(UIBarButtonItem*)checkmarkMiniButton:(id)target action:(SEL)action {
    return [self barButtonItem:target action:action imageNamed:@"checkmark-mini.png"];
}

-(UIBarButtonItem*)closeButton:(id)target action:(SEL)action {
return [self barButtonItem:target action:action imageNamed:@"down-arrow.png"];
}

-(UIBarButtonItem*)discardButton:(id)target action:(SEL)action {
return [self barButtonItem:target action:action imageNamed:@"circlex.png"];
}

-(UIBarButtonItem*)cameraButton:(id)target action:(SEL)action {
return [self barButtonItem:target action:action imageNamed:@"camera-mini.png"];
}

-(UIBarButtonItem*)locateButton:(id)target action:(SEL)action {
return [self barButtonItem:target action:action imageNamed:@"target.png"];
}

-(UIBarButtonItem*)idCardButton:(id)target action:(SEL)action {
    return [self barButtonItem:target action:action imageNamed:@"idcard.png"];
}

@end
