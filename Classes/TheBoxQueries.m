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
#import "TheBoxGet.h"
#import "TheBoxPost.h"
#import "ASIFormDataRequest.h"
#import "UITextField+TheBoxUITextField.h"

@implementation TheBoxQueries

+(TheBoxGet*)newItemsQuery
{
	NSURL *itemsEndPoint = [NSURL URLWithString:@"http://0.0.0.0:3000/items"];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:itemsEndPoint];
	[request addRequestHeader:@"Accept" value:@"application/json"];	
	
return [[TheBoxGet alloc] initWithRequest:request];		
}

+(TheBoxPost*)newItemQuery:(UIImage *) image itemName:(NSString *)itemName locationName:(NSString *)locationName categoryName:(NSString *)categoryName tags:(NSArray *)tags
{
	NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
	
	NSURL *url = [NSURL URLWithString:@"http://0.0.0.0:3000/items"];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request addRequestHeader:@"Accept" value:@"application/json"];	
	[request setPostValue:categoryName forKey:@"item[category_attributes][name]"];
	[request setPostValue:itemName forKey:@"item[name]"];
	[request setPostValue:locationName forKey:@"item[location_attributes][name]"];
	
	
	for (UITextField *tag in tags)
	{
		if (![tag isEmpty]){
			[request addPostValue:tag.text forKey:@"item[tags_attributes][][name]"];
		}
		
	}
	
	[request setData:imageData 
		withFileName:
			[NSString stringWithFormat:@"%@.jpg", 
			[itemName stringByReplacingOccurrencesOfString:@" "withString:@"_"]] 
		andContentType:@"image/jpeg" forKey:@"item[image]"];
	
return [[TheBoxPost alloc] initWithRequest:request];
}

@end
