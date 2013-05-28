/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 21/05/2011.
 *  Contributor(s): .-
 */
#import "TheBoxUIGridView.h"
#import "TheBoxUIGridViewDatasource.h"
#import "TheBoxUIGridViewDelegate.h"
#import "TheBoxUIScrollView.h"
#import "TheBoxUIScrollViewDatasource.h"

@interface TheBoxUIGridView () <TheBoxUIScrollViewDatasource, TheBoxUIScrollViewDelegate>
@property(nonatomic, strong) NSMutableDictionary* frames;
@property(nonatomic, strong) NSMutableDictionary* views;
@property(nonatomic, strong) TheBoxUIScrollView *scrollView;

- (id)initWith:(CGRect)frame scrollView:(TheBoxUIScrollView*)scrollView;
-(UIView*)gridView:(TheBoxUIGridView *)gridView viewOf:(UIView*)view ofFrame:(CGRect)frame atIndex:(NSInteger)index;
-(UIView*)viewAtRow:(NSUInteger)row;
-(void)setView:(UIView*)view atIndex:(NSUInteger)index;
@end


@implementation TheBoxUIGridView

+(instancetype)newVerticalGridView:(CGRect)frame viewsOf:(CGFloat)height
{
    
    TheBoxUIScrollViewBuilder *builder =
        [[TheBoxUIScrollViewBuilder alloc] initWith:CGRectMake(CGPointZero.x, CGPointZero.y, frame.size.width, frame.size.height)
                                            viewsOf:height];

    TheBoxUIScrollView *newVerticalScrollView = [builder newVerticalScrollView];
    
    TheBoxUIGridView* gridView = [[TheBoxUIGridView alloc] initWith:frame scrollView:newVerticalScrollView];
    
	newVerticalScrollView.datasource = gridView;
	newVerticalScrollView.scrollViewDelegate = gridView;
    newVerticalScrollView.showsVerticalScrollIndicator = NO;
    newVerticalScrollView.scrollsToTop = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:gridView action:@selector(viewWasTapped:)];
    
    [newVerticalScrollView addGestureRecognizer:tapGestureRecognizer];
    
return gridView;
}

- (id)initWith:(CGRect)frame scrollView:(TheBoxUIScrollView*)scrollView
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.frames = [NSMutableDictionary new];
    self.views = [NSMutableDictionary new];

    self.scrollView = scrollView;
    [self addSubview:self.scrollView];

return self;
}

#pragma mark testing
- (id)initWith:(NSMutableDictionary*)frames
{
    self = [super init];
    if (self) {
		self.frames = frames;
		self.views = [NSMutableDictionary new];       
    }
    return self;
}

#pragma mark 
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
		self.frames = [NSMutableDictionary new];
		self.views = [NSMutableDictionary new];       
    }
    return self;
}

-(void)setShowsVerticalScrollIndicator:(BOOL)indeed {
    self.scrollView.showsVerticalScrollIndicator = indeed;
}

-(BOOL)showsVerticalScrollIndicator{
    return self.scrollView.showsVerticalScrollIndicator;
}

-(void)awakeFromNib
{
    CGFloat height = [self.delegate whatRowHeight:self];
    
    TheBoxUIScrollView *newVerticalScrollView =
        [TheBoxUIScrollView
            newVerticalScrollView:CGRectMake(CGPointZero.x, CGPointZero.y, self.frame.size.width, self.frame.size.height)
            viewsOf:height];
    
	newVerticalScrollView.datasource = self;
	newVerticalScrollView.scrollViewDelegate = self;
    newVerticalScrollView.showsVerticalScrollIndicator = NO;
    newVerticalScrollView.scrollsToTop = YES;
    
    self.scrollView = newVerticalScrollView;
    [self addSubview:self.scrollView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped:)];
    [self.scrollView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark private

- (UIView*)gridView:(TheBoxUIGridView *)gridView viewOf:(UIView*)view ofFrame:(CGRect)frame atIndex:(NSInteger)index 
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

#pragma mark TheBoxUIScrollViewDelegate

-(void)didLayoutSubviews:(UIScrollView *)scrollView
{
}

-(void)viewInScrollView:(TheBoxUIScrollView *)scrollView willAppearBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex{
    
}

-(void)scrollView:(UIScrollView *)scrollView willStopAt:(NSUInteger)index{
    
}

- (void)viewInScrollView:(TheBoxUIScrollView *)scrollView willAppear:(UIView*)view atIndex:(NSUInteger)index 
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

#pragma mark TheBoxUIScrollViewDatasource

-(NSUInteger)numberOfViewsInScrollView:(TheBoxUIScrollView *)scrollView 
{
    if(![scrollView isEqual:self.scrollView])
    {
        NSNumber* index = 
        [self.frames objectForKey:[NSValue valueWithCGRect:[scrollView frame]]];
        
    return [self.datasource numberOfViewsInGridView:self atIndex:[index intValue]];
    }

return [self.datasource numberOfViewsInGridView:self];    
}

- (UIView*)viewInScrollView:(TheBoxUIScrollView *)scrollView ofFrame:(CGRect)frame atIndex:(NSInteger)index 
{
    if(![scrollView isEqual:self.scrollView]) {        
    return [self gridView:self viewOf:scrollView ofFrame:frame atIndex:index];
    }

	DDLogVerbose(@"asking for row %d", index);
	
    TheBoxUIScrollView* view = [TheBoxUIScrollView 
                                newHorizontalScrollView:frame
                  viewsOf:[self.delegate whatCellWidth:self]];
    
    view.datasource = self;
    view.scrollViewDelegate = self;
    
	DDLogVerbose(@"view %@", view);
    
return view;
}

#pragma mark TheBoxUIScrollViewDelegate

-(void)didSelectView:(TheBoxUIScrollView *)scrollView atIndex:(NSUInteger)index
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
    
    UIView<CanIndexLocationInView>* view = (UIView<CanIndexLocationInView>*)[self viewAtRow:row];

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