/*
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid)  on 27/04/2012.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import "UploadUIViewController.h"

@interface TheBoxUIAddView : UIView

@property(nonatomic, unsafe_unretained) IBOutlet UIButton *addButton;
@property(nonatomic, strong) NSDictionary* category;
@property(nonatomic, unsafe_unretained) NSObject<TBCreateItemOperationDelegate> *createItemDelegate;
@property(nonatomic, unsafe_unretained) UIViewController* owner;

+(TheBoxUIAddView*)loadWithOwner:(UIViewController*)owner;
-(IBAction)upload:(id)sender;

@end
