/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 20/03/2011.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TheBoxQueries.h"
#import "TBAFHTTPRequestOperationCompletionBlocks.h"

@class TheBoxPost;
@class TheBoxGet;
@class AFHTTPRequestOperation;
@protocol TBCreateUserOperationDelegate;
@protocol TBVerifyUserOperationDelegate;
@protocol TBCategoriesOperationDelegate;
@protocol TBItemsOperationDelegate;
@protocol TBLocationOperationDelegate;
@protocol TBCreateCategoryOperationDelegate;
@protocol TBUpdateItemOperationDelegate;
@protocol TBLocalityOperationDelegate;
@protocol TBCreateItemOperationDelegate;
@protocol TBNSErrorDelegate;
@protocol AmazonServiceRequestDelegate;

@interface TBQueriesFailureBlocks : NSObject
+(TBAFHTTPRequestOperationFailureBlock)nsErrorDelegate:(NSObject<TBNSErrorDelegate>*)delegate failureBlock:(TBAFHTTPRequestOperationFailureBlock)failureBlock;
@end

/*
 * Provides all available queries to TheBox API
 *
 * @see TheBox#query
 */
@interface TheBoxQueries : NSObject  

extern NSString* const THE_BOX_SERVICE;

/**
 
 @param delegate
 @param email
 @param residence
 */
+(AFHTTPRequestOperation*)newCreateUserQuery:(NSObject<TBCreateUserOperationDelegate>*)delegate email:(NSString*)email residence:(NSString*)residence;

/**
 Verifies the given email and residence with the server.
 
 @param delegate @retained the delegate to callback
 @param email the email to register the user as
 @param residence the residence associated with the user
 */
+(AFHTTPRequestOperation*)newVerifyUserQuery:(NSObject<TBVerifyUserOperationDelegate>*)delegate email:(NSString*)email residence:(NSString*)residence;

+(AFHTTPRequestOperation*)updateItemQuery:(NSDictionary *) item delegate:(NSObject<TBUpdateItemOperationDelegate>*)delegate;
+(AFHTTPRequestOperation*)newLocationQuery:(CLLocationDegrees)latitude longtitude:(CLLocationDegrees)longtitude delegate:(NSObject<TBLocationOperationDelegate>*)delegate;
+(AFHTTPRequestOperation*)newLocationQuery:(CLLocationDegrees)latitude longtitude:(CLLocationDegrees)longtitude query:(NSString*) query delegate:(NSObject<TBLocationOperationDelegate>*)delegate;

/**
 
 */
+(AFHTTPRequestOperation*)newGetLocalities:(NSObject<TBLocalityOperationDelegate>*)delegate;

/**
 
 */
+(AFHTTPRequestOperation*)newGetLocations:(NSObject<TBLocationOperationDelegate>*)delegate;

/**
 
 */
+(AFHTTPRequestOperation*)newGetLocationsGivenLocalityName:(NSString*)localityName delegate:(NSObject<TBItemsOperationDelegate>*)delegate;
/**
 Gets the items for the given location id.
 
 @param locationId the 'location_id' as returned by #newGetLocations for a location
 @param delegate the delegate to callback with the items
 */
+(AFHTTPRequestOperation*)newGetItemsGivenLocationId:(NSUInteger)locationId delegate:(NSObject<TBItemsOperationDelegate>*)delegate;

+(void)newPostImage:(UIImage*)image delegate:(NSObject<AmazonServiceRequestDelegate>*)delegate;

/**
 Creates an item under the given user id.
 
 @param image image
 @param location location
 @param locality locality
 @param userId the user id to create the item under. 
 @see #newVerifyUserQuery
 */
+(AFHTTPRequestOperation*)newPostItemQuery:(NSString*)imageURL
                                  location:(NSDictionary *)location
                                  locality:(NSString*)locality
                                      user:(NSUInteger)userId
                                  delegate:(NSObject<TBCreateItemOperationDelegate>*)delegate;

+(AFHTTPRequestOperation*)newGetItemsGivenUserId:(NSInteger)userId delegate:(NSObject<TBItemsOperationDelegate>*)delegate;

/**
 Gets all the items in thebox given the locality
 
 @return @nillable a new AFHTTPRequestOperation or nil if locality is nil.
 */
+(AFHTTPRequestOperation*)newGetItems:(NSString*)locality delegate:(NSObject<TBItemsOperationDelegate>*)delegate;
@end
