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

/*
 * Provides all available queries to TheBox API
 *
 * @see TheBox#query
 */
@interface TheBoxQueries : NSObject 

extern NSString* const THE_BOX_SERVICE;

+(AFHTTPRequestOperation*)newCreateUserQuery:(NSObject<TBCreateUserOperationDelegate>*)delegate email:(NSString*)email;

/**
 Verifies the given email and residence with the server.
 
 @param delegate the delegate to callback
 @param email the email to register the user as
 @param residence the residence associated with the user
 */
+(AFHTTPRequestOperation*)newVerifyUserQuery:(NSObject<TBVerifyUserOperationDelegate>*)delegate email:(NSString*)email residence:(NSString*)residence;
+(AFHTTPRequestOperation*)newCategoriesQuery:(NSObject<TBCategoriesOperationDelegate>*)delegate;
+(AFHTTPRequestOperation*)newItemsQuery:(NSObject<TBItemsOperationDelegate>*)delegate;
+(AFHTTPRequestOperation*)newItemQuery:(UIImage *) image location:(NSDictionary *)location;
+(AFHTTPRequestOperation*)updateItemQuery:(NSDictionary *) item delegate:(NSObject<TBUpdateItemOperationDelegate>*)delegate;
+(AFHTTPRequestOperation*)newLocationQuery:(CLLocationDegrees)latitude longtitude:(CLLocationDegrees)longtitude delegate:(NSObject<TBLocationOperationDelegate>*)delegate;
+(AFHTTPRequestOperation*)newLocationQuery:(CLLocationDegrees)latitude longtitude:(CLLocationDegrees)longtitude query:(NSString*) query delegate:(NSObject<TBLocationOperationDelegate>*)delegate;

@end
