//
//  VLBTextViewController.h
//  verylargebox
//
//  Created by Markos Charatzas on 08/04/2014.
//  Copyright (c) 2014 verylargebox.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLBTextViewController : UIViewController

@property(nonatomic, weak) IBOutlet UITextView *textView;
@property(nonatomic, copy)  NSAttributedString *attributedText;

+(instancetype)textViewController:(NSString*)title;

@end
