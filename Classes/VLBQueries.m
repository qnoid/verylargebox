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
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "VLBItemsOperationDelegate.h"
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
#import "S3TransferManager.h"
#import "NSDictionary+VLBDictionary.h"
#import "DDLog.h"
#import "VLBReportOperationDelegate.h"
#import "NSString+VLBJson.h"
#import "MMMarkdown.h"

static NSString* const LOCALITIES = @"/localities";
static NSString* const LOCATIONS = @"/locations";
static NSString* const LOCATION_ITEMS = @"/locations/%@/items";
static NSString* const USER_ITEMS = @"/users/%@/items";
static NSString* const ITEMS = @"/items";
static NSString* const REPORT_ITEM = @"/items/%@/report";

@interface NSObject (VLBObject)
-(bool) vlb_isNil;
@end

@implementation NSObject (VLBObject)
-(bool) vlb_isNil{
    return nil == self || [NSNull null] == self;
}
@end

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
        
        if(VLB_ERROR_CANCELLED(error)){
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

NSString* const THE_BOX_BASE_URL_STRING = @"https://www.verylargebox.com";
NSString* const THE_BOX_STATIC_BASE_URL_STRING = @"http://static.verylargebox.com";

NSUInteger const TIMEOUT = 30;

static VLBAFHTTPRequestOperationSucessBlock VLBSucessBlockResponseObjectMarkdown(VLBMarkdownSucessBlock success)
{
return ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
        
        NSAttributedString *preview = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding] options:options documentAttributes:nil error:NULL];
        
        success(preview);
    };
}

+(void)initialize
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

-(S3PutObjectRequest*)newS3PutObjectRequest:(NSDictionary*) parameters config:(VLBS3PutObjectRequestConfiguration)config
{
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:[parameters objectForKey:@"key"]
                                                             inBucket:[parameters objectForKey:@"bucket"]];
    
    config(por);
    
    return por;
}

+(AFHTTPRequestOperation*)queryMarkdown:(NSString*)URLString success:(VLBMarkdownSucessBlock)success failure:(VLBAFHTTPRequestOperationFailureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:THE_BOX_STATIC_BASE_URL_STRING]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFHTTPRequestOperation* request = [manager GET:URLString parameters:nil success:VLBSucessBlockResponseObjectMarkdown(success) failure:failure];
    
    return request;
}

+(AFHTTPRequestOperation*)newCreateUserQuery:(NSObject<VLBCreateUserOperationDelegate>*)delegate email:(NSString*)email residence:(NSString*)residence
{
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters vlb_setObjectIfNotNil:email forKey:@"email"];
    [parameters vlb_setObjectIfNotNil:residence forKey:@"residence"];
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnRegistrationWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnRegistrationWithError:error];
    }];
    
    AFHTTPRequestOperation* request = [client POST:@"/users" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
                   {
                       [delegate didSucceedWithRegistrationForEmail:email residence:residence];
                   }
                                                  failure:didFailOnRegistrationWithError];
    
    return request;
}

+(AFHTTPRequestOperation*)newVerifyUserQuery:(NSObject<VLBVerifyUserOperationDelegate>*)delegate email:(NSString*)email residence:(NSString*)residence;
{
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters vlb_setObjectIfNotNil:residence forKey:@"residence"];
    [parameters vlb_setObjectIfNotNil:email forKey:@"email"];
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnRegistrationWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnVerifyWithError:error];
    }];
    
    AFHTTPRequestOperation* request = [client GET:@"/users" parameters:parameters
                                          success:^(AFHTTPRequestOperation *operation, id responseObject)
                                       {
                                           [delegate didSucceedWithVerificationForEmail:email residence:[[operation.responseString vlb_jsonObject] objectForKey:@"residence"]];
                                       }
                                       failure:didFailOnRegistrationWithError];
    
return request;
}

+(AFHTTPRequestOperation*)newGetLocationsGivenLocalityName:(NSString*)localityName delegate:(NSObject<VLBLocationOperationDelegate>*)delegate
{
    if(!localityName){
        return nil;
    }
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSDictionary* parameters = @{@"locality[name]":localityName};
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnLocationWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnLocationWithError:error];
    }];
    
    AFHTTPRequestOperation* request = [client GET:@"/locations" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
                                       {
                                           NSString* responseString = operation.responseString;
                                           [delegate didSucceedWithLocations:[responseString vlb_jsonObject] givenParameters:parameters];
                                       }
                                                                      failure:didFailOnLocationWithError];
    
    return request;
}

+(NSMutableDictionary*)newParameters {
    return [NSMutableDictionary dictionary];
}

+(AFHTTPRequestOperation*)newLocationQuery:(NSDictionary*)parameters delegate:(NSObject<VLBLocationOperationDelegate>*)delegate
{
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnLocationWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnLocationWithError:error];
    }];
    
    AFHTTPRequestOperation* request = [client GET:@"venues/search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
                                       {
                                           NSString* responseString = operation.responseString;
                                           
                                           NSMutableArray* locations = [[[responseString vlb_jsonObject] objectForKey:@"response"] objectForKey:@"venues"];
                                           
                                           [delegate didSucceedWithLocations:locations givenParameters:parameters];
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
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];

    VLBAFHTTPRequestOperationFailureBlock didFailOnLocalitiesWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnLocalitiesWithError:error];
    }];
    
    AFHTTPRequestOperation* request = [client GET:LOCALITIES parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
                                       {
                                           NSString* responseString = operation.responseString;
                                           [delegate didSucceedWithLocalities:[responseString vlb_jsonObject]];
                                       }
                                                                      failure:didFailOnLocalitiesWithError];
    
    return request;
}

+(AFHTTPRequestOperation*)newGetLocations:(NSObject<VLBLocationOperationDelegate>*)delegate
{
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnLocationWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnLocationWithError:error];
    }];
    
    AFHTTPRequestOperation* request = [client GET:LOCATIONS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
                                       {
                                           NSString* responseString = operation.responseString;
                                           [delegate didSucceedWithLocations:[responseString vlb_jsonObject] givenParameters:nil];
                                       }
                                                                      failure:didFailOnLocationWithError];
    
    return request;
}

+(AFHTTPRequestOperation*)newGetItemsGivenLocationId:(NSUInteger)locationId delegate:(NSObject<VLBItemsOperationDelegate>*)delegate {
    return [self newGetItemsGivenLocationId:locationId page:nil delegate:delegate];
}

+(AFHTTPRequestOperation*)newGetItemsGivenLocationId:(NSUInteger)locationId page:(NSNumber*)page delegate:(NSObject<VLBItemsOperationDelegate>*)delegate
{
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters vlb_setObjectIfNotNil:page forKey:@"page"];
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnItemsWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnItemsWithError:error];
    }];
    
    AFHTTPRequestOperation* request = [client GET:[NSString stringWithFormat:LOCATION_ITEMS, @(locationId)] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
                                       {
                                           NSString* responseString = operation.responseString;
                                           [delegate didSucceedWithItems:[responseString vlb_jsonObject]];
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
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:imageURL forKey:@"item_url"];
    [parameters vlb_setStringIfNotNilOrEmpty:[location objectForKey:@"name"] forKey:@"item[location_attributes][name]"];
    [parameters vlb_setObjectIfNotNil:[[location objectForKey:@"location"] objectForKey:@"lat"] forKey:@"item[location_attributes][lat]"];
    [parameters vlb_setObjectIfNotNil:[[location objectForKey:@"location"] objectForKey:@"lng"] forKey:@"item[location_attributes][lng]"];
    [parameters vlb_setObjectIfNotNil:[location objectForKey:@"id"] forKey:@"item[location_attributes][foursquareid]"];
    [parameters vlb_setObjectIfNotNil:locality forKey:@"item[location_attributes][locality_attributes][name]"];
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnItemWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnItemWithError:error];
    }];
    
    AFHTTPRequestOperation *createItem = [client POST:[NSString stringWithFormat:USER_ITEMS, @(userId)] parameters:parameters
                                              success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [delegate didSucceedWithItem:[operation.responseString vlb_jsonObject]];
     }
                                      failure:didFailOnItemWithError];
    
    return createItem;
}

+(AFHTTPRequestOperation*)newGetItemsGivenUserId:(NSUInteger)userId delegate:(NSObject<VLBItemsOperationDelegate>*)delegate {
    return [self newGetItemsGivenUserId:userId page:nil delegate:delegate];
}

+(AFHTTPRequestOperation*)newGetItemsGivenUserId:(NSUInteger)userId page:(NSNumber*)page delegate:(NSObject<VLBItemsOperationDelegate>*)delegate
{
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters vlb_setObjectIfNotNil:page forKey:@"page"];
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnItemsWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnItemsWithError:error];
    }];
    
    AFHTTPRequestOperation* request = [client GET:[NSString stringWithFormat:USER_ITEMS, @(userId)] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
                                       {
                                           [delegate didSucceedWithItems:[operation.responseString vlb_jsonObject]];
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
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters setObject:locality forKey:@"locality[name]"];
    [parameters vlb_setObjectIfNotNil:page forKey:@"page"];
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnItemsWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnItemsWithError:error];
    }];
    
    AFHTTPRequestOperation* request = [client GET:ITEMS parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
                                       {
                                           [delegate didSucceedWithItems:[operation.responseString vlb_jsonObject]];
                                       }
                                                                      failure:didFailOnItemsWithError];
    
    return request;
}

+(AFHTTPRequestOperation*)newReportItem:(NSUInteger)itemId reportStatus:(NSString*)reportStatus delegate:(NSObject<VLBReportOperationDelegate>*)delegate;
{
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    VLBAFHTTPRequestOperationFailureBlock didFailOnReportWithError =
    [VLBQueriesFailureBlocks nsErrorDelegate:delegate failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnReportWithError:error];
    }];
    
    AFHTTPRequestOperation* request = [client POST:[NSString stringWithFormat:REPORT_ITEM, @(itemId)] parameters:@{@"report_status":reportStatus} success:^(AFHTTPRequestOperation *operation, id responseObject)
                                       {
                                           [delegate didSucceedOnReport];
                                       }
                                                                      failure:didFailOnReportWithError];
    
    return request;
}

+(AFHTTPRequestOperation*)queryTermsOfService:(VLBMarkdownSucessBlock)success failure:(VLBAFHTTPRequestOperationFailureBlock)failure {
return [self queryMarkdown:@"/terms.html" success:success failure:failure];
}

+(AFHTTPRequestOperation*)queryPrivacyPolicy:(VLBMarkdownSucessBlock)success failure:(VLBAFHTTPRequestOperationFailureBlock)failure {
return [self queryMarkdown:@"/privacy.html" success:success failure:failure];
}

@end
