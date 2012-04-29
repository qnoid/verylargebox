/*
 *  Copyright 2010 TheBox
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas <[firstname.lastname@gmail.com]> on 21/05/2011.
 *  Contributor(s): .-
 */
#import "TheBoxUIGridViewController.h"
#import "TheBoxUIGridView.h"
#import "TheBoxSize.h"
#import "TheBoxRect.h"
#import "TheBoxUIScrollView.h"
#import "TheBoxUIScrollViewDatasource.h"
#import "TheBoxUIGridViewDelegate.h"

@interface TheBoxUIGridView () <TheBoxUIScrollViewDatasource, TheBoxUIScrollViewDelegate>
@property(nonatomic, strong) NSMutableDictionary* frames;
@property(nonatomic, strong) NSMutableDictionary* views;
@property(nonatomic, strong) TheBoxUIScrollView *scrollView;
@property(nonatomic) id<TheBoxUIScrollViewDatasource> scrollViewDatasource;
@property(nonatomic) id<TheBoxUIScrollViewDelegate> scrollViewDelegate;

-(UIView*)viewAtRow:(NSUInteger)row;
-(void)setView:(UIView*)view atIndex:(NSUInteger)index;
-(CGRect)frameOf:(TheBoxUIScrollView *)scrollView atIndex:(NSUInteger)index;
@end


@implementation TheBoxUIGridView

#pragma mark private fields

@synthesize frames = _frames;
@synthesize views;
@synthesize datasource;
@synthesize delegate;
@synthesize scrollView = _scrollView;
@synthesize scrollViewDelegate;
@synthesize scrollViewDatasource = _datasource;

#pragma mark testing
- (id)initWith:(NSMutableDictionary*)frames
{
    self = [super init];
    if (self) {
		_frames = frames;
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

-(void)awakeFromNib
{
    CGFloat height = [self.delegate whatRowHeight:self];
    
    TheBoxUIScrollView *newVerticalScrollView =
        [TheBoxUIScrollView
            newVerticalScrollView:CGRectMake(CGPointZero.x, CGPointZero.y, self.frame.size.width, self.frame.size.height)
            viewsOf:height];
    
	newVerticalScrollView.datasource = self;
	newVerticalScrollView.scrollViewDelegate = self;
    newVerticalScrollView.scrollsToTop = YES;
    
    self.scrollView = newVerticalScrollView;
    [self addSubview:self.scrollView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped:)];
    [self.scrollView addGestureRecognizer:tapGestureRecognizer];
}

-(void)layoutSubviews
{
    [self.scrollView layoutSubviews];
}

#pragma mark private

-(UIView*)viewAtRow:(NSUInteger)row {
return [self.views objectForKey:[NSNumber numberWithInt:row]];
}

-(void)setView:(UIView*)view atIndex:(NSUInteger)index
{
    [self.views setObject:view forKey:[NSNumber numberWithInt:index]];
	[self.frames setObject:[NSNumber numberWithInt:index] forKey:[NSValue valueWithCGRect:[view frame]]];
}

-(CGRect)frameOf:(TheBoxUIScrollView *)scrollView atIndex:(NSUInteger)index
{
    CGRect bounds = [scrollView bounds];
    
    NSUInteger noOfColumns = [self.datasource numberOfViewsInGridView:self atIndex:index];
    
    if(noOfColumns == 0){
        return CGRectMake(bounds.origin.x, bounds.origin.y, 0.0f, scrollView.frame.size.height);
    }
    
    return CGRectMake(bounds.origin.x, index * [self.delegate whatRowHeight:self], scrollView.frame.size.width, [self.delegate whatRowHeight:self]);
}

#pragma mark TheBoxUIScrollViewDelegate

- (CGFloat)whatSize:(TheBoxUIScrollView *)scrollView 
{
    if(![scrollView isEqual:self.scrollView]){
        return [self.delegate whatCellWidth:self];    
    }
    
return [self.delegate whatRowHeight:self];
}

-(void)viewInScrollView:(TheBoxUIScrollView *)scrollView atIndex:(NSUInteger)index willAppear:(UIView *)view
{
    if(![scrollView isEqual:self.scrollView])
    {
        NSNumber* row = [self.frames objectForKey:[NSValue valueWithCGRect:[scrollView frame]]];
        
        [self.delegate viewInGridView:self inScrollView:scrollView atRow:[row intValue] atIndex:index willAppear:view];
    }
    
    [self.scrollViewDelegate viewInScrollView:scrollView atIndex:index willAppear:view];
}

#pragma mark TheBoxUIScrollViewDatasource

-(NSUInteger)numberOfViewsInScrollView:(TheBoxUIScrollView *)scrollView 
{
    if(![scrollView isEqual:self.scrollView])
    {
        NSNumber* index = [self.frames objectForKey:[NSValue valueWithCGRect:[scrollView frame]]];
        
    return [self.datasource numberOfViewsInGridView:self atIndex:[index intValue]];
    }

return [self.datasource numberOfViewsInGridView:self];    
}

-(UIView*)viewInScrollView:(TheBoxUIScrollView *)scrollView atIndex:(NSInteger)index
{
    if(![scrollView isEqual:self.scrollView])
    {
        NSNumber* row = [self.frames objectForKey:[NSValue valueWithCGRect:[scrollView frame]]];
        
        UIView* viewOf = [self.datasource viewInGridView:self inScrollView:scrollView atRow:[row intValue] atIndex:index];
        
    return viewOf;
    }

	NSLog(@"asking for row %d", index);
	
	TheBoxUIScrollView* view = (TheBoxUIScrollView*)[scrollView dequeueReusableView];
	
	CGRect frame = [self frameOf:scrollView atIndex:index];
    
    if (view == nil) 
	{		
		TheBoxUIScrollView *viewOf = [TheBoxUIScrollView 
                                      newHorizontalScrollView:frame 
                                      viewsOf:[self.delegate whatCellWidth:self]];
		
		viewOf.datasource = self;
		viewOf.scrollViewDelegate = self;
		view = viewOf;
	}
    else {
        view.frame = frame;
        [view setNeedsLayout];
    }
    
	NSLog(@"view %@", view);
    
	[self setView:view atIndex:index];
	
return view;
}

#pragma mark public
-(void)reload
{
    [self.scrollView setNeedsLayout];
}

-(void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated
{
    CGFloat y = index * [self whatSize:self.scrollView];
    
    [self.scrollView setContentOffset:CGPointMake(CGPointZero.x, y) animated:animated];
}

-(void)viewWasTapped:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer*)sender;
    CGPoint tapPoint = [tapGestureRecognizer locationInView:self.scrollView];
    NSLog(@"%@", NSStringFromCGPoint(tapPoint));
    NSLog(@"%@", NSStringFromCGSize(self.scrollView.contentSize));

    NSUInteger row = [self.scrollView indexOf:tapPoint];
    NSLog(@"%u", row);
    
    NSUInteger numberOfRows = [self numberOfViewsInScrollView:self.scrollView];
    
    if(row >= numberOfRows){
        return;
    }
    
    TheBoxUIScrollView* scrollView = (TheBoxUIScrollView*)[self viewAtRow:row];
    NSLog(@"contentSize %@", NSStringFromCGSize(scrollView.contentSize));	

    tapPoint = [tapGestureRecognizer locationInView:scrollView];
    NSUInteger index = [scrollView indexOf:tapPoint];
    NSLog(@"[%u, %u], %@, %@", row, index, scrollView, NSStringFromCGRect(scrollView.bounds));
    
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

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
{
    [self.scrollView addObserver:observer
                    forKeyPath:keyPath
                       options:options
                       context:context];    

}

@end
