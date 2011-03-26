/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 25/03/2011.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
#import "TheBoxQuery.h"

@interface ItemsQuery : NSObject <TheBoxQuery> {} @end
@interface QueryCounter : NSObject <TheBoxQuery> 
{
	@private
		int counter;
}
@property(nonatomic, assign) int counter;
@end

@interface TheBoxTestQueries : NSObject <TheBoxDelegate> {

}


+(QueryCounter*)newQueryCounter;
+(ItemsQuery*)newItemsQuery;

@end
