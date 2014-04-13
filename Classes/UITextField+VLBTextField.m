//
//  UITextField+VLBTextField.m
//  verylargebox
//
//  Created by Markos Charatzas on 05/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import "UITextField+VLBTextField.h"

@implementation UITextField (VLBTextField)

-(BOOL)vlb_isEmpty {
return [self.text length] <= 0;
}

@end
