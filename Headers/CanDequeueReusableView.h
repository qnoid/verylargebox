/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 23/05/2011.
 *  Contributor(s): .-
 */
@protocol CanDequeueReusableView <NSObject>
- (UIView *)dequeueReusableView;
@end