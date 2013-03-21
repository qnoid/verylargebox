//
//  TBProfileViewController.h
//  thebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheBoxUIScrollView.h"
#import "TBCreateItemOperationDelegate.h"
#import "TBItemsOperationDelegate.h"
#import "TheBoxLocationServiceDelegate.h"

@interface TBProfileViewController : UIViewController <TBCreateItemOperationDelegate, TheBoxUIScrollViewDatasource, TheBoxUIScrollViewDelegate, TBItemsOperationDelegate, TheBoxLocationServiceDelegate>

@property(nonatomic, strong) TheBoxUIScrollView* itemsView;

+(TBProfileViewController*)newProfileViewController:(NSDictionary*)residence email:(NSString*)email;

@end
