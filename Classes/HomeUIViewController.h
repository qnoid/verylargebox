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
#import "TheBoxScrollView.h"

@interface HomeUIViewController : UIViewController {
    IBOutlet UILabel *location;
    IBOutlet UISearchBar *search;
    IBOutlet TheBoxScrollView *theBox;
}
- (IBAction)upload:(id)sender;
@end
