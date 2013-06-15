//
//  Copyright (c) 2010 (verylargebox.com). All rights reserved.
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 11/03/2011.
//
//

#import "UITextField+VLBTextField.h"

@implementation UITextField (VLBTextField)

-(BOOL)vlb_isEmpty {
return [self.text length] <= 0;
}

@end
