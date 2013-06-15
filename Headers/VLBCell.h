/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 8/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface VLBCell : UIView

@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *itemImageView;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *itemLabel;

+(VLBCell *)loadWithOwner:(id)owner;

-(id)initWith:(UIImageView *)itemImageView itemLabel:(UILabel *)itemLabel;

@end