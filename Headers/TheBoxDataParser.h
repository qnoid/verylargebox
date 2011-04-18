/*
 *  Copyright 2010 Geeks Republic ( http://www.geeksrepublic.com )
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 02/04/2011.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>


@protocol TheBoxDataParser <NSObject>

@property(nonatomic, assign) id<TheBoxDataParserDelegate> delegate;

-(void)parse:(NSDictionary *) data;

@end
