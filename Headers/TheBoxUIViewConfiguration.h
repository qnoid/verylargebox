/*
 *  Copyright 2010 Geeks Republic ( http://www.geeksrepublic.com )
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 13/03/2011.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>


@protocol TheBoxUIViewConfiguration <NSObject>

@required
-(void)configure:(UIScrollView*)view;

@end
