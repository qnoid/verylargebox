/*
 *  Copyright (c) 2010 (verylargebox.com). All rights reserved.
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 20/03/2011.

 */
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "VLBQueries.h"
#import "VLBAFHTTPRequestOperationCompletionBlocks.h"

@class TheBoxPost;
@class TheBoxGet;
@class AFHTTPRequestOperation;
@protocol VLBCreateUserOperationDelegate;
@protocol VLBVerifyUserOperationDelegate;
@protocol TBCategoriesOperationDelegate;
@protocol VLBItemsOperationDelegate;
@protocol VLBLocationOperationDelegate;
@protocol TBCreateCategoryOperationDelegate;
@protocol VLBUpdateItemOperationDelegate;
@protocol VLBLocalityOperationDelegate;
@protocol VLBCreateItemOperationDelegate;
@protocol VLBNSErrorDelegate;
@protocol AmazonServiceRequestDelegate;

@interface VLBQueriesFailureBlocks : NSObject
+(VLBAFHTTPRequestOperationFailureBlock)nsErrorDelegate:(NSObject<VLBNSErrorDelegate>*)delegate failureBlock:(VLBAFHTTPRequestOperationFailureBlock)failureBlock;
@end

/*
 * Provides all available queries to TheBox API
 *
 * @see TheBox#query
 */
@interface VLBQueries : NSObject

extern NSString* const THE_BOX_SERVICE;

/**
 
 @param delegate
 @param email
 @param residence
 */
+(AFHTTPRequestOperation*)newCreateUserQuery:(NSObject<VLBCreateUserOperationDelegate>*)delegate email:(NSString*)email residence:(NSString*)residence;

/**
 Verifies the given email and residence with the server.
 
 @param delegate @retained the delegate to callback
 @param email the email to register the user as
 @param residence the residence associated with the user
 */
+(AFHTTPRequestOperation*)newVerifyUserQuery:(NSObject<VLBVerifyUserOperationDelegate>*)delegate email:(NSString*)email residence:(NSString*)residence;

+(AFHTTPRequestOperation*)updateItemQuery:(NSDictionary *) item delegate:(NSObject<VLBUpdateItemOperationDelegate>*)delegate;
+(AFHTTPRequestOperation*)newLocationQuery:(CLLocationDegrees)latitude longtitude:(CLLocationDegrees)longtitude delegate:(NSObject<VLBLocationOperationDelegate>*)delegate;
+(AFHTTPRequestOperation*)newLocationQuery:(CLLocationDegrees)latitude longtitude:(CLLocationDegrees)longtitude query:(NSString*) query delegate:(NSObject<VLBLocationOperationDelegate>*)delegate;

/**
 
 */
+(AFHTTPRequestOperation*)newGetLocalities:(NSObject<VLBLocalityOperationDelegate>*)delegate;

/**
 
 */
+(AFHTTPRequestOperation*)newGetLocations:(NSObject<VLBLocationOperationDelegate>*)delegate;

/**
 
 */
+(AFHTTPRequestOperation*)newGetLocationsGivenLocalityName:(NSString*)localityName delegate:(NSObject<VLBItemsOperationDelegate>*)delegate;
/**
 Gets the items for the given location id.
 
 @param locationId the 'location_id' as returned by #newGetLocations for a location
 @param delegate the delegate to callback with the items
 */
+(AFHTTPRequestOperation*)newGetItemsGivenLocationId:(NSUInteger)locationId delegate:(NSObject<VLBItemsOperationDelegate>*)delegate;

+(AFHTTPRequestOperation*)newGetItemsGivenLocationId:(NSUInteger)locationId page:(NSNumber*)page delegate:(NSObject<VLBItemsOperationDelegate>*)delegate;

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
                                  delegate:(NSObject<VLBCreateItemOperationDelegate>*)delegate;

+(AFHTTPRequestOperation*)newGetItemsGivenUserId:(NSUInteger)userId delegate:(NSObject<VLBItemsOperationDelegate>*)delegate;

+(AFHTTPRequestOperation*)newGetItemsGivenUserId:(NSUInteger)userId page:(NSNumber*)page delegate:(NSObject<VLBItemsOperationDelegate>*)delegate;

/**
 Gets all the items in thebox given the locality
 
 @return @nillable a new AFHTTPRequestOperation or nil if locality is nil.
 */
+(AFHTTPRequestOperation*)newGetItems:(NSString*)locality delegate:(NSObject<VLBItemsOperationDelegate>*)delegate;

+(AFHTTPRequestOperation*)newGetItems:(NSString*)locality page:(NSNumber*)page delegate:(NSObject<VLBItemsOperationDelegate>*)delegate;

@end
