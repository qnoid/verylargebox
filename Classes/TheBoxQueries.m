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
#import "TBCategoriesOperationDelegate.h"
#import "JSONKit.h"

@implementation TheBoxQueries

NSString* const THE_BOX_BASE_URL_STRING = @"http://www.verylargebox.com";

+(AFHTTPRequestOperation*)newItemsQuery:(NSObject<TBCategoriesOperationDelegate>*)delegate
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
    NSMutableURLRequest *categoriesRequest = [client requestWithMethod:@"GET" path:@"/categories" parameters:nil];
    [categoriesRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [categoriesRequest setTimeoutInterval:30];
    
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

+(AFHTTPRequestOperation*)newItemQuery:(UIImage *) image itemName:(NSString *)itemName locationName:(NSString *)locationName categoryName:(NSString *)categoryName tags:(NSArray *)tags
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:THE_BOX_BASE_URL_STRING]];
    
	NSData *imageData = UIImageJPEGRepresentation(image, 1.0);

    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                categoryName, @"item[category_attributes][name]",
                                itemName, @"item[name]",
                                locationName, @"item[location_attributes][name]",
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
    [request setTimeoutInterval:30];

	AFHTTPRequestOperation *createItem = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [createItem setUploadProgressBlock:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
        NSLog(@"Sent %d of %d bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
return createItem;
}

@end
