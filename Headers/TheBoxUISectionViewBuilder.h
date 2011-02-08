/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 28/11/10.
 *  Contributor(s): .-
 */
#import <Foundation/Foundation.h>
#import "TheBoxUISectionViewDatasource.h"
@class TheBoxUISectionView;

@interface TheBoxUISectionViewBuilder : NSObject 
{
	@private
		id<TheBoxUISectionViewDatasource> datasource;
}

@property(nonatomic, assign) id<TheBoxUISectionViewDatasource> datasource;

-(id) initWithDatasource:(id <TheBoxUISectionViewDatasource>) datasource;
-(TheBoxUISectionView *) newSection:(NSUInteger) section;
-(NSUInteger)numberOfColumnsInSection:(NSUInteger)section;

@end
