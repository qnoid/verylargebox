//
//  TBUserItemView.h
//  thebox
//
//  Created by Markos Charatzas on 02/02/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBUserItemView : UIView
@property(nonatomic, weak) IBOutlet UIImageView* itemImageView;
@property(nonatomic, weak) IBOutlet UILabel* whenLabel;

+(instancetype)userItemViewWithOwner:(id)owner;

@end
