/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 20/03/2011.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
@class TheBoxPost;
@class TheBoxGet;

/*
 * Provides all available queries to TheBox API
 *
 * @see TheBox#query
 */
@interface TheBoxQueries : NSObject 
{

}

+(TheBoxGet *)newItemsQuery;
+(TheBoxPost *)newItemQuery:(UIImage *) image itemName:(NSString *)itemName locationName:(NSString *)locationName categoryName:(NSString *)categoryName tags:(NSArray *)tags;


@end