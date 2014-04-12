//
//  VLBViewControllers.h
//  verylargebox
//
//  Created by Markos Charatzas on 02/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLBQueries.h"

typedef void(^VLBTitleLabel)(UILabel *titleLabel);
typedef void(^VLBTitleButton)(UIButton *titleButton, NSString *text);
typedef void(^VLBAttributedTitleButton)(UIButton *titleButton, NSDictionary *attributes);


extern VLBTitleLabel const VLBTitleLabelNavigation;
extern VLBTitleLabel const VLBTitleLabelPrimaryBlue;
extern VLBTitleButton const VLBTitleButtonAttributed;
extern VLBAttributedTitleButton const VLBAttributedTitleButtonn;
extern VLBTitleButton const VLBTitleButtonAttributedWhite;
extern VLBTitleButton const VLBTitleButtonAttributedd;


@interface VLBViewControllers : NSObject

-(UILabel*)titleView:(NSString*)text;

-(UIButton*)titleButton:(NSString*)text target:(id)target action:(SEL)action;

-(UIButton*)attributedTitleButton:(NSString*)text target:(id)target action:(SEL)action;

-(UIBarButtonItem*)refreshButton:(id)target action:(SEL)action;

-(UIBarButtonItem*)checkmarkMiniButton:(id)target action:(SEL)action;

-(UIBarButtonItem*)closeButton:(id)target action:(SEL)action;

-(UIBarButtonItem*)discardButton:(id)target action:(SEL)action;

-(UIBarButtonItem*)cameraButton:(id)target action:(SEL)action;

-(UIBarButtonItem*)locateButton:(id)target action:(SEL)action;

-(UIBarButtonItem*)idCardButton:(id)target action:(SEL)action;

-(VLBMarkdownSucessBlock)presentTextViewController:(__weak UIViewController*)presentingViewController title:(NSString*)title;
@end
