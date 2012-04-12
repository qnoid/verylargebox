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
#import <CoreLocation/CoreLocation.h>
@class TheBoxPost;
@class TheBoxGet;
@class AFHTTPRequestOperation;
@protocol TBCategoriesOperationDelegate;
@protocol TBLocationOperationDelegate;

/*
 * Provides all available queries to TheBox API
 *
 * @see TheBox#query
 */
@interface TheBoxQueries : NSObject 
{

}

+(AFHTTPRequestOperation*)newItemsQuery:(NSObject<TBCategoriesOperationDelegate>*)delegate;
+(AFHTTPRequestOperation*)newItemQuery:(UIImage *) image itemName:(NSString *)itemName location:(NSDictionary *)location categoryName:(NSString *)categoryName tags:(NSArray *)tags;
+(AFHTTPRequestOperation*)newLocationQuery:(CLLocationDegrees)latitude longtitude:(CLLocationDegrees)longtitude delegate:(NSObject<TBLocationOperationDelegate>*)delegate;


@end
