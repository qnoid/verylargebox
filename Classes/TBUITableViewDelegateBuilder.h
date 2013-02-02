//
//  TBUITableViewDelegateBuilder.h
//  thebox
//
//  Created by Markos Charatzas on 02/02/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TBDidDeselectRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);

NS_INLINE
TBDidDeselectRowAtIndexPath tbDoNothing(){
return ^(UITableView *tableView, NSIndexPath *indexPath){};
}

@interface TBUITableViewDelegate : NSObject <UITableViewDelegate>

@end

/**
 Use to create a delegate implementing only the required methods.
 
 */
@interface TBUITableViewDelegateBuilder : NSObject

-(TBUITableViewDelegateBuilder*)didDeselectRowAtIndexPath:(TBDidDeselectRowAtIndexPath)didDeselectRowAtIndexPath;
-(id<UITableViewDelegate>)newDelegate;
@end
