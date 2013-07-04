//
//  VLBGridView.h
//  verylargebox
//
//  Created by Markos Charatzas on 21/05/2011.
//  Copyright (c) 2011 (verylargebox.com). All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol VLBGridViewDatasource;
@protocol VLBGridViewDelegate;
@class VLBGridView;

typedef void(^VLBGridViewConfig)(VLBGridView *gridView);
typedef void(^VLBGridViewOrientation)(VLBGridView *gridView);

@interface VLBGridView : UIView

@property(nonatomic, unsafe_unretained) IBOutlet id<VLBGridViewDatasource> datasource;
@property(nonatomic, unsafe_unretained) IBOutlet id<VLBGridViewDelegate> delegate;

//@default NO
@property(nonatomic, assign) BOOL showsVerticalScrollIndicator;

+(instancetype)newVerticalGridView:(CGRect)frame config:(VLBGridViewConfig)config;

-(void)reload;
- (void)flashScrollIndicators;

@end
