//
//  VLBTableViewDelegateBuilder.m
//  thebox
//
//  Created by Markos Charatzas on 02/02/2013.
//  Copyright (c) 2013 TheBox. All rights reserved.
//

#import "VLBTableViewDelegateBuilder.h"

@interface VLBTableViewDelegate ()
@property(nonatomic, copy) VLBDidSelectRowAtIndexPath didSelectRowAtIndexPath;
-(id)initWithDidDeselectRowAtIndexPath:(VLBDidSelectRowAtIndexPath) didSelectRowAtIndexPath;
@end

@implementation VLBTableViewDelegate

-(id)initWithDidDeselectRowAtIndexPath:(VLBDidSelectRowAtIndexPath) didSelectRowAtIndexPath
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


@interface VLBTableViewDelegateBuilder ()
@property(nonatomic, copy) VLBDidSelectRowAtIndexPath didSelectRowAtIndexPath;
@end

@implementation VLBTableViewDelegateBuilder

-(id)init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.didSelectRowAtIndexPath = tbDoNothing();
    
return self;
}

-(VLBTableViewDelegateBuilder *)didSelectRowAtIndexPath:(VLBDidSelectRowAtIndexPath)didSelectRowAtIndexPath;
{
    self.didSelectRowAtIndexPath = didSelectRowAtIndexPath;
return self;
}

-(id<UITableViewDelegate>)newDelegate {
    return [[VLBTableViewDelegate alloc] initWithDidDeselectRowAtIndexPath:self.didSelectRowAtIndexPath];
}
@end
