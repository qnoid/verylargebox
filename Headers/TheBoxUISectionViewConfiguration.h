/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 13/03/2011.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import "TheBoxUIViewConfiguration.h"

@interface TheBoxUISectionViewConfiguration : NSObject <TheBoxUIViewConfiguration> 
{
	@private
		int columnFrameWidth;
}

@property(nonatomic, assign) int columnFrameWidth;

-(id)initWithColumnFrameWidth:(int) columnFrameWidth;

@end
