//
//  Copyright (c) 2010 (verylargebox.com). All rights reserved.
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 14/11/2011.
//
//

#import "VLBList.h"
#import "NSArray+VLBDecorator.h"
#import "NSString+VLBDecorator.h"


@implementation VLBList

@synthesize textFields;

+(id) newListWithTextFields:(NSArray *)textFields{
return [[VLBList alloc] init:textFields];
}

-(id)init:(NSArray *)theTextFields
{
	self = [super init];
	
	if (self) {
		self.textFields = theTextFields;
	}
	
return self;
}

- (UITextField*)nextEmpty:(UITextField*)aTextField
{
	NSInteger current = [self.textFields indexOfObject:aTextField];
	
	for (NSUInteger index = current + 1; index < self.textFields.count; index++) {
		UITextField *textField = [self.textFields objectAtIndex:index];
		if ([textField.text vlb_isEmpty]) {
			return textField;
		}
	}
	
return nil;
}

-(void)textFieldDidChange:(UITextField*)aTextField
{
	if ([textFields vlb_isLast:aTextField]){
		return;
	}
	
	UITextField *next = [self nextEmpty:aTextField];
	
	if ([aTextField.text vlb_isEmpty])
	{
		next.hidden = YES;
		next.enabled = NO;
	return;
	}		
	
	next.hidden = NO;	
	next.enabled = YES;
}

-(NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained *)stackbuf count:(NSUInteger)len{
return [self.textFields countByEnumeratingWithState:state objects:stackbuf count:len];	
}

@end
