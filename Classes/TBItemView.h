//
//  TBItemView.h
//  thebox
//
//  Created by Markos Charatzas on 10/01/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBItemView : UIView
@property(nonatomic, weak) IBOutlet UIImageView* itemImageView;
@property(nonatomic, weak) IBOutlet UITableView* itemComments;

+(instancetype)itemViewWithOwner:(id)owner;
@end
