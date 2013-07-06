//
//  VLBGridView.m
//  verylargebox
//
//  Created by Markos Charatzas on 21/05/2011.
//  Copyright (c) 2011 (verylargebox.com). All rights reserved.
//

#import "VLBGridView.h"
#import "VLBGridViewDatasource.h"
#import "VLBGridViewDelegate.h"
#import "VLBScrollView.h"
#import "VLBScrollViewDatasource.h"
#import "VLBMacros.h"
#import "DDLog.h"

@interface VLBGridView () <VLBScrollViewDatasource, VLBScrollViewDelegate>
@property(nonatomic, strong) NSMutableDictionary* frames;
@property(nonatomic, strong) NSMutableDictionary* views;
@property(nonatomic, strong) VLBScrollView *scrollView;

-(void)viewWasTapped:(id)sender;
-(UIView*)gridView:(VLBGridView *)gridView viewOf:(UIView*)view ofFrame:(CGRect)frame atIndex:(NSInteger)index;
-(UIView*)viewAtRow:(NSUInteger)row;
-(void)setView:(UIView*)view atIndex:(NSUInteger)index;
@end

VLBGridViewOrientation const VLBGridViewOrientationVertical = ^(VLBGridView *gridView)
{
    CGRect frame = CGRectMake(CGPointZero.x, CGPointZero.y, gridView.frame.size.width, gridView.frame.size.height);
    
    VLBScrollView *scrollView =
        [VLBScrollView newVerticalScrollView:frame
                                      config:^(VLBScrollView* scrollView, BOOL foo)
                                    {
                                        scrollView.datasource = gridView;
                                        scrollView.scrollViewDelegate = gridView;
                                        scrollView.showsVerticalScrollIndicator = NO;
                                        scrollView.scrollsToTop = YES;
                                        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                                        scrollView.backgroundColor = [UIColor clearColor];
                                        
                                        UITapGestureRecognizer *tapGestureRecognizer =
                                            [[UITapGestureRecognizer alloc] initWithTarget:gridView
                                                                                    action:@selector(viewWasTapped:)];
                                        [scrollView addGestureRecognizer:tapGestureRecognizer];
                                    }];

    gridView.scrollView = scrollView;
    [gridView addSubview:gridView.scrollView];
};

VLBGridViewOrientation const VLBGridViewOrientationHorizontal = ^(VLBGridView *gridView)
{
    CGRect frame = CGRectMake(CGPointZero.x, CGPointZero.y, gridView.frame.size.width, gridView.frame.size.height);
    
    VLBScrollView *scrollView =
        [VLBScrollView newHorizontalScrollView:frame
                                        config:^(VLBScrollView* scrollView, BOOL foo)
                                        {
                                            scrollView.datasource = gridView;
                                            scrollView.scrollViewDelegate = gridView;
                                            scrollView.showsHorizontalScrollIndicator = NO;
                                            scrollView.scrollsToTop = YES;
                                            scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                                            scrollView.backgroundColor = [UIColor clearColor];
                                            
                                            UITapGestureRecognizer *tapGestureRecognizer =
                                                [[UITapGestureRecognizer alloc] initWithTarget:gridView
                                                                                        action:@selector(viewWasTapped:)];
                                            [scrollView addGestureRecognizer:tapGestureRecognizer];
                                        }];

    gridView.scrollView = scrollView;
    [gridView addSubview:gridView.scrollView];
};

@implementation VLBGridView

+(instancetype)newVerticalGridView:(CGRect)frame config:(VLBGridViewConfig)config
{
    VLBGridView *gridView = [[VLBGridView alloc] initWithFrame:frame];
	  config(gridView);
		VLBGridViewOrientationVertical(gridView);
    
return gridView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    VLB_IF_NOT_SELF_RETURN_NIL();
    
    self.frames = [NSMutableDictionary new];
    self.views = [NSMutableDictionary new];

return self;
}

#pragma mark testing
- (id)initWith:(NSMutableDictionary*)frames
{
    VLB_INIT_OR_RETURN_NIL();

    self.frames = frames;
    self.views = [NSMutableDictionary new];       

return self;
}

#pragma mark 
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];

    VLB_IF_NOT_SELF_RETURN_NIL();

    self.frames = [NSMutableDictionary new];
    self.views = [NSMutableDictionary new];       

return self;
}

-(void)awakeFromNib
{
    VLBGridViewOrientationVertical(self);
}

-(void)setShowsVerticalScrollIndicator:(BOOL)indeed {
    self.scrollView.showsVerticalScrollIndicator = indeed;
}

-(BOOL)showsVerticalScrollIndicator{
    return self.scrollView.showsVerticalScrollIndicator;
}

#pragma mark private

- (UIView*)gridView:(VLBGridView *)gridView viewOf:(UIView*)view ofFrame:(CGRect)frame atIndex:(NSInteger)index
{
    NSUInteger row = [[self.frames objectForKey:[NSValue valueWithCGRect:[view frame]]] unsignedIntegerValue];
    
    DDLogVerbose(@"asking for column %d at row %d", index, row);

return [self.datasource gridView:gridView viewOf:view ofFrame:frame atRow:row atIndex:index];
}

-(UIView*)viewAtRow:(NSUInteger)row {
return [self.views objectForKey:[NSNumber numberWithInt:row]];
}

-(void)setView:(UIView*)view atIndex:(NSUInteger)index
{
    [self.views setObject:view forKey:[NSNumber numberWithInt:index]];
	[self.frames setObject:[NSNumber numberWithInt:index] forKey:[NSValue valueWithCGRect:[view frame]]];
}

#pragma mark VLBScrollViewDelegate

-(VLBScrollViewOrientation)orientation:(VLBScrollView*)scrollView{
return VLBScrollViewOrientationVertical;
}

-(CGFloat)viewsOf:(VLBScrollView *)scrollView{
    return [self.delegate whatCellWidth:self];
}

-(void)didLayoutSubviews:(VLBScrollView *)scrollView
{
}

-(void)viewInScrollView:(VLBScrollView *)scrollView willAppearBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex{
    
}

-(void)scrollView:(UIScrollView *)scrollView willStopAt:(NSUInteger)index{
    
}

- (void)viewInScrollView:(VLBScrollView *)scrollView willAppear:(UIView*)view atIndex:(NSUInteger)index
{
    if(![scrollView isEqual:self.scrollView]) 
    {
        NSUInteger row = [[self.frames objectForKey:[NSValue valueWithCGRect:[scrollView frame]]] unsignedIntegerValue];
        
        [self.delegate gridView:self viewOf:scrollView atRow:row atIndex:index willAppear:view];
    return;
    }       
    
    [self setView:view atIndex:index];
    [self.delegate gridView:self atIndex:index willAppear:view];
}

#pragma mark VLBcrollViewDatasource

-(NSUInteger)numberOfViewsInScrollView:(VLBScrollView *)scrollView
{
    if(![scrollView isEqual:self.scrollView])
    {
        NSNumber* index = 
        [self.frames objectForKey:[NSValue valueWithCGRect:[scrollView frame]]];
        
    return [self.datasource numberOfViewsInGridView:self atIndex:[index intValue]];
    }

return [self.datasource numberOfViewsInGridView:self];    
}

- (UIView*)viewInScrollView:(VLBScrollView *)scrollView ofFrame:(CGRect)frame atIndex:(NSUInteger)index
{
    if(![scrollView isEqual:self.scrollView]) {        
    return [self gridView:self viewOf:scrollView ofFrame:frame atIndex:index];
    }

	DDLogVerbose(@"asking for row %d", index);
	
    VLBScrollView * view =
        [VLBScrollView newHorizontalScrollView:frame
                                        config:^(VLBScrollView *scrollView, BOOL canCancelContentTouches){
                                            scrollView.datasource = self;
                                            scrollView.scrollViewDelegate = self;
                                            scrollView.backgroundColor = [UIColor clearColor];
                                        }];
    
    
	DDLogVerbose(@"view %@", view);
    
return view;
}

#pragma mark VLBScrollViewDelegate

-(void)didSelectView:(VLBScrollView *)scrollView atIndex:(NSUInteger)index
{
    if(![scrollView isEqual:self.scrollView])
    {
        NSUInteger row = [[self.frames objectForKey:[NSValue valueWithCGRect:[scrollView frame]]] unsignedIntegerValue];
        
        [self.delegate didSelect:self atRow:row atIndex:index];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

#pragma mark public
-(void)reload
{
    [self.scrollView setNeedsLayout];
}

- (void)flashScrollIndicators
{
    [self.scrollView flashScrollIndicators];
}

-(void)viewWasTapped:(id)sender
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer*)sender;
    CGPoint tapPoint = [tapGestureRecognizer locationInView:self.scrollView];
    DDLogVerbose(@"%@", NSStringFromCGPoint(tapPoint));
    DDLogVerbose(@"%@", NSStringFromCGSize(self.scrollView.contentSize));

    NSUInteger row = [self.scrollView indexOf:tapPoint];
    DDLogVerbose(@"%u", row);
    
    NSUInteger numberOfRows = [self numberOfViewsInScrollView:self.scrollView];
    
    if(row >= numberOfRows){
        return;
    }
    
    UIView<VLBCanIndexLocationInView>* view = (UIView<VLBCanIndexLocationInView>*)[self viewAtRow:row];

    tapPoint = [tapGestureRecognizer locationInView:view];
    NSUInteger index = [view indexOf:tapPoint];
    DDLogVerbose(@"[%u, %u], %@, %@", row, index, view, NSStringFromCGRect(view.bounds));
    
    NSUInteger numberOfViews = [self.datasource numberOfViewsInGridView:self atIndex:row];
    
    /**User can tap outside of the view (e.g. when items are less than visible view
     
     |visible scrollview|
     |--------|---------|
     |  item  |dead view|
     |--------|---------|
     0          1
     
     numberOfViews = 1
     valid indexes = 0
     */
    if(index >= numberOfViews){
        return;
    }
    
    [self.delegate didSelect:self atRow:row atIndex:index];
}

@end
