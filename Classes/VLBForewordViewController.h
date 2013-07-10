//
//  VLBForewordViewController.h
//  verylargebox
//
//  Created by Markos Charatzas on 10/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLBForewordViewController : UIViewController

@property(nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property(nonatomic, weak) IBOutlet UIImageView *imageView;

+(VLBForewordViewController*)newForewordViewController;
-(IBAction)didTouchUpInsideTwitterHandleButton:(id)sender;

@end
