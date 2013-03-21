//
//  TBUserItemView.h
//  thebox
//
//  Created by Markos Charatzas on 02/02/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TBUserItemViewGetDirections)();

NS_INLINE
TBUserItemViewGetDirections tbUserItemViewGetDirectionsNoOp(){
return ^(){};
}

@interface TBUserItemView : UIView
@property(nonatomic, weak) IBOutlet UIImageView* itemImageView;
@property(nonatomic, weak) IBOutlet UILabel* whenLabel;
@property(nonatomic, weak) IBOutlet UILabel* storeLabel;
@property(nonatomic, copy) TBUserItemViewGetDirections didTapOnGetDirectionsButton;

-(IBAction)didTapOnGetDirectionsButton:(id)sender;

@end
