/*
 *  Copyright 2010 Geeks Republic ( http://www.geeksrepublic.com )
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 26/03/2011.
 *  Contributor(s): .-
 */

@protocol TheBoxResponseParserDelegate <NSObject>

@optional

- (void)response:(NSString*)response error:(id)data;
- (void)response:(NSString*)response ok:(id)data;

@end
