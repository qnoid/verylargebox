//
//  TBUITableViewDelegateBuilder.m
//  thebox
//
//  Created by Markos Charatzas on 02/02/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "TBUITableViewDelegateBuilder.h"

@interface TBUITableViewDelegate()
@property(nonatomic, copy) TBDidSelectRowAtIndexPath didSelectRowAtIndexPath;
-(id)initWithDidDeselectRowAtIndexPath:(TBDidSelectRowAtIndexPath) didSelectRowAtIndexPath;
@end

@implementation TBUITableViewDelegate

-(id)initWithDidDeselectRowAtIndexPath:(TBDidSelectRowAtIndexPath) didSelectRowAtIndexPath
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.didSelectRowAtIndexPath = didSelectRowAtIndexPath;
    
return self;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.didSelectRowAtIndexPath(tableView, indexPath);
}
@end


@interface TBUITableViewDelegateBuilder()
@property(nonatomic, copy) TBDidSelectRowAtIndexPath didSelectRowAtIndexPath;
@end

@implementation TBUITableViewDelegateBuilder

-(id)init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.didSelectRowAtIndexPath = tbDoNothing();
    
return self;
}

-(TBUITableViewDelegateBuilder*)didSelectRowAtIndexPath:(TBDidSelectRowAtIndexPath)didSelectRowAtIndexPath;
{
    self.didSelectRowAtIndexPath = didSelectRowAtIndexPath;
return self;
}

-(id<UITableViewDelegate>)newDelegate {
    return [[TBUITableViewDelegate alloc] initWithDidDeselectRowAtIndexPath:self.didSelectRowAtIndexPath];
}
@end
