/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 8/11/10.
 *  Contributor(s): .-
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TheBoxUICell : UITableViewCell {
    
	@private
		UIImageView *itemImageView;
		UILabel *itemLabel;
		NSString *cellIdentifier;
}

@property (nonatomic, assign) IBOutlet UIImageView *itemImageView;
@property (nonatomic, assign) IBOutlet UILabel *itemLabel;
@property (nonatomic, copy) NSString *cellIdentifier;

-(id)initWith:(UIImageView *)itemImageView itemLabel:(UILabel *)itemLabel;

@end
