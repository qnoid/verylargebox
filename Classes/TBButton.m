//
//  UIButton+TBButton.m
//  thebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import "TBButton.h"
#import "TBMacros.h"

@interface TBButton ()
@property(nonatomic, strong) NSMutableDictionary* uiControlEventToBlock;
@end

@implementation TBButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    TB_IF_NOT_SELF_RETURN_NIL()
    
    self.uiControlEventToBlock = [NSMutableDictionary new];
    
return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    TB_IF_NOT_SELF_RETURN_NIL()
    
    self.uiControlEventToBlock = [NSMutableDictionary new];
    
    return self;
}

#pragma private
-(id)blockForControlEvent:(UIControlEvents)controlEvent{
return[self.uiControlEventToBlock objectForKey:[NSNumber numberWithInt:controlEvent]];
}

- (void)setBlock:(TBButtonOnTouch)doo forAction:(SEL)action on:(UIControlEvents)uiControlEvent
{
    [self.uiControlEventToBlock setObject:[doo copy] forKey:[NSNumber numberWithInt:uiControlEvent]];
    [self addTarget:self action:action forControlEvents:uiControlEvent];
}

-(void)onTouchDown:(TBButtonOnTouch)doo {
    [self setBlock:doo forAction:@selector(didTouchDownButton:) on:UIControlEventTouchDown];
}

-(void)onTouchUpInside:(TBButtonOnTouch)doo {
    [self setBlock:doo forAction:@selector(didTouchUpInsideButton:) on:UIControlEventTouchUpInside];
}


-(void)onTouchUp:(TBButtonOnTouch)doo
{
    [self setBlock:doo forAction:@selector(didTouchUpInsideButton:) on:UIControlEventTouchUpInside];
}

-(void)didTouchDownButton:(id)sender
{
    TBButtonOnTouch onTouchDown = [self blockForControlEvent:UIControlEventTouchDown];
    onTouchDown(sender);
}

-(void)didTouchUpInsideButton:(id)sender
{
    TBButtonOnTouch onTouchUpInside = [self blockForControlEvent:UIControlEventTouchUpInside];
    onTouchUpInside(sender);
}

-(void)didTouchUpOutsideButton:(id)sender
{
    TBButtonOnTouch onTouchDown = [self blockForControlEvent:UIControlEventTouchUpInside];
    onTouchDown(sender);
}

-(void)drawRect:(CGRect)rect
{
    __weak UIView* wself = self;
    [self.delegate drawRect:rect inView:wself];
}

@end
