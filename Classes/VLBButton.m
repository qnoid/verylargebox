//
//  UIButton+VLBButton.m
//  thebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 (verylargebox.com). All rights reserved.
//

#import "VLBButton.h"
#import "VLBMacros.h"

@interface VLBButton ()
@property(nonatomic, strong) NSMutableDictionary* uiControlEventToBlock;
@end

@implementation VLBButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    VLB_IF_NOT_SELF_RETURN_NIL()
    
    self.uiControlEventToBlock = [NSMutableDictionary new];
    
return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    VLB_IF_NOT_SELF_RETURN_NIL()
    
    self.uiControlEventToBlock = [NSMutableDictionary new];
    
    return self;
}

#pragma private
-(id)blockForControlEvent:(UIControlEvents)controlEvent{
return[self.uiControlEventToBlock objectForKey:[NSNumber numberWithInt:controlEvent]];
}

- (void)setBlock:(VLBButtonOnTouch)doo forAction:(SEL)action on:(UIControlEvents)uiControlEvent
{
    [self.uiControlEventToBlock setObject:[doo copy] forKey:[NSNumber numberWithInt:uiControlEvent]];
    [self addTarget:self action:action forControlEvents:uiControlEvent];
}

-(void)onTouchDown:(VLBButtonOnTouch)doo {
    [self setBlock:doo forAction:@selector(didTouchDownButton:) on:UIControlEventTouchDown];
}

-(void)onTouchUpInside:(VLBButtonOnTouch)doo {
    [self setBlock:doo forAction:@selector(didTouchUpInsideButton:) on:UIControlEventTouchUpInside];
}


-(void)onTouchUp:(VLBButtonOnTouch)doo
{
    [self setBlock:doo forAction:@selector(didTouchUpInsideButton:) on:UIControlEventTouchUpInside];
}

-(void)didTouchDownButton:(id)sender
{
    VLBButtonOnTouch onTouchDown = [self blockForControlEvent:UIControlEventTouchDown];
    onTouchDown(sender);
}

-(void)didTouchUpInsideButton:(id)sender
{
    VLBButtonOnTouch onTouchUpInside = [self blockForControlEvent:UIControlEventTouchUpInside];
    onTouchUpInside(sender);
}

-(void)didTouchUpOutsideButton:(id)sender
{
    VLBButtonOnTouch onTouchDown = [self blockForControlEvent:UIControlEventTouchUpInside];
    onTouchDown(sender);
}

-(void)drawRect:(CGRect)rect
{
    __weak UIView* wself = self;
    [self.delegate drawRect:rect inView:wself];
}

@end
