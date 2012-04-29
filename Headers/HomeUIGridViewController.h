/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 23/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import "TheBoxUIGridViewController.h"
#import "TheBoxLocationServiceDelegate.h"
#import "TBItemsOperationDelegate.h"
#import "TBCreateItemOperationDelegate.h"
#import "TBCreateCategoryOperationDelegate.h"
@class TheBoxLocationService;
@class TheBoxUIGridView;
@class TheBoxUIScrollView;

@interface HomeUIGridViewController : TheBoxUIGridViewController <TheBoxLocationServiceDelegate, UISearchBarDelegate, TBItemsOperationDelegate, TBCreateItemOperationDelegate, TheBoxUIScrollViewDatasource, TheBoxUIScrollViewDelegate, TBCreateCategoryOperationDelegate> 
{
    
}

+(HomeUIGridViewController*)newHomeGridViewController;

@property(nonatomic, unsafe_unretained) IBOutlet UIView *headerSection;
@property(nonatomic, unsafe_unretained) IBOutlet UIImageView *addIcon;
@property(nonatomic, unsafe_unretained) IBOutlet UIButton *addButton;

@property(nonatomic, unsafe_unretained) IBOutlet TheBoxUIGridView* gridView;
@property(nonatomic, unsafe_unretained) IBOutlet TheBoxUIScrollView* scrollView;

- (IBAction)addCategory:(id)sender;

@end
