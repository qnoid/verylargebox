/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 20/03/2011.
 *  Contributor(s): .-
 */
#import "TheBoxQueries.h"
#import "ASIFormDataRequest.h"
#import "UITextField+TheBoxUITextField.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "TBItemsOperationDelegate.h"
#import "JSONKit.h"
#import "TBLocationOperationDelegate.h"
#import "TBCategoriesOperationDelegate.h"

@implementation TheBoxQueries

NSString* const THE_BOX_BASE_URL_STRING = @"http://www.verylargebox.com";
NSString* const FOURSQUARE_BASE_URL_STRING = @"https://api.foursquare.com/v2/";
NSString* const FOURSQUARE_CLIENT_ID = @"ITAJQL0VFSH1W0BLVJ1BFUHIYHIURCHZPFBKCRIKEYYTAFUW";
NSString* const FOURSQUARE_CLIENT_SECRET = @"PVWUAMR2SUPKGSCUX5DO1ZEBVCKN4UO5J4WEZVA3WV01NWTK";
NSUInteger const TIMEOUT = 60;

+(AFHTTPRequestOperation*)newCategoriesQuery:(NSObject<TBCategoriesOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableURLRequest *categoriesRequest = [client requestWithMethod:@"GET" path:@"/categories" parameters:nil];
    [categoriesRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [categoriesRequest setTimeoutInterval:TIMEOUT];
    
    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:categoriesRequest success:^(AFHTTPRequestOperation *operation, id responseObject) 
   {
      NSString* responseString = operation.responseString;
      NSLog(@"%@", responseString);
       
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
        NSLog(@"%@", responseString);
        
        [delegate didSucceedWithItems:[responseString mutableObjectFromJSONString]];
    } 
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnItemsWithError:error];
    }];
    
    return request;
}

+(AFHTTPRequestOperation*)newItemQuery:(UIImage *) image itemName:(NSString *)itemName location:(NSDictionary *)location categoryName:(NSString *)categoryName tags:(NSArray *)tags
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
	NSData *imageData = UIImageJPEGRepresentation(image, 1.0);

    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                categoryName, @"item[category_attributes][name]",
                                itemName, @"item[name]",
                                [location objectForKey:@"name"], @"item[location_attributes][name]",
                                [[location objectForKey:@"location"] objectForKey:@"lat"], @"item[location_attributes][latitude]",
                                [[location objectForKey:@"location"] objectForKey:@"lng"], @"item[location_attributes][longitude]",
                                nil];
    
    for (UITextField *tag in tags)
	{
		if (![tag isEmpty]){
			[parameters setObject:tag.text forKey:@"item[tags_attributes][][name]"];
		}
		
	}	

    NSMutableURLRequest* request = [client multipartFormRequestWithMethod:@"POST" path:@"/items" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) 
    {
        [formData appendPartWithFileData:imageData 
                                    name:@"item[image]" 
                                fileName:[NSString stringWithFormat:@"%@.jpg", [itemName stringByReplacingOccurrencesOfString:@" "withString:@"_"]]
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

+(AFHTTPRequestOperation*)newLocationQuery:(CLLocationDegrees)latitude longtitude:(CLLocationDegrees)longtitude delegate:(NSObject<TBLocationOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:FOURSQUARE_BASE_URL_STRING]];
   
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%f,%f", latitude, longtitude], @"ll",
                                FOURSQUARE_CLIENT_ID, @"client_id",
                                FOURSQUARE_CLIENT_SECRET, @"client_secret",
                                @"20120411", @"v",
                                nil];
    
    NSMutableURLRequest *categoriesRequest = [client requestWithMethod:@"GET" path:@"venues/search" parameters:parameters];
    [categoriesRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [categoriesRequest setTimeoutInterval:TIMEOUT];
    
    AFHTTPRequestOperation* request = [client HTTPRequestOperationWithRequest:categoriesRequest success:^(AFHTTPRequestOperation *operation, id responseObject) 
    {
        NSString* responseString = operation.responseString;
        NSLog(@"%@", responseString);
                                           
        [delegate didSucceedWithLocations:[[[responseString objectFromJSONString] objectForKey:@"response"] objectForKey:@"venues"]];
    } 
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [delegate didFailOnLocationWithError:error];
    }];
    
return request;    
}

@end
