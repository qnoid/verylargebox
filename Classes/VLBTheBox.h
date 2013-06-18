//
//  VLBTheBox.h
//  thebox
//
//  Created by Markos Charatzas on 16/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol VLBCreateItemOperationDelegate;

@interface VLBTheBox : NSObject

+(instancetype) newTheBox:(NSDictionary *) residence;

-(void)newPostImage:(UIImage*)image delegate:(NSObject<VLBCreateItemOperationDelegate>*)delegate;

@end