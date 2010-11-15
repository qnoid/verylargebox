/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 14/11/10.
 *  Contributor(s): .-
 */
#import "TheBoxUIList.h"
#import "NSArray+Decorator.h"
#import "NSString+Decorator.h"


@implementation TheBoxUIList

@synthesize textFields;

+(id) listWithTextFields:(NSArray *)textFields{
return [[TheBoxUIList alloc] init:textFields];
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
	
	for (int index = current + 1; index < self.textFields.count; index++) {
		UITextField *textField = [self.textFields objectAtIndex:index];
		if ([textField.text isEmpty]) {
			return textField;
		}
	}
	
return nil;
}

-(void)textFieldDidChange:(UITextField*)aTextField
{
	if ([textFields isLast:aTextField]){
		return;
	}
	
	UITextField *next = [self nextEmpty:aTextField];
	
	if ([aTextField.text isEmpty])
	{
		next.hidden = YES;
		next.enabled = NO;
	return;
	}		
	
	next.hidden = NO;	
	next.enabled = YES;
}

-(NSUInteger) countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len{
return [self.textFields countByEnumeratingWithState:state objects:stackbuf count:len];	
}

- (void) dealloc
{
	[self.textFields release];
	[super dealloc];
}

@end
