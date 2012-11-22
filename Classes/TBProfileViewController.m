//
//  TBProfileViewController.m
//  thebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import "TBProfileViewController.h"

@interface TBProfileViewController ()
-(id)initWithBundle:(NSBundle *)nibBundleOrNil;
@end

@implementation TBProfileViewController

+(TBProfileViewController*)newProfileViewController
{
    TBProfileViewController* profileViewController = [[TBProfileViewController alloc] initWithBundle:[NSBundle mainBundle]];
    profileViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"You" image:[UIImage imageNamed:@"user.png"] tag:0];

return profileViewController;
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TBProfileViewController" bundle:nibBundleOrNil];
    
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


@end
