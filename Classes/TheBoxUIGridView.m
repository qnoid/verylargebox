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

@interface TheBoxUIGridView () <TheBoxUIScrollViewDatasource, TheBoxUIScrollViewDelegate>
@property(nonatomic, strong) NSMutableDictionary* frames;
@property(nonatomic, strong) NSMutableDictionary* views;
@property(nonatomic, strong) TheBoxUIScrollView *scrollView;

- (UIView *)gridView:(TheBoxUIGridView *)gridView viewOf:(UIView *)view ofFrame:(CGRect)frame atIndex:(NSInteger)index;
-(UIView*)viewAtRow:(NSUInteger)row;
-(void)setView:(UIView*)view atIndex:(NSUInteger)index;
@end


@implementation TheBoxUIGridView

#pragma mark private fields

@synthesize frames = _frames;
@synthesize views;
@synthesize datasource;
@synthesize delegate;
@synthesize scrollView = _scrollView;

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
    newVerticalScrollView.showsVerticalScrollIndicator = NO;
    newVerticalScrollView.scrollsToTop = YES;
    
    self.scrollView = newVerticalScrollView;
    [self addSubview:self.scrollView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped:)];
    [self.scrollView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark private

- (UIView *)gridView:(TheBoxUIGridView *)gridView viewOf:(UIView *)view ofFrame:(CGRect)frame atIndex:(NSInteger)index 
{
    NSUInteger row = [[self.frames objectForKey:[NSValue valueWithCGRect:[view frame]]] unsignedIntegerValue];
    
    NSLog(@"asking for column %d at row %d", index, row);

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

- (CGFloat)whatSize:(TheBoxUIScrollView *)scrollView 
{
    if(![scrollView isEqual:self.scrollView]){
        return [self.delegate whatCellWidth:self];    
    }
    
return [self.delegate whatRowHeight:self];
}

- (void)viewInScrollView:(TheBoxUIScrollView *)scrollView willAppear:(UIView *)view atIndex:(NSUInteger)index 
{
    if(![scrollView isEqual:self.scrollView])
    {
        NSUInteger row = [[self.frames objectForKey:[NSValue valueWithCGRect:[scrollView frame]]] unsignedIntegerValue];
        
        [self.delegate gridView:self viewOf:scrollView atRow:row atIndex:index willAppear:view];
    return;
    }    
    
    [self setView:view atIndex:index];
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

- (UIView *)viewInScrollView:(TheBoxUIScrollView *)scrollView ofFrame:(CGRect)frame atIndex:(NSInteger)index 
{
    if(![scrollView isEqual:self.scrollView]) {        
    return [self gridView:self viewOf:scrollView ofFrame:frame atIndex:index];
    }

	NSLog(@"asking for row %d", index);
	
    TheBoxUIScrollView *view = [TheBoxUIScrollView 
                                  newHorizontalScrollView:frame
                                  viewsOf:[self.delegate whatCellWidth:self]];		
    view.datasource = self;
    view.scrollViewDelegate = self;
    view.scrollsToTop = NO;
        
	NSLog(@"view %@", view);
    
return view;
}

-(UIView *)headerInScrollView:(TheBoxUIScrollView *)scrollView
{
    if([scrollView isEqual:self.scrollView]){
        return nil;
    }
    
    NSNumber* index = [self.frames objectForKey:[NSValue valueWithCGRect:[scrollView frame]]];
        
return [self.delegate gridView:self headerOf:scrollView atIndex:[index intValue]];
}

#pragma mark public
-(void)reload
{
    [self.scrollView setNeedsLayout];
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
    
    UIView<CanIndexLocationInView>* view = (UIView<CanIndexLocationInView>*)[self viewAtRow:row];

    tapPoint = [tapGestureRecognizer locationInView:view];
    NSUInteger index = [view indexOf:tapPoint];
    NSLog(@"[%u, %u], %@, %@", row, index, view, NSStringFromCGRect(view.bounds));
    
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

@implementation FooView

@synthesize header;
@synthesize contentView;

-(UIView *)dequeueReusableView{
return [self.contentView dequeueReusableView];
}

-(void)setNeedsLayout{
    [self.contentView setNeedsLayout];
}

@end
