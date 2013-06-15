/*
 *  Copyright 2010 Geeks Republic ( http://www.geeksrepublic.com )
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 26/03/2011.

 */
#import <UIKit/UIKit.h>


@protocol TheBoxResponseParserDelegate <NSObject>

@optional

- (void)response:(NSString*)response ok:(NSDictionary *)data;

@end
