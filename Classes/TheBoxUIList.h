/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 14/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>


@interface TheBoxUIList : NSObject <NSFastEnumeration>
{
	@private
		NSArray *textFields;
	
}

@property(nonatomic, retain) NSArray *textFields;

+(id)newListWithTextFields:(NSArray *)textFields;

-(id)init:(NSArray *)textFields;
-(void)textFieldDidChange:(UITextField*)aTextField;

@end
