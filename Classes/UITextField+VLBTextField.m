/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 11/03/2011.
 *  Contributor(s): .-
 */
#import "UITextField+VLBTextField.h"

@implementation UITextField (VLBTextField)

-(BOOL)vlb_isEmpty {
return [self.text length] <= 0;
}

@end
