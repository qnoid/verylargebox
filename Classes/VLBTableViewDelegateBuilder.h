//
//  VLBTableViewDelegateBuilder.h
//  verylargebox
//
//  Created by Markos Charatzas on 02/02/2013.
//  Copyright (c) 2013 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^VLBDidSelectRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);

NS_INLINE
VLBDidSelectRowAtIndexPath tbDoNothing(){
return ^(UITableView *tableView, NSIndexPath *indexPath){};
}

@interface VLBTableViewDelegate : NSObject <UITableViewDelegate>

@end

/**
 Use to create a delegate implementing only the required methods.
 
 */
@interface VLBTableViewDelegateBuilder : NSObject

-(VLBTableViewDelegateBuilder *)didSelectRowAtIndexPath:(VLBDidSelectRowAtIndexPath)didSelectRowAtIndexPath;
-(id<UITableViewDelegate>)newDelegate;
@end
