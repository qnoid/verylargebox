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
#import "ASIHTTPRequestDelegate.h"
@protocol TheBoxResponseParserDelegate;
@protocol TheBoxDataParserDelegate;
@protocol TheBoxQuery;
@protocol  TheBoxDataParser;
@class TheBoxPost;
@class TheBoxCache;

/*
 * TheBox traces every method call to the TheBoxDelegate
 */
@interface TheBox : NSObject <TheBoxDelegate, ASIHTTPRequestDelegate>
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
 * Take advantage of caching and multiple delegation on different parts
 * of the response
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

-(void)dataParser:(id<TheBoxDataParser>)aDataParser;
-(void)responseParserDelegate:(id<TheBoxResponseParserDelegate>)delegate;
-(void)dataParserDelegate:(id<TheBoxDataParserDelegate>)delegate;
-(TheBox*) build;

@end

