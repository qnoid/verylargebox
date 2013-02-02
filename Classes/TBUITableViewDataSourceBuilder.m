//
//  TBUITableViewDataSourceBuilder.m
//  thebox
//
//  Created by Markos Charatzas on 08/12/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import "TBUITableViewDataSourceBuilder.h"

@interface TBUITableViewDataSource()
@property(nonatomic, copy) TBNumberOfRowsInSectionBlock numberOfRowsInSection;
@property(nonatomic, copy) TBCellForRowAtIndexPath cellForRowAtIndexPath;
-(id)initWithNumberOfRowsInSection:(TBNumberOfRowsInSectionBlock) numberOfRowsInSection cellForRowAtIndexPath:(TBCellForRowAtIndexPath) cellForRowAtIndexPath;
@end

@implementation TBUITableViewDataSource

-(id)initWithNumberOfRowsInSection:(TBNumberOfRowsInSectionBlock) numberOfRowsInSection cellForRowAtIndexPath:(TBCellForRowAtIndexPath) cellForRowAtIndexPath
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


@interface TBUITableViewDataSourceBuilder()
@property(nonatomic, copy) TBNumberOfRowsInSectionBlock numberOfRowsInSection;
@property(nonatomic, copy) TBCellForRowAtIndexPath cellForRowAtIndexPath;
@end

@implementation TBUITableViewDataSourceBuilder

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

-(TBUITableViewDataSourceBuilder *)numberOfRowsInSection:(TBNumberOfRowsInSectionBlock)numberOfRowsInSection
{
    self.numberOfRowsInSection = numberOfRowsInSection;
return self;
}

-(TBUITableViewDataSourceBuilder *)cellForRowAtIndexPath:(TBCellForRowAtIndexPath)cellForRowAtIndexPath
{
    self.cellForRowAtIndexPath = cellForRowAtIndexPath;
    
return self;
}

-(id<UITableViewDataSource>)newDatasource {
return [[TBUITableViewDataSource alloc] initWithNumberOfRowsInSection:self.numberOfRowsInSection cellForRowAtIndexPath:self.cellForRowAtIndexPath];
}
@end
