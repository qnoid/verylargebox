//
// 	VLBBoxAlertViews.h
//  verylargebox
//
//  Created by Markos Charatzas on 27/07/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLBBoxAlertViews : NSObject

+(UIAlertView*)location:(NSString*)name bar:(NSObject<UIAlertViewDelegate>*)alertViewDelegateOnOkGetDirections;

@end
