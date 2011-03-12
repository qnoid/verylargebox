/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 11/03/2011.
 *  Contributor(s): .-
 */
#import "UITextField+TheBoxUITextField.h"

@implementation UITextField (TheBoxUITextField)

-(BOOL)isEmpty{
return [self.text length] <= 0;
}

@end
