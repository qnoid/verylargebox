//
//  Copyright (c) 2010 (verylargebox.com). All rights reserved.
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 20/03/2011.
//
//

#import "VLBQueries.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "VLBItemsOperationDelegate.h"
#import "JSONKit.h"
#import "VLBLocationOperationDelegate.h"
#import "NSMutableDictionary+VLBMutableDictionary.h"
#import "VLBUpdateItemOperationDelegate.h"
#import "VLBCreateUserOperationDelegate.h"
#import "VLBVerifyUserOperationDelegate.h"
#import "VLBSecureHashA1.h"
#import "VLBAFHTTPRequestOperationCompletionBlocks.h"
#import "VLBNSErrorDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "VLBLocalityOperationDelegate.h"
#import "VLBCreateItemOperationDelegate.h"
#import "VLBMacros.h"
#import "AmazonS3Client.h"
#import "S3PutObjectRequest.h"
#import "S3UploadInputStream.h"
#import "VLBMacros.h"
#import "NSDictionary+VLBStore.h"

static NSString* const LOCALITIES = @"/localities";
static NSString* const LOCATIONS = @"/locations";
static NSString* const LOCATION_ITEMS = @"/locations/%d/items";
static NSString* const USER_ITEMS = @"/users/%u/items";
static NSString* const ITEMS = @"/items";

VLBS3PutObjectRequestConfiguration VLBS3PutObjectRequestConfigurationImageJpegPublicRead = ^(S3PutObjectRequest *por){
    por.contentType = @"image/jpeg";
    por.cannedACL   = [S3CannedACL publicRead];
};

@implementation VLBQueriesFailureBlocks

+(VLBAFHTTPRequestOperationFailureBlock)nsErrorDelegate:(NSObject<VLBNSErrorDelegate>*)delegate failureBlock:(VLBAFHTTPRequestOperationFailureBlock)failureBlock
{
return ^(AFHTTPRequestOperation *operation, NSError *error)
    {
        DDLogWarn(@"%s %@", __PRETTY_FUNCTION__, error);
        if(VLB_ERROR_BLOCK_CANNOT_CONNECT_TO_HOST(error)){
            [delegate didFailWithCannonConnectToHost:error];
        return;
        }
        
        if(VLB_ERROR_BLOCK_NOT_CONNECTED_TO_INTERNET(error)){
            [delegate didFailWithNotConnectToInternet:error];
        return;
        }

        if(VLB_ERROR_TIMEOUT(error)){
            [delegate didFailWithTimeout:error];
            return;
        }

        failureBlock(operation, error);
    };
}
@end

@interface VLBQueries ()

/**
 Migrate to 4sq queries class along with #newParameters if it starts to creep
 */
+(AFHTTPRequestOperation*)newLocationQuery:(NSDictionary*)parameters delegate:(NSObject<VLBLocationOperationDelegate>*)delegate;
@end

@implementation VLBQueries

NSString* const THE_BOX_SERVICE = @"com.verylargebox";

NSString* const THE_BOX_BASE_URL_STRING = @"https://www.verylargebox.com";

NSString* const AWS_ACCESS_KEY = @"AKIAIFACVDF6VNIEY2EQ";
NSString* const AWS_SECRET_KEY = @"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";

NSString* const FOURSQUARE_BASE_URL_STRING = @"https://api.foursquare.com/v2/";
NSString* const FOURSQUARE_CLIENT_ID = @"ITAJQL0VFSH1W0BLVJ1BFUHIYHIURCHZPFBKCRIKEYYTAFUW";
NSString* const FOURSQUARE_CLIENT_SECRET = @"PVWUAMR2SUPKGSCUX5DO1ZEBVCKN4UO5J4WEZVA3WV01NWTK";
NSUInteger const TIMEOUT = 60;

+(void)initialize
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

-(VLBQueryBlock)newS3PutObjectRequest:(VLBS3PutObjectRequestConfiguration)config
{
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:AWS_ACCESS_KEY
                                                     withSecretKey:AWS_SECRET_KEY];
return ^(NSDictionary* parameters) {
    
        [s3 setEndpoint:[parameters objectForKey:@"endpoint"]];
        S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:[parameters objectForKey:@"key"]
                                                                 inBucket:[parameters objectForKey:@"bucket"]];
    
        config(por);
    
        [s3 putObject:por];
    };
}

+(AFHTTPRequestOperation*)newCreateUserQuery:(NSObject<VLBCreateUserOperationDelegate>*)delegate email:(NSString*)email residence:(NSString*)residence
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters vlb_setObjectIfNotNil:email forKey:@"email"];
    [parameters vlb_setObjectIfNotNil:residence forKey:@"residence"];

    NSMutableURLRequest *registrationRequest = [client requestWithMethod:@"POST" path:@"/users" parameters:parameters];
    [registrationRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [registrationRequest setTimeoutInterval:TIMEOUT];

    VLBAFHTTPRequestOperationFailureBlock didFailOnRegistrationWithError =
        [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [delegate didFailOnRegistrationWithError:error];
        }];

    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:registrationRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [delegate didSucceedWithRegistrationForEmail:email residence:residence];
    } 
    failure:didFailOnRegistrationWithError];
    
return request;
}

+(AFHTTPRequestOperation*)newVerifyUserQuery:(NSObject<VLBVerifyUserOperationDelegate>*)delegate email:(NSString*)email residence:(NSString*)residence;
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters vlb_setObjectIfNotNil:residence forKey:@"residence"];
    [parameters vlb_setObjectIfNotNil:email forKey:@"email"];
    
    NSMutableURLRequest *registrationRequest = [client requestWithMethod:@"GET" path:@"/users" parameters:parameters];
    [registrationRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [registrationRequest setTimeoutInterval:TIMEOUT];
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnRegistrationWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnVerifyWithError:error];
    }];

    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:registrationRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
   {
       [delegate didSucceedWithVerificationForEmail:email residence:[[operation.responseString objectFromJSONString] objectForKey:@"residence"]];
   }
   failure:didFailOnRegistrationWithError];
    
return request;
}

+(AFHTTPRequestOperation*)newGetLocationsGivenLocalityName:(NSString*)localityName delegate:(NSObject<VLBLocationOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSDictionary* parameters = @{@"locality[name]":localityName};
    
    NSMutableURLRequest *categoriesRequest = [client requestWithMethod:@"GET"
                                                                  path:@"/locations"
                                                            parameters:parameters];
    
    [categoriesRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [categoriesRequest setTimeoutInterval:TIMEOUT];
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnLocationWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnLocationWithError:error];
    }];

    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:categoriesRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSString* responseString = operation.responseString;        
        [delegate didSucceedWithLocations:[responseString mutableObjectFromJSONString] givenParameters:parameters];
    } 
    failure:didFailOnLocationWithError];
    
    return request;
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

+(AFHTTPRequestOperation*)newLocationQuery:(NSDictionary*)parameters delegate:(NSObject<VLBLocationOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:FOURSQUARE_BASE_URL_STRING]];
    
    NSMutableURLRequest *categoriesRequest = [client requestWithMethod:@"GET" path:@"venues/search" parameters:parameters];
    [categoriesRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [categoriesRequest addValue:@"public, max-age=3600" forHTTPHeaderField:@"Cache-Control"];
    categoriesRequest.timeoutInterval = TIMEOUT;
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnLocationWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnLocationWithError:error];
    }];

    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:categoriesRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSString* responseString = operation.responseString;

        NSMutableArray* locations = [[[responseString mutableObjectFromJSONString] objectForKey:@"response"] objectForKey:@"venues"];
          
        NSArray *sortedLocations =
            [locations sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                if ([[[obj1 vlb_location] objectForKey:@"distance"] intValue] > [[[obj2 vlb_location] objectForKey:@"distance"] intValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
            
                if ([[[obj1 vlb_location] objectForKey:@"distance"] intValue] < [[[obj2 vlb_location] objectForKey:@"distance"] intValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
            
            return (NSComparisonResult)NSOrderedSame;
            }];
                               
        [delegate didSucceedWithLocations:sortedLocations givenParameters:parameters];
    } 
    failure:didFailOnLocationWithError];
    
return request;    
}

+(AFHTTPRequestOperation*)newLocationQuery:(CLLocationDegrees)latitude longtitude:(CLLocationDegrees)longtitude delegate:(NSObject<VLBLocationOperationDelegate>*)delegate
{
    NSMutableDictionary *parameters = [self newParameters];

    [parameters setObject:[NSString stringWithFormat:@"%f,%f", latitude, longtitude] forKey:@"ll"];
    
return [self newLocationQuery:parameters delegate:delegate];    
}

+(AFHTTPRequestOperation*)newLocationQuery:(CLLocationDegrees)latitude longtitude:(CLLocationDegrees)longtitude query:(NSString*) query delegate:(NSObject<VLBLocationOperationDelegate>*)delegate
{
    NSMutableDictionary *parameters = [self newParameters];
    
    [parameters setObject:query forKey:@"query"];
    [parameters setObject:[NSString stringWithFormat:@"%f,%f", latitude, longtitude] forKey:@"ll"];
    
return [self newLocationQuery:parameters delegate:delegate];    
}

+(AFHTTPRequestOperation*)newGetLocalities:(NSObject<VLBLocalityOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableURLRequest *categoriesRequest =
    [client requestWithMethod:@"GET" path:LOCALITIES parameters:nil];
    [categoriesRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [categoriesRequest setTimeoutInterval:TIMEOUT];
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnLocalitiesWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnLocalitiesWithError:error];
    }];

    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:categoriesRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       NSString* responseString = operation.responseString;
       [delegate didSucceedWithLocalities:[responseString mutableObjectFromJSONString]];
    }
    failure:didFailOnLocalitiesWithError];
    
    return request;
}

+(AFHTTPRequestOperation*)newGetLocations:(NSObject<VLBLocationOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableURLRequest *categoriesRequest =
    [client requestWithMethod:@"GET" path:LOCATIONS parameters:nil];
    
    [categoriesRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [categoriesRequest setTimeoutInterval:TIMEOUT];
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnLocationWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnLocationWithError:error];
    }];

    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:categoriesRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
   {
       NSString* responseString = operation.responseString;
       [delegate didSucceedWithLocations:[responseString mutableObjectFromJSONString] givenParameters:nil];
   }
   failure:didFailOnLocationWithError];

return request;
}

+(AFHTTPRequestOperation*)newGetItemsGivenLocationId:(NSUInteger)locationId delegate:(NSObject<VLBItemsOperationDelegate>*)delegate {
return [self newGetItemsGivenLocationId:locationId page:nil delegate:delegate];
}

+(AFHTTPRequestOperation*)newGetItemsGivenLocationId:(NSUInteger)locationId page:(NSNumber*)page delegate:(NSObject<VLBItemsOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters vlb_setObjectIfNotNil:page forKey:@"page"];

    NSMutableURLRequest *categoriesRequest =
    [client requestWithMethod:@"GET" path:[NSString stringWithFormat:LOCATION_ITEMS, locationId] parameters:parameters];
    
    [categoriesRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [categoriesRequest setTimeoutInterval:TIMEOUT];
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnItemsWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnItemsWithError:error];
    }];

    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:categoriesRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
   {
       NSString* responseString = operation.responseString;
       [delegate didSucceedWithItems:[responseString mutableObjectFromJSONString]];
   }
    failure:didFailOnItemsWithError];
    
    return request;
}

+(AFHTTPRequestOperation*)newPostItemQuery:(NSString*)imageURL
                                  location:(NSDictionary *)location
                                  locality:(NSString*)locality
                                      user:(NSUInteger)userId
                                  delegate:(NSObject<VLBCreateItemOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];

    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:imageURL forKey:@"item_url"];
    [parameters vlb_setObjectIfNotNil:[location objectForKey:@"name"] forKey:@"item[location_attributes][name]"];
    [parameters vlb_setObjectIfNotNil:[[location objectForKey:@"location"] objectForKey:@"lat"] forKey:@"item[location_attributes][lat]"];
    [parameters vlb_setObjectIfNotNil:[[location objectForKey:@"location"] objectForKey:@"lng"] forKey:@"item[location_attributes][lng]"];
    [parameters vlb_setObjectIfNotNil:[location objectForKey:@"id"] forKey:@"item[location_attributes][foursquareid]"];
    [parameters vlb_setObjectIfNotNil:locality forKey:@"item[location_attributes][locality_attributes][name]"];

    NSMutableURLRequest *createItemRequest = [client requestWithMethod:@"POST" path:[NSString stringWithFormat:USER_ITEMS, userId] parameters:parameters];
    [createItemRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [createItemRequest setTimeoutInterval:TIMEOUT];

    VLBAFHTTPRequestOperationFailureBlock didFailOnItemWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnItemWithError:error];
    }];

    AFHTTPRequestOperation *createItem = [[AFHTTPRequestOperation alloc] initWithRequest:createItemRequest];
    [createItem setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
            [delegate didSucceedWithItem:[operation.responseString mutableObjectFromJSONString]];
    }
    failure:didFailOnItemWithError];
    
return createItem;
}

+(AFHTTPRequestOperation*)newGetItemsGivenUserId:(NSUInteger)userId delegate:(NSObject<VLBItemsOperationDelegate>*)delegate {
    return [self newGetItemsGivenUserId:userId page:nil delegate:delegate];
}

+(AFHTTPRequestOperation*)newGetItemsGivenUserId:(NSUInteger)userId page:(NSNumber*)page delegate:(NSObject<VLBItemsOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters vlb_setObjectIfNotNil:page forKey:@"page"];

    NSMutableURLRequest *getItemsRequest =
    [client requestWithMethod:@"GET" path:[NSString stringWithFormat:USER_ITEMS, userId] parameters:parameters];    
    [getItemsRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [getItemsRequest setTimeoutInterval:TIMEOUT];
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnItemsWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnItemsWithError:error];
    }];

    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:getItemsRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
   {
       [delegate didSucceedWithItems:[operation.responseString mutableObjectFromJSONString]];
   }
  failure:didFailOnItemsWithError];
    
return request;
}


+(AFHTTPRequestOperation*)newGetItems:(NSString*)locality delegate:(NSObject<VLBItemsOperationDelegate>*)delegate{
    return [self newGetItems:locality page:nil delegate:delegate];
}

+(AFHTTPRequestOperation*)newGetItems:(NSString*)locality page:(NSNumber*)page delegate:(NSObject<VLBItemsOperationDelegate>*)delegate;
{
    VLB_RETURN_IF_NIL(locality)
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:locality forKey:@"locality[name]"];
    [parameters vlb_setObjectIfNotNil:page forKey:@"page"];
    
    NSMutableURLRequest *getItemsRequest =
    [client requestWithMethod:@"GET" path:ITEMS parameters:parameters];
    [getItemsRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [getItemsRequest setTimeoutInterval:TIMEOUT];
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnItemsWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnItemsWithError:error];
    }];
    
    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:getItemsRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
   {
       [delegate didSucceedWithItems:[operation.responseString mutableObjectFromJSONString]];
   }
  failure:didFailOnItemsWithError];
    
return request;
}



@end
