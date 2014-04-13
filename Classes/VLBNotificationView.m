//
// 	VLBPostItemOperationDelegate.m
//  verylargebox
//
//  Created by Markos Charatzas on 06/07/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import "VLBNotificationView.h"
#import "VLBProgressView.h"
#import "VLBMacros.h"
#import "AmazonServiceResponse.h"

@implementation VLBNotificationView

+(VLBNotificationView *)newView
{
    VLBNotificationView *view = [[VLBNotificationView alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
    view.backgroundColor = [UIColor blackColor];
    
return view;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    VLB_IF_NOT_SELF_RETURN_NIL();
    VLB_LOAD_VIEW();
    
return self;
}

#pragma mark AmazonServiceRequestDelegate
-(void)request:(AmazonServiceRequest *)request didSendData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite
{
	[self bytesWritten:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
}

-(void)bytesWritten:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite
{
    [self.progressView setProgress:(float)totalBytesWritten / (float)totalBytesExpectedToWrite animated:YES];
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
	NSException *exception = response.exception;

	if(exception){
		DDLogError(@"%s, %@", __PRETTY_FUNCTION__, exception);
		[self request:request didFailWithError:response.error];
	return;
	}

  [self.delegate didCompleteUploading:self at:[[request url] absoluteString]];
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error{
	[self didFailOnItemWithError:error];
}

-(void)didCancel{
    [self removeFromSuperview];
}

-(void)didStartUploadingItem:(UIImage*)itemImage key:(NSString*)key location:(NSDictionary*) location locality:(NSString*) locality
{
    self.progressView.imageView.image = itemImage;
    
    [self animateWithDuration:0.5 animation:^(UIView *view) {
        view.frame = CGRectMake(0, 64, 320, 44);
    }];
    
    [self.delegate didStartUploadingItem:itemImage key:key location:location locality:locality];
}

-(void)didSucceedWithItem:(NSDictionary*)item
{
    [self.delegate didSucceedWithItem:item];
    
    [self rewind:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)didFailOnItemWithError:(NSError*)error
{
    [self.delegate didFailOnItemWithError:error];
    
    DDLogError(@"%s, %@", __PRETTY_FUNCTION__, error);
    [self rewind:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark TBNSErrorDelegate
-(void)didFailWithCannonConnectToHost:(NSError *)error
{
    [self.delegate didFailWithNotConnectToInternet:error];
}

-(void)didFailWithNotConnectToInternet:(NSError *)error
{
    [self.delegate didFailWithNotConnectToInternet:error];
}

-(void)didFailWithTimeout:(NSError *)error
{
    [self.delegate didFailWithTimeout:error];
}


@end
