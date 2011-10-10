/*
 *  Copyright 2010 Geeks Republic ( http://www.geeksrepublic.com )
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 20/03/2011.
 *  Contributor(s): .-
 */
#import "TheBoxDelegate.h"

@protocol TheBoxQuery<NSObject>

/*
 * @param @Nullable delegate
 */
-(void)make:(id<TheBoxDelegate>)delegate;

@end
