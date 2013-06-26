//
// 	VLBObject.h
//  thebox
//
//  Created by Markos Charatzas on 25/06/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class VLBCameraView;

@protocol VLBCameraViewDelegate <NSObject>
- (void)cameraView:(VLBCameraView *)cameraView didFinishTakingPicture:(UIImage *)image editingInfo:(NSDictionary *)editingInfo;
@end

// Portrait, iPhone only orientation

@interface VLBCameraView : UIView

@property(nonatomic, assign) IBOutlet NSObject<VLBCameraViewDelegate>* delegate;

- (void)takePicture:(id)sender;

@end
