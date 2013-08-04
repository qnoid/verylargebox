//
//  VLBTheBox.h
//  verylargebox
//
//  Created by Markos Charatzas on 16/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@protocol VLBCreateItemOperationDelegate;
@protocol VLBVerifyUserOperationDelegate;
@class VLBIdentifyViewController;
@class VLBEmailViewController;
@class VLBProfileViewController;
@class VLBProfileEmptyViewController;
@class VLBTakePhotoViewController;
@class VLBCityViewController;
@class VLBFeedViewController;
@class VLBUserProfileViewController;

extern NSString* const THE_BOX_SERVICE;

@interface VLBTheBox : NSObject

+(instancetype)newTheBox;

-(void)didSucceedWithRegistrationForEmail:(NSString *)email residence:(NSString *)residence;

-(void)didSucceedWithVerificationForEmail:(NSString*)email residence:(NSDictionary*)residence;

-(BOOL)hasUserTakenPhoto;

-(NSString*)email;

-(BOOL)didEnterEmail;

/// the last one to succeed becomes the logged in user
-(NSUInteger)userId;

-(BOOL)hasUserAccount;

-(void)noUserAccount;

-(NSArray*)accounts;

-(void)deleteAccountAtIndex:(NSUInteger)index;

-(NSString*)emailForAccountAtIndex:(NSUInteger)index;

-(NSString*)residenceForEmail:(NSString*)email;

-(void)identify:(NSObject<VLBVerifyUserOperationDelegate>*)delegate;

-(UIViewController*)decideOnProfileViewController;

-(UINavigationController*)newNavigationController:(UIViewController*)rootViewController;
-(VLBIdentifyViewController*)newIdentifyViewController;
-(UINavigationController*)newEmailViewController;
-(VLBProfileViewController*)newProfileViewController;
-(VLBProfileEmptyViewController*)newProfileEmptyViewController;
-(VLBCityViewController*)newCityViewController;
-(VLBFeedViewController*)newFeedViewController;
-(VLBTakePhotoViewController*)newTakePhotoViewController;
-(VLBUserProfileViewController*)newUserProfileViewController;

/**
 
 @return the key under which will store the image
 */
-(NSString*)newPostImage:(UIImage*)image delegate:(NSObject<VLBCreateItemOperationDelegate>*)delegate;

@end
