/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 14/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>


@interface VLBList : NSObject <NSFastEnumeration>
{
}

@property(nonatomic, strong) NSArray *textFields;

+(id)newListWithTextFields:(NSArray *)textFields;

-(id)init:(NSArray *)textFields;
-(void)textFieldDidChange:(UITextField*)aTextField;

@end
