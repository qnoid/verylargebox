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
#import "TheBoxDelegate.h"
@protocol TheBoxDataDelegate;
@protocol TheBoxQuery;
@class TheBoxPost;
@class TheBoxCache;

/*
 * TheBox traces every method call to the TheBoxDelegate
 */
@interface TheBox : NSObject <TheBoxDelegate>
{
	@private
		id<TheBoxDelegate> delegate;
}

+(TheBox*) checkIn;

/*
 * @optional assign a delegate to receive a callback on
 *	
 *	TheBoxDelegate#query:ok:
 *	TheBoxDelegate#query:failed:
 */
@property(nonatomic, assign) id<TheBoxDelegate> delegate;

/*
 * Makes the query and makes a callback to TheBoxDelegate as specified
 * using
 *
 *	TheBox.delegate
 *
 * In case of an equal query, a cached response will be provided in the
 * callback
 * 
 */
-(void)query:(id<TheBoxQuery>)query;

@end


/*
 * Use to customise TheBox
 * @see TheBoxBuilder#delegate
 */
@interface TheBoxBuilder : NSObject
{

}

-(void)delegate:(id<TheBoxDataDelegate>)delegate;
-(TheBox*) build;

@end

