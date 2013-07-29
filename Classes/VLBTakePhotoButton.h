//
//  VLBTakePhotoButton.h
//  verylargebox
//
//  Created by Markos Charatzas on 29/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLBTakePhotoButton : UIView

@property(nonatomic, weak) IBOutlet UIButton *button;

-(void)addTarget:(id)target action:(SEL)action;

@end
