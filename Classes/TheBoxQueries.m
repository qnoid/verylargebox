/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 20/03/2011.
 *  Contributor(s): .-
 */
#import "TheBoxQueries.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "TBItemsOperationDelegate.h"
#import "JSONKit.h"
#import "TBLocationOperationDelegate.h"
#import "NSMutableDictionary+TBMutableDictionary.h"
#import "TBUpdateItemOperationDelegate.h"
#import "TBCreateUserOperationDelegate.h"
#import "TBVerifyUserOperationDelegate.h"
#import "TBSecureHashA1.h"
#import "TBAFHTTPRequestOperationCompletionBlocks.h"
#import "TBNSErrorDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "TBLocalityOperationDelegate.h"
#import "TBCreateItemOperationDelegate.h"
#import "TBMacros.h"

static NSString* const LOCALITIES = @"/localities";
static NSString* const LOCATIONS = @"/locations";
static NSString* const LOCATION_ITEMS = @"/locations/%d/items";
static NSString* const USER_ITEMS = @"/users/%u/items";
static NSString* const ITEMS = @"/items";


@implementation TBQueriesFailureBlocks

+(TBAFHTTPRequestOperationFailureBlock)nsErrorDelegate:(NSObject<TBNSErrorDelegate>*)delegate failureBlock:(TBAFHTTPRequestOperationFailureBlock)failureBlock
{
return ^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"WARNING: %s %@", __PRETTY_FUNCTION__, error);
        if(TB_ERROR_BLOCK_CANNOT_CONNECT_TO_HOST(error)){
            [delegate didFailWithCannonConnectToHost:error];
        return;
        }
        
        if(TB_ERROR_BLOCK_NOT_CONNECTED_TO_INTERNET(error)){
            [delegate didFailWithNotConnectToInternet:error];
        return;
        }
        
        failureBlock(operation, error);
    };
}
@end

@interface TheBoxQueries ()

/**
 Migrate to 4sq queries class along with #newParameters if it starts to creep
 */
+(AFHTTPRequestOperation*)newLocationQuery:(NSDictionary*)parameters delegate:(NSObject<TBLocationOperationDelegate>*)delegate;
@end

@implementation TheBoxQueries

NSString* const THE_BOX_SERVICE = @"com.verylargebox";

NSString* const THE_BOX_BASE_URL_STRING = @"http://www.verylargebox.com"; //@"http://0.0.0.0:3000";//
 
NSString* const FOURSQUARE_BASE_URL_STRING = @"https://api.foursquare.com/v2/";
NSString* const FOURSQUARE_CLIENT_ID = @"ITAJQL0VFSH1W0BLVJ1BFUHIYHIURCHZPFBKCRIKEYYTAFUW";
NSString* const FOURSQUARE_CLIENT_SECRET = @"PVWUAMR2SUPKGSCUX5DO1ZEBVCKN4UO5J4WEZVA3WV01NWTK";
NSUInteger const TIMEOUT = 60;

+(void)initialize
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

+(AFHTTPRequestOperation*)newCreateUserQuery:(NSObject<TBCreateUserOperationDelegate>*)delegate email:(NSString*)email residence:(NSString*)residence
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters tbSetObjectIfNotNil:email forKey:@"email"];
    [parameters tbSetObjectIfNotNil:residence forKey:@"residence"];

    NSMutableURLRequest *registrationRequest = [client requestWithMethod:@"POST" path:@"/users" parameters:parameters];
    [registrationRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [registrationRequest setTimeoutInterval:TIMEOUT];

    TBAFHTTPRequestOperationFailureBlock didFailOnRegistrationWithError =
        [TBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [delegate didFailOnRegistrationWithError:error];
        }];

    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:registrationRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [delegate didSucceedWithRegistrationForEmail:email residence:residence];
    } 
    failure:didFailOnRegistrationWithError];
    
return request;
}

+(AFHTTPRequestOperation*)newVerifyUserQuery:(NSObject<TBVerifyUserOperationDelegate>*)delegate email:(NSString*)email residence:(NSString*)residence;
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters tbSetObjectIfNotNil:residence forKey:@"residence"];
    [parameters tbSetObjectIfNotNil:email forKey:@"email"];
    
    NSMutableURLRequest *registrationRequest = [client requestWithMethod:@"GET" path:@"/users" parameters:parameters];
    [registrationRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [registrationRequest setTimeoutInterval:TIMEOUT];
    
    TBAFHTTPRequestOperationFailureBlock didFailOnRegistrationWithError =
    [TBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnVerifyWithError:error];
    }];

    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:registrationRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
   {
       [delegate didSucceedWithVerificationForEmail:email residence:[[operation.responseString objectFromJSONString] objectForKey:@"residence"]];
   }
   failure:didFailOnRegistrationWithError];
    
return request;
}

+(AFHTTPRequestOperation*)newGetLocationsGivenLocalityName:(NSString*)localityName delegate:(NSObject<TBLocationOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableURLRequest *categoriesRequest = [client requestWithMethod:@"GET"
                                                                  path:@"/locations"
                                                            parameters:@{@"locality[name]":localityName}];
    
    [categoriesRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [categoriesRequest setTimeoutInterval:TIMEOUT];
    
    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:categoriesRequest success:^(AFHTTPRequestOperation *operation, id responseObject) 
    {
        NSString* responseString = operation.responseString;        
        [delegate didSucceedWithLocations:[responseString mutableObjectFromJSONString]];
    } 
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnLocationWithError:error];
    }];
    
    return request;
}

+(AFHTTPRequestOperation*)updateItemQuery:(NSDictionary *) item delegate:(NSObject<TBUpdateItemOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters tbSetObjectIfNotNil:[[item objectForKey:@"location"] objectForKey:@"name"] forKey:@"item[location_attributes][name]"];
    [parameters tbSetObjectIfNotNil:[[[item objectForKey:@"location"] objectForKey:@"location"] objectForKey:@"lat"] forKey:@"item[location_attributes][latitude]"];
    [parameters tbSetObjectIfNotNil:[[[item objectForKey:@"location"] objectForKey:@"location"] objectForKey:@"lng"] forKey:@"item[location_attributes][longitude]"];
    
    NSMutableURLRequest* request = [client requestWithMethod:@"PUT" 
                                                        path:[NSString stringWithFormat:@"items/%@", [item objectForKey:@"id"]] parameters:parameters];
                                    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setTimeoutInterval:TIMEOUT];
    
	AFHTTPRequestOperation *updateItem = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [updateItem setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [delegate didSucceedWithItem:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnUpdateItemWithError:error];
    }];
    
    return updateItem;

}

#pragma mark 4sq default parameters
+(NSMutableDictionary*)newParameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                FOURSQUARE_CLIENT_ID, @"client_id",
                                FOURSQUARE_CLIENT_SECRET, @"client_secret",
                                @"20120411", @"v",
                                nil];
    
return parameters;
}

+(AFHTTPRequestOperation*)newLocationQuery:(NSDictionary*)parameters delegate:(NSObject<TBLocationOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:FOURSQUARE_BASE_URL_STRING]];
    
    NSMutableURLRequest *categoriesRequest = [client requestWithMethod:@"GET" path:@"venues/search" parameters:parameters];
    [categoriesRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [categoriesRequest setTimeoutInterval:TIMEOUT];
    
    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:categoriesRequest success:^(AFHTTPRequestOperation *operation, id responseObject) 
    {
        NSString* responseString = operation.responseString;

        [delegate didSucceedWithLocations:[[[responseString objectFromJSONString] objectForKey:@"response"] objectForKey:@"venues"]];
    } 
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnLocationWithError:error];
    }];
    
    return request;    
}

+(AFHTTPRequestOperation*)newLocationQuery:(CLLocationDegrees)latitude longtitude:(CLLocationDegrees)longtitude delegate:(NSObject<TBLocationOperationDelegate>*)delegate
{
    NSMutableDictionary *parameters = [self newParameters];

    [parameters setObject:[NSString stringWithFormat:@"%f,%f", latitude, longtitude] forKey:@"ll"];
    
return [self newLocationQuery:parameters delegate:delegate];    
}

+(AFHTTPRequestOperation*)newLocationQuery:(CLLocationDegrees)latitude longtitude:(CLLocationDegrees)longtitude query:(NSString*) query delegate:(NSObject<TBLocationOperationDelegate>*)delegate
{
    NSMutableDictionary *parameters = [self newParameters];
    
    [parameters setObject:query forKey:@"query"];
    [parameters setObject:[NSString stringWithFormat:@"%f,%f", latitude, longtitude] forKey:@"ll"];
    
return [self newLocationQuery:parameters delegate:delegate];    
}

+(AFHTTPRequestOperation*)newGetLocalities:(NSObject<TBLocalityOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableURLRequest *categoriesRequest =
    [client requestWithMethod:@"GET" path:LOCALITIES parameters:nil];
    
    [categoriesRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [categoriesRequest setTimeoutInterval:TIMEOUT];
    
    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:categoriesRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       NSString* responseString = operation.responseString;
       [delegate didSucceedWithLocalities:[responseString mutableObjectFromJSONString]];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnLocalitiesWithError:error];
    }];
    
    return request;
}

+(AFHTTPRequestOperation*)newGetLocations:(NSObject<TBLocationOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableURLRequest *categoriesRequest =
    [client requestWithMethod:@"GET" path:LOCATIONS parameters:nil];
    
    [categoriesRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [categoriesRequest setTimeoutInterval:TIMEOUT];
    
    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:categoriesRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
   {
       NSString* responseString = operation.responseString;
       [delegate didSucceedWithLocations:[responseString mutableObjectFromJSONString]];
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [delegate didFailOnLocationWithError:error];
   }];

return request;
}

+(AFHTTPRequestOperation*)newGetItemsGivenLocationId:(NSUInteger)locationId delegate:(NSObject<TBItemsOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableURLRequest *categoriesRequest =
        [client requestWithMethod:@"GET" path:[NSString stringWithFormat:LOCATION_ITEMS, locationId] parameters:nil];
    
    [categoriesRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [categoriesRequest setTimeoutInterval:TIMEOUT];
    
    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:categoriesRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       NSString* responseString = operation.responseString;
       [delegate didSucceedWithItems:[responseString mutableObjectFromJSONString]];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [delegate didFailOnItemsWithError:error];
    }];

return request;
}

+(AFHTTPRequestOperation*)newPostItemQuery:(UIImage *)image
                                  location:(NSDictionary *)location
                                  locality:(NSString*)locality
                                      user:(NSUInteger)userId
                                  delegate:(NSObject<TBCreateItemOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
	NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters tbSetObjectIfNotNil:[location objectForKey:@"name"] forKey:@"item[location_attributes][name]"];
    [parameters tbSetObjectIfNotNil:[[location objectForKey:@"location"] objectForKey:@"lat"] forKey:@"item[location_attributes][lat]"];
    [parameters tbSetObjectIfNotNil:[[location objectForKey:@"location"] objectForKey:@"lng"] forKey:@"item[location_attributes][lng]"];
    [parameters tbSetObjectIfNotNil:[location objectForKey:@"id"] forKey:@"item[location_attributes][foursquareid]"];
    [parameters tbSetObjectIfNotNil:locality forKey:@"item[location_attributes][locality_attributes][name]"];
    
    NSMutableURLRequest* request = [client multipartFormRequestWithMethod:@"POST"
                                                                     path:[NSString stringWithFormat:USER_ITEMS, userId]
                                                               parameters:parameters
                                                constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                                {
                                                    [formData appendPartWithFileData:imageData
                                                                                name:@"item[image]"
                                                                            fileName:@".jpg"
                                                                            mimeType:@"image/jpeg"];
                                                }];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setTimeoutInterval:TIMEOUT];
    
	AFHTTPRequestOperation *createItem = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [createItem setUploadProgressBlock:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
        NSLog(@"Sent %d of %d bytes", totalBytesWritten, totalBytesExpectedToWrite);
        [delegate bytesWritten:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }];
    
    [createItem setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [delegate didSucceedWithItem:[operation.responseString mutableObjectFromJSONString]];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnItemWithError:error];
    }];
    
return createItem;
}

+(AFHTTPRequestOperation*)newGetItemsGivenUserId:(NSInteger)userId delegate:(NSObject<TBItemsOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableURLRequest *getItemsRequest =
    [client requestWithMethod:@"GET" path:[NSString stringWithFormat:USER_ITEMS, userId] parameters:nil];
    
    [getItemsRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [getItemsRequest setTimeoutInterval:TIMEOUT];
    
    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:getItemsRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
   {
       [delegate didSucceedWithItems:[operation.responseString mutableObjectFromJSONString]];
   }
  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [delegate didFailOnItemsWithError:error];
  }];
    
    return request;
}

+(AFHTTPRequestOperation*)newGetItems:(NSString*)locality delegate:(NSObject<TBItemsOperationDelegate>*)delegate;
{
    TB_RETURN_IF_NIL(locality)
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableURLRequest *getItemsRequest =
    [client requestWithMethod:@"GET" path:ITEMS parameters:@{@"locality[name]": locality}];
    
    [getItemsRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [getItemsRequest setTimeoutInterval:TIMEOUT];
    
    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:getItemsRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [delegate didSucceedWithItems:[operation.responseString mutableObjectFromJSONString]];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnItemsWithError:error];
    }];
    
return request;
}


@end
