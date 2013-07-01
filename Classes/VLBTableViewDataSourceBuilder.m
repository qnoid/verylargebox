//
//  VLBTableViewDataSourceBuilder.m
//  verylargebox
//
//  Created by Markos Charatzas on 08/12/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import "VLBTableViewDataSourceBuilder.h"

@interface VLBTableViewDataSource ()
@property(nonatomic, copy) VLBNumberOfRowsInSectionBlock numberOfRowsInSection;
@property(nonatomic, copy) VLBCellForRowAtIndexPath cellForRowAtIndexPath;
-(id)initWithNumberOfRowsInSection:(VLBNumberOfRowsInSectionBlock) numberOfRowsInSection cellForRowAtIndexPath:(VLBCellForRowAtIndexPath) cellForRowAtIndexPath;
@end

@implementation VLBTableViewDataSource

-(id)initWithNumberOfRowsInSection:(VLBNumberOfRowsInSectionBlock) numberOfRowsInSection cellForRowAtIndexPath:(VLBCellForRowAtIndexPath) cellForRowAtIndexPath
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.numberOfRowsInSection = numberOfRowsInSection;
    self.cellForRowAtIndexPath = cellForRowAtIndexPath;
    
return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
return self.numberOfRowsInSection(tableView, section);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
return self.cellForRowAtIndexPath(tableView, indexPath);
}

@end


@interface VLBTableViewDataSourceBuilder ()
@property(nonatomic, copy) VLBNumberOfRowsInSectionBlock numberOfRowsInSection;
@property(nonatomic, copy) VLBCellForRowAtIndexPath cellForRowAtIndexPath;
@end

@implementation VLBTableViewDataSourceBuilder

-(id)init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.numberOfRowsInSection = tbZeroNumberOfRows();
    self.cellForRowAtIndexPath = tbNilCellForRowAtIndexPath();
    
return self;
}

-(VLBTableViewDataSourceBuilder *)numberOfRowsInSection:(VLBNumberOfRowsInSectionBlock)numberOfRowsInSection
{
    self.numberOfRowsInSection = numberOfRowsInSection;
return self;
}

-(VLBTableViewDataSourceBuilder *)cellForRowAtIndexPath:(VLBCellForRowAtIndexPath)cellForRowAtIndexPath
{
    self.cellForRowAtIndexPath = cellForRowAtIndexPath;
    
return self;
}

-(id<UITableViewDataSource>)newDatasource {
return [[VLBTableViewDataSource alloc] initWithNumberOfRowsInSection:self.numberOfRowsInSection cellForRowAtIndexPath:self.cellForRowAtIndexPath];
}
@end
