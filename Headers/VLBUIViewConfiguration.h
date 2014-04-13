//
//  VLBUIViewConfiguration.h
//  verylargebox
//
//  Created by Markos Charatzas on 05/07/2013.
//  Copyright (c) 2013 verylargebox.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol VLBUIViewConfiguration <NSObject>

@required
-(void)configure:(UIScrollView*)view;

@end
