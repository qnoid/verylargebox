/*
 *  Copyright 2010 Geeks Republic ( http://www.geeksrepublic.com )
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 25/03/2011.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
@protocol TheBoxQuery;

@protocol TheBoxDelegate <NSObject>

@optional

/*
 * Callback when the query finished without errors
 *
 * @param query the query used 
 * @parem the response string
 * @see TheBox#query
 */
- (void)query:(id<TheBoxQuery>)query ok:(NSString *)response;

/*
 * Callback when the query failed
 *
 * @param query the query used 
 * @parem the response string
 * @see TheBox#query
 */
- (void)query:(id<TheBoxQuery>)query failed:(NSString *)response;

@end
