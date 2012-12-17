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
#import "TBCategoriesOperationDelegate.h"
#import "NSMutableDictionary+TBMutableDictionary.h"
#import "TBUpdateItemOperationDelegate.h"
#import "TBCreateUserOperationDelegate.h"
#import "TBVerifyUserOperationDelegate.h"
#import "TBSecureHashA1.h"
#import "TBAFHTTPRequestOperationCompletionBlocks.h"
#import "TBNSErrorDelegate.h"

@interface TheBoxQueries ()

/**
 Migrate to 4sq queries class along with #newParameters if it starts to creep
 */
+(AFHTTPRequestOperation*)newLocationQuery:(NSDictionary*)parameters delegate:(NSObject<TBLocationOperationDelegate>*)delegate;
@end

@implementation TheBoxQueries

NSString* const THE_BOX_SERVICE = @"com.verylargebox";

NSString* const THE_BOX_BASE_URL_STRING = @"http://www.verylargebox.com";

NSString* const FOURSQUARE_BASE_URL_STRING = @"https://api.foursquare.com/v2/";
NSString* const FOURSQUARE_CLIENT_ID = @"ITAJQL0VFSH1W0BLVJ1BFUHIYHIURCHZPFBKCRIKEYYTAFUW";
NSString* const FOURSQUARE_CLIENT_SECRET = @"PVWUAMR2SUPKGSCUX5DO1ZEBVCKN4UO5J4WEZVA3WV01NWTK";
NSUInteger const TIMEOUT = 60;


+(AFHTTPRequestOperation*)newCreateUserQuery:(NSObject<TBCreateUserOperationDelegate>*)delegate email:(NSString*)email residence:(NSString*)residence
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters tbSetObjectIfNotNil:email forKey:@"email"];
    [parameters tbSetObjectIfNotNil:residence forKey:@"residence"];

    NSMutableURLRequest *registrationRequest = [client requestWithMethod:@"POST" path:@"/users" parameters:parameters];
    [registrationRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [registrationRequest setTimeoutInterval:TIMEOUT];

    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:registrationRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [delegate didSucceedWithRegistrationForEmail:email residence:residence];
    } 
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        TBAFHTTPRequestOperationFailureBlockOnErrorCode *cannotConnectToHost =
            [TBAFHTTPRequestOperationFailureBlockOnErrorCode cannotConnectToHost:^(AFHTTPRequestOperation *operation){
                [delegate didFailWithCannonConnectToHost:error];
            }];
        
        if([cannotConnectToHost failure:operation error:error]){
            return;
        }

        [delegate didFailOnRegistrationWithError:error];
    }];
    
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
    
    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:registrationRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
   {
       [delegate didSucceedWithVerificationForEmail:email residence:residence];
   }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [delegate didFailOnVerifyWithError:error];
   }];
    
return request;
}

+(AFHTTPRequestOperation*)newCategoriesQuery:(NSObject<TBCategoriesOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableURLRequest *categoriesRequest = [client requestWithMethod:@"GET" path:@"/categories" parameters:nil];
    [categoriesRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [categoriesRequest setTimeoutInterval:TIMEOUT];
    
    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:categoriesRequest success:^(AFHTTPRequestOperation *operation, id responseObject) 
   {
      NSString* responseString = operation.responseString;

       
      [delegate didSucceedWithCategories:[responseString mutableObjectFromJSONString]];
   } 
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [delegate didFailOnCategoriesWithError:error];
  }];

    return request;
}

+(AFHTTPRequestOperation*)newItemsQuery:(NSObject<TBItemsOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableURLRequest *categoriesRequest = [client requestWithMethod:@"GET" path:@"/items" parameters:nil];
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

+(AFHTTPRequestOperation*)newItemQuery:(UIImage *) image location:(NSDictionary *)location;
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
	NSData *imageData = UIImageJPEGRepresentation(image, 1.0);

    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters tbSetObjectIfNotNil:[location objectForKey:@"name"] forKey:@"item[location_attributes][name]"];
    [parameters tbSetObjectIfNotNil:[[location objectForKey:@"location"] objectForKey:@"lat"] forKey:@"item[location_attributes][lat]"];
    [parameters tbSetObjectIfNotNil:[[location objectForKey:@"location"] objectForKey:@"lng"] forKey:@"item[location_attributes][lng]"];
    [parameters tbSetObjectIfNotNil:[location objectForKey:@"id"] forKey:@"item[location_attributes][foursquareid]"];

    NSMutableURLRequest* request = [client multipartFormRequestWithMethod:@"POST" path:@"/items" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) 
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
    }];
    
return createItem;
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

@end
