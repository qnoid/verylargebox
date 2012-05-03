/*
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid)  on 27/04/2012.
 *  Contributor(s): .-
 */
#import "TheBoxUIAddView.h"

@implementation TheBoxUIAddView


+(TheBoxUIAddView*)loadWithOwner:(id)owner
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"TheBoxUIAddView" owner:owner options:nil];
    
    TheBoxUIAddView* view = (TheBoxUIAddView*)[views objectAtIndex:0];
    view.owner = owner;
    
return view;
}

@synthesize addButton;
@synthesize category;
@synthesize createItemDelegate;
@synthesize owner;

-(void)awakeFromNib
{
    self.addButton.titleLabel.numberOfLines = 0;
}

- (IBAction)upload:(id)sender
{
    NSLog(@"Will add item under category '%@:%@'", [category objectForKey:@"id"], [category objectForKey:@"name"]);

    UploadUIViewController *uploadViewController = [UploadUIViewController newUploadUIViewController:category];
    uploadViewController.createItemDelegate = self.createItemDelegate;
    [self.owner presentModalViewController:uploadViewController animated:YES];   
}

@end
