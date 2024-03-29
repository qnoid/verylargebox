//
//  VLBTheBox.m
//  verylargebox
//
//  Created by Markos Charatzas on 16/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBTheBox.h"
#import "NSDictionary+VLBResidence.h"
#import "VLBMacros.h"
#import "VLBCreateItemOperationDelegate.h"
#import "VLBQueries.h"
#import "S3PutObjectRequest.h"
#import "AmazonEndpoints.h"
#import "S3TransferManager.h"
#import "VLBProfileViewController.h"
#import "VLBTakePhotoViewController.h"
#import "NSDictionary+VLBUser.h"
#import "VLBProfileEmptyViewController.h"
#import "VLBCityViewController.h"
#import "VLBFeedViewController.h"
#import "SSKeychain.h"
#import "NSArray+VLBDecorator.h"
#import "VLBIdentifyViewController.h"
#import "VLBUserProfileViewController.h"
#import "VLBReportViewController.h"

NSString* const THE_BOX_SERVICE = @"com.verylargebox";

NSString* const VERYLARGEBOX_BUCKET = @"com.verylargebox.server";
NSString* const AWS_ACCESS_KEY = @"AKIAIFACVDF6VNIEY2EQ";
NSString* const AWS_SECRET_KEY = @"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";

@interface VLBTheBox ()
@property(nonatomic, strong) NSDictionary *residence;
@property(nonatomic, strong) NSUserDefaults *userDefaults;
@property(nonatomic, strong) VLBQueries *queries;
@property(nonatomic, strong) S3TransferManager *s3transferManager;
@end

@implementation VLBTheBox

+(instancetype) newTheBox
{
    VLBQueries *queries = [[VLBQueries alloc] init];
    
    S3TransferManager *s3transferManager = [S3TransferManager new];
    
return [[VLBTheBox alloc] init:queries transferManager:s3transferManager];
}

-(id)init:(VLBQueries*)queries transferManager:(S3TransferManager*) s3transferManager
{
    VLB_INIT_OR_RETURN_NIL();
    
    self.queries = queries;
    self.s3transferManager = s3transferManager;
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
return self;
}

-(NSString*)prefixKey:(NSString*)key{
    return [NSString stringWithFormat:@"%@.%@", THE_BOX_SERVICE, key];
}

-(void)userDidTakePhoto {
    [self.userDefaults setBool:YES forKey:[self prefixKey:VLBUserDidTakePhotoKey]];
}

-(BOOL)hasUserTakenPhoto {
    return [self.userDefaults boolForKey:[self prefixKey:VLBUserDidTakePhotoKey]];
}

-(NSString*)email{
    return [self.userDefaults stringForKey:[self prefixKey:VLBUserEmail]];
}

-(BOOL)didEnterEmail {
    return [self email] != nil;
}

-(NSUInteger)userId{
    return [self.userDefaults integerForKey:[self prefixKey:VLBResidenceUserId]];
}

-(void)didSucceedWithRegistrationForEmail:(NSString *)email residence:(NSString *)residence
{
    [self.userDefaults setObject:email forKey:[self prefixKey:VLBUserEmail]];
    
    NSError *error = nil;

    [SSKeychain setPassword:residence forService:THE_BOX_SERVICE account:email error:&error];
    
    if (error) {
        DDLogWarn(@"WARNING: %s %@", __PRETTY_FUNCTION__, error);
    }
}

-(void)didSucceedWithVerificationForEmail:(NSString*)email residence:(NSDictionary*)residence
{
   	self.residence = residence;
    [self.userDefaults setInteger:[self.residence vlb_residenceUserId] forKey:[self prefixKey:VLBResidenceUserId]];
    [self.userDefaults setBool:[self.residence vlb_hasUserTakenPhoto] forKey:[self prefixKey:VLBUserDidTakePhotoKey]];
    [self.userDefaults setObject:[self.residence vlb_objectForKey:VLBResidenceToken] forKey:[self prefixKey:VLBResidenceToken]];
    [self.userDefaults synchronize];
}

-(BOOL)hasUserAccount {
    return [self userId] != 0;
}

-(void)noUserAccount
{
    NSError *error = nil;

    [SSKeychain setPassword:nil forService:THE_BOX_SERVICE account:self.email error:&error];
    
    if (error) {
        DDLogWarn(@"Could not remove residence: %s %@", __PRETTY_FUNCTION__, error);
    }

    [self.userDefaults setInteger:0 forKey:[self prefixKey:VLBResidenceUserId]];
    [self.userDefaults synchronize];
}

-(NSArray*)accounts {
return [SSKeychain accountsForService:THE_BOX_SERVICE];
}

-(NSString*)emailForAccountAtIndex:(NSUInteger)index{
return [[[self accounts] objectAtIndex:index] objectForKey:@"acct"];
}

-(NSString*)residenceForEmail:(NSString*)email{
    NSError *error = nil;
return [SSKeychain passwordForService:THE_BOX_SERVICE account:email error:&error];
}

-(void)deleteAccountAtIndex:(NSUInteger)index
{
    [SSKeychain deletePasswordForService:THE_BOX_SERVICE account:[self emailForAccountAtIndex:index]];
    
    if([[self accounts] vlb_isEmpty]){
        [self noUserAccount];
    }
}

-(void)identify:(NSObject<VLBVerifyUserOperationDelegate>*)delegate
{
    if(![self email]){
        [NSException raise:@"Email should not be nil" format:@"#didEnterEmail:forResidence: should have been called", nil];
    }

    NSString* email = [self email];
    
    NSError *error = nil;
    NSString *residence = [SSKeychain passwordForService:THE_BOX_SERVICE account:email error:&error];
    
    [VLBQueries newVerifyUserQuery:delegate email:email residence:residence];    
}

-(UIViewController*)decideOnProfileViewController
{
    BOOL hasUserTakenPhoto = [self hasUserTakenPhoto];

    if(hasUserTakenPhoto){
        return [self newProfileViewController];
    }
    else {
        return [self newProfileEmptyViewController];
    }
}


-(UINavigationController*)newNavigationController:(UIViewController*)rootViewController
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    navigationController.navigationBar.translucent = YES;
    
return navigationController;
}

-(VLBIdentifyViewController*)newIdentifyViewController{
    return [VLBIdentifyViewController newIdentifyViewController:self];
}

-(VLBProfileViewController*)newProfileViewController{
return [VLBProfileViewController newProfileViewController:self email:[self email]];
}

-(VLBProfileEmptyViewController*)newProfileEmptyViewController {
return [VLBProfileEmptyViewController newProfileViewController:self email:[self email]];
}

-(VLBCityViewController*)newCityViewController {
    return [VLBCityViewController newCityViewController];
}

-(VLBFeedViewController*)newFeedViewController {
    return [VLBFeedViewController newFeedViewController];
}

-(VLBTakePhotoViewController*)newTakePhotoViewController {
return [VLBTakePhotoViewController newTakePhotoViewController:self userId:[self userId]];
}

-(VLBUserProfileViewController*)newUserProfileViewController{
return [VLBUserProfileViewController newUserSettingsViewController:self];
}
-(VLBReportViewController*)newReportViewController:(NSDictionary*)item{
    return [VLBReportViewController newReportViewController:item];
}

-(NSString*)newPostImage:(UIImage*)image delegate:(NSObject<VLBCreateItemOperationDelegate>*)delegate
{
    if(![self hasUserAccount]){
        [NSException raise:@"Residence should not be nil" format:@"#didAuthenticateResidence should have been called", nil];
    }	
    
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:AWS_ACCESS_KEY
                                                     withSecretKey:AWS_SECRET_KEY];
    [s3 setEndpoint:AMAZON_S3_EU_WEST_1_ENDPOINT_SECURE];
    
    self.s3transferManager.s3 = s3;    

    NSString* key = [NSString stringWithFormat:@"%@/%f.jpg",
                     [self.userDefaults objectForKey:[self prefixKey:VLBResidenceToken]],
                     CACurrentMediaTime()];
    
    S3PutObjectRequest *putImageInBucket = [self.queries newS3PutObjectRequest:@{@"key":key, @"bucket":VERYLARGEBOX_BUCKET} config:^(S3PutObjectRequest *request) {
        VLBS3PutObjectRequestConfigurationImageJpegPublicRead(request);
        request.data = UIImageJPEGRepresentation(image, 1.0);
        request.delegate = delegate;
    }];
    
    [self.s3transferManager upload:putImageInBucket];
    
return key;
}

@end
