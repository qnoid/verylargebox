/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas on 20/11/10.

 */
#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@interface TheBoxUICellFactory : NSEnumerator
{
	@private
		NSEnumerator *itemProviders;	
		NSInteger currentCellIndex;
}
@property(nonatomic, retain) NSEnumerator *itemProviders;
@property(nonatomic, assign) NSInteger currentCellIndex;

+(TheBoxUICellFactory *) newInstance:(NSEnumerator *)itemProviders;

-(UITableViewCell *)nextCell:(UIImage *)image frame:(CGRect) frame;

@end
