//
//  TBUITableViewDataSourceBuilder.h
//  thebox
//
//  Created by Markos Charatzas on 08/12/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSInteger(^TBNumberOfRowsInSectionBlock)(UITableView *tableView, NSInteger section);
typedef UITableViewCell*(^TBCellForRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);

NS_INLINE
TBNumberOfRowsInSectionBlock tbZeroNumberOfRows(){
return ^(UITableView *tableView, NSInteger section){return 0;};
}

NS_INLINE
TBCellForRowAtIndexPath tbNilCellForRowAtIndexPath(){
return ^UITableViewCell*(UITableView *tableView, NSIndexPath *indexPath){return nil;};
}

@interface TBUITableViewDataSource : NSObject <UITableViewDataSource>

@end

/**
 Use to create an datasource implementing only the required methods.
 
 The datasource created does not support any changes to the underlying objects.
 */
@interface TBUITableViewDataSourceBuilder : NSObject

-(TBUITableViewDataSourceBuilder*)numberOfRowsInSection:(TBNumberOfRowsInSectionBlock)numberOfRowsInSection;
-(TBUITableViewDataSourceBuilder*)cellForRowAtIndexPath:(TBCellForRowAtIndexPath)cellForRowAtIndexPath;
-(id<UITableViewDataSource>)newDatasource;
@end
