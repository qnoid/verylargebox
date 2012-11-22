//
//  UIButton+TBButton.m
//  thebox
//
//  Created by Markos Charatzas on 18/11/2012.
//  Copyright (c) 2012 TheBox. All rights reserved.
//

#import "TBButton.h"
#import <QuartzCore/QuartzCore.h>

@interface TBButton () <TBButtonBorder>
@property(nonatomic, strong) NSMutableDictionary* uiControlEventToBlock;
@end

@implementation TBButton

-(void)awakeFromNib
{
    self.uiControlEventToBlock = [NSMutableDictionary new];
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

#pragma public
-(TBButton*)cornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
return self;
}

- (id<TBButtonBorder>)border {
return [[self borderWidth:1.0f] borderColor:[UIColor blackColor].CGColor];
}

- (id<TBButtonBorder>)borderWidth:(CGFloat)width
{
    self.layer.borderWidth = width;
return self;
}

- (id<TBButtonBorder>)borderColor:(CGColorRef)color
{
    self.layer.borderColor = color;
return self;
}

-(void)onTouchDown:(TBButtonOnTouch)doo {
    [self setBlock:doo forAction:@selector(didTouchDownButton:) on:UIControlEventTouchDown];
}

-(void)onTouchUp:(TBButtonOnTouch)doo
{
    [self setBlock:doo forAction:@selector(didTouchUpInsideButton:) on:UIControlEventTouchUpInside];
    [self setBlock:doo forAction:@selector(didTouchUpOutsideButton:) on:UIControlEventTouchUpOutside];
}

-(void)didTouchDownButton:(id)sender
{
    TBButtonOnTouch onTouchDown = [self blockForControlEvent:UIControlEventTouchDown];
    onTouchDown(sender);
}

-(void)didTouchUpInsideButton:(id)sender
{
    TBButtonOnTouch onTouchDown = [self blockForControlEvent:UIControlEventTouchUpInside];
    onTouchDown(sender);
}

-(void)didTouchUpOutsideButton:(id)sender
{
    TBButtonOnTouch onTouchDown = [self blockForControlEvent:UIControlEventTouchUpInside];
    onTouchDown(sender);
}

@end
