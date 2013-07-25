//
//  VLBViewControllers.h
//  verylargebox
//
//  Created by Markos Charatzas on 02/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^VLBTitleLabel)(UILabel *titleLabel);
typedef void(^VLBTitleButton)(UIButton *titleButton);

extern VLBTitleLabel const VLBTitleLabelPrimaryBlue;

@interface VLBViewControllers : NSObject

-(UILabel*)titleView:(NSString*)text;

-(UIButton*)titleButton:(NSString*)text target:(id)target action:(SEL)action;

-(UIButton*)attributedTitleButton:(NSString*)text target:(id)target action:(SEL)action;

-(UIBarButtonItem*)checkmarkMiniButton:(id)target action:(SEL)action;

-(UIBarButtonItem*)closeButton:(id)target action:(SEL)action;

-(UIBarButtonItem*)discardButton:(id)target action:(SEL)action;

-(UIBarButtonItem*)cameraButton:(id)target action:(SEL)action;

-(UIBarButtonItem*)locateButton:(id)target action:(SEL)action;

-(UIBarButtonItem*)idCardButton:(id)target action:(SEL)action;
@end
