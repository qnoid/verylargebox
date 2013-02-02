//
//  TBUITableViewDelegateBuilder.m
//  thebox
//
//  Created by Markos Charatzas on 02/02/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "TBUITableViewDelegateBuilder.h"

@interface TBUITableViewDelegate()
@property(nonatomic, copy) TBDidDeselectRowAtIndexPath didDeselectRowAtIndexPath;
-(id)initWithDidDeselectRowAtIndexPath:(TBDidDeselectRowAtIndexPath) didDeselectRowAtIndexPath;
@end

@implementation TBUITableViewDelegate

-(id)initWithDidDeselectRowAtIndexPath:(TBDidDeselectRowAtIndexPath) didDeselectRowAtIndexPath
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.didDeselectRowAtIndexPath = didDeselectRowAtIndexPath;
    
return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end


@interface TBUITableViewDelegateBuilder()
@property(nonatomic, copy) TBDidDeselectRowAtIndexPath didDeselectRowAtIndexPath;
@end

@implementation TBUITableViewDelegateBuilder

-(id)init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.didDeselectRowAtIndexPath = tbDoNothing();
    
return self;
}

-(TBUITableViewDelegateBuilder*)didDeselectRowAtIndexPath:(TBDidDeselectRowAtIndexPath)didDeselectRowAtIndexPath;
{
    self.didDeselectRowAtIndexPath = didDeselectRowAtIndexPath;
return self;
}

-(id<UITableViewDelegate>)newDelegate {
    return [[TBUITableViewDelegate alloc] initWithDidDeselectRowAtIndexPath:self.didDeselectRowAtIndexPath];
}
@end
