//
//  VLBProgressView.h
//  thebox
//
//  Created by Markos Charatzas on 21/04/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLBProgressView : UIView

@property(nonatomic, weak) IBOutlet UIProgressView *progressView;
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@end
