//
//  VLBTableViewDataSourceBuilder.h
//  thebox
//
//  Created by Markos Charatzas on 08/12/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLBTypography.h"
#import "VLBColors.h"

typedef NSInteger(^VLBNumberOfRowsInSectionBlock)(UITableView *tableView, NSInteger section);
typedef UITableViewCell*(^VLBCellForRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath);
typedef void(^VLBTableViewCellBlock)(UITableViewCell* cell, NSIndexPath* indexPath);

NS_INLINE
VLBNumberOfRowsInSectionBlock tbZeroNumberOfRows(){
return ^(UITableView *tableView, NSInteger section){return 0;};
}

NS_INLINE
VLBCellForRowAtIndexPath tbNilCellForRowAtIndexPath(){
return ^UITableViewCell*(UITableView *tableView, NSIndexPath *indexPath){return nil;};
}

NS_INLINE
VLBCellForRowAtIndexPath tbCellForRowAtIndexPath(VLBTableViewCellBlock block)
{
return ^UITableViewCell*(UITableView *tableView, NSIndexPath* indexPath)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.textLabel.font = [VLBTypography fontLucidaGrandeEleven];
            cell.textLabel.textColor = [VLBColors colorPearlWhite];
        }
        
        block(cell, indexPath);
        
    return cell;
    };
}

@interface VLBTableViewDataSource : NSObject <UITableViewDataSource>

@end

/**
 Use to create an datasource implementing only the required methods.
 
 The datasource created does not support any changes to the underlying objects.
 */
@interface VLBTableViewDataSourceBuilder : NSObject

-(VLBTableViewDataSourceBuilder *)numberOfRowsInSection:(VLBNumberOfRowsInSectionBlock)numberOfRowsInSection;
-(VLBTableViewDataSourceBuilder *)cellForRowAtIndexPath:(VLBCellForRowAtIndexPath)cellForRowAtIndexPath;
-(id<UITableViewDataSource>)newDatasource;
@end
