//
//  VLBProgressView.h
//  verylargebox
//
//  Created by Markos Charatzas on 21/04/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLBProgressView : UIView

@property(nonatomic, weak) IBOutlet UIProgressView *progressView;
@property(nonatomic, weak) IBOutlet UIImageView *imageView;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
