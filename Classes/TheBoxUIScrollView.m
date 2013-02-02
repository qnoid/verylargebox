/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 07/02/10.
 *  Contributor(s): .-
 */
#import "TheBoxUIScrollView.h"
#import "TheBoxUIRecycleStrategy.h"
#import "TheBoxVisibleStrategy.h"
#import "TheBoxSize.h"

CGFloat const DEFAULT_HEIGHT = 196;

@interface TheBoxUIScrollView ()
@property(nonatomic, assign) BOOL needsLayout;
@property(nonatomic, strong) TheBoxUIRecycleStrategy *recycleStrategy;
@property(nonatomic, strong) id<VisibleStrategy> visibleStrategy;
/* Apparently a UIScrollView needs another view as its content view else it messes up the scrollers.
 * Interface Builder uses a private _contentView instead.
 */
@property(nonatomic, strong) UIView *contentView;

@property(nonatomic, strong) NSObject<TheBoxSize> *theBoxSize;
@property(nonatomic, strong) NSObject<TheBoxDimension> *dimension;
-(id)initWithFrame:(CGRect) frame size:(NSObject<TheBoxSize>*)size dimension:(NSObject<TheBoxDimension>*)dimension;
@end

@implementation TheBoxUIScrollView

+(TheBoxUIScrollView *) newScrollView:(CGRect)aFrame recycleStrategy:(TheBoxUIRecycleStrategy *)aRecycleStrategy visibleStrategy:(id<VisibleStrategy>) aVisibleStrategy size:(NSObject<TheBoxSize>*)size dimension:(NSObject<TheBoxDimension>*)dimension
{
	TheBoxUIScrollView *scrollView = [[TheBoxUIScrollView alloc] initWithFrame:aFrame size:size dimension:dimension];
	scrollView.recycleStrategy = aRecycleStrategy;
	scrollView.visibleStrategy = aVisibleStrategy;	
	scrollView.visibleStrategy.delegate = scrollView;	

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:scrollView action:@selector(didTapOnScrollView:)];
    [scrollView addGestureRecognizer:tapGestureRecognizer];

return scrollView;
}

@synthesize contentView;

+(TheBoxUIScrollView *) newVerticalScrollView:(CGRect)frame viewsOf:(CGFloat)height
{
	TheBoxVisibleStrategy *visibleStrategy = 
        [TheBoxVisibleStrategy newVisibleStrategyOnHeight:height];
	
	TheBoxUIRecycleStrategy *recycleStrategy = 
		[[TheBoxUIRecycleStrategy alloc] init];

	TheBoxUIScrollView *scrollView = 
		[TheBoxUIScrollView 
			newScrollView:frame
			recycleStrategy:recycleStrategy 
			visibleStrategy:visibleStrategy
            size:[[TheBoxSizeInHeight alloc] initWithSize:frame.size]
            dimension:[TheBoxHeight newHeight:height]];	

return scrollView;
}

+(TheBoxUIScrollView *) newHorizontalScrollView:(CGRect)frame viewsOf:(CGFloat)width
{
	TheBoxVisibleStrategy *visibleStrategy = 
        [TheBoxVisibleStrategy newVisibleStrategyOnWidth:width];
	
	TheBoxUIRecycleStrategy *recycleStrategy = 
        [[TheBoxUIRecycleStrategy alloc] init];
	
	TheBoxUIScrollView *scrollView = 
		[TheBoxUIScrollView 
		 newScrollView:frame
		 recycleStrategy:recycleStrategy 
		 visibleStrategy:visibleStrategy
         size:[[TheBoxSizeInWidth alloc] initWithSize:frame.size]
         dimension:[TheBoxWidth newWidth:width]];         
	
return scrollView;
}

#pragma mark private fields

-(id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    TheBoxUIScrollView* scrollView = [TheBoxUIScrollView newHorizontalScrollView:self.frame viewsOf:DEFAULT_HEIGHT];    
    scrollView.scrollsToTop = YES;
    
return scrollView;
}

-(void)awakeFromNib
{
    NSLog(@"%@", self);
    self.datasource = _datasource;
    self.scrollViewDelegate = _scrollViewDelegate;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnScrollView:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (id) initWithFrame:(CGRect) frame size:(NSObject<TheBoxSize>*)size dimension:(NSObject<TheBoxDimension>*)dimension
{
	self = [super initWithFrame:frame];
	if (self) 
	{
		self.theBoxSize = size;
        self.dimension = dimension;
		self.contentView = [[UIView alloc] initWithFrame:CGRectMake(CGPointZero.x, CGPointZero.y, frame.size.width, frame.size.height)];
        self.delegate = self;
		[self addSubview:self.contentView];
	}
return self;
}

-(void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    self.contentView.frame = CGRectMake(CGPointZero.x, CGPointZero.y, 
                                        self.contentSize.width, self.contentSize.height);    
}

-(void)recycleVisibleViewsWithinBounds:(CGRect)bounds {
	[self.recycleStrategy recycle:[self.visibleStrategy.visibleViews allObjects] bounds:bounds];		
}

-(void)removeRecycledFromVisibleViews {
	[self.visibleStrategy.visibleViews minusSet:self.recycleStrategy.recycledViews];	
}

/**
 * The Visible strategy uses TheBoxDimension which will ceilf the bounds as to catch any partially visible cells.
 * However, reaching at the edge of the scrollview, will cause the bounds to include the "bouncing" part of the view which 
 * shouldn't be taken into account as something partially visible. Therefore need to keep the width at a maximum.
 *
 * Visible bounds should be at maximum the original width and height
 *
 * @see TheBoxDimension#maximumVisible:
 */
-(void)displayViewsWithinBounds:(CGRect)bounds
{
  [self.visibleStrategy layoutSubviews:bounds];
}

/** Called whenever the scroll view is scrolled.
  
 http://stackoverflow.com/questions/2760309/uiscrollview-calls-layoutsubviews-each-time-its-scrolled
 
 Calculates the content size.
 Recycles any visible views within its bounds
 Removes any non visible views
 Shows views within bounds
 */
-(void) layoutSubviews
{
    NSUInteger numberOfViews = [self.datasource numberOfViewsInScrollView:self];
    if(numberOfViews == 0){
        return;
    }
    
	[self.visibleStrategy minimumVisibleIndexShould:ceilVisibleIndexAt(0)];
	[self.visibleStrategy maximumVisibleIndexShould:floorVisibleIndexAt(numberOfViews)];
    self.contentSize = [self.theBoxSize sizeOf:numberOfViews size:self.dimension.value];
	
    NSLog(@"%s", __PRETTY_FUNCTION__);
	NSLog(@"frame %@", NSStringFromCGRect(self.frame));	
	NSLog(@"contentSize %@", NSStringFromCGSize(self.contentSize));	

    CGRect bounds = [self bounds];
    NSLog(@"layoutSubviews on bounds %@", NSStringFromCGRect(bounds));

	[self recycleVisibleViewsWithinBounds:bounds];
	[self removeRecycledFromVisibleViews];
	[self displayViewsWithinBounds:bounds];

    if(self.needsLayout){
        [self.scrollViewDelegate didLayoutSubviews:self];
        self.needsLayout = NO;
    }
}

-(void)setNeedsLayout
{
    [super setNeedsLayout];
    self.needsLayout = YES;
    NSArray* subviews = [self.contentView subviews];
    
    [self.recycleStrategy recycle:subviews];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    TheBoxVisibleStrategy *aVisibleStrategy = 
        [TheBoxVisibleStrategy newVisibleStrategyFrom:self.visibleStrategy];
	
	aVisibleStrategy.delegate = self;
	
	self.visibleStrategy = aVisibleStrategy;
}

-(UIView *)viewWithTag:(NSInteger)tag {
return [self.contentView viewWithTag:tag];
}

-(NSArray *)subviews{
return [self.contentView subviews];
}

/*
 * No need to remove dequeued view from superview since it's removed when recycled
 */
-(UIView*)dequeueReusableView {
    return [self.recycleStrategy dequeueReusableView];
}

-(NSUInteger)indexOf:(CGPoint)point {
    return [self.dimension floorIndexOf:point];
}

-(void)viewsShouldBeVisibleBetween:(NSUInteger)minimumVisibleIndex to:(NSUInteger)maximumVisibleIndex
{
    [self.scrollViewDelegate viewInScrollView:self willAppearBetween:minimumVisibleIndex to:maximumVisibleIndex];
}

-(UIView *)shouldBeVisible:(int)index
{
    CGRect frame = [self.dimension frameOf:self.bounds atIndex:index];
    
    UIView* view = [self dequeueReusableView];
    view.frame = frame;

    if(view == nil){
        view = [self.datasource viewInScrollView:self ofFrame:frame atIndex:index];
    }
    else 
    {
        /* This is really required due to TheBoxUIGridView design and not mandated by UIKit.
         TheBoxUIGridView currently uses TheBoxUIScrollView for its rows, hence when a view
         is dequeued it needs to have its subviews removed and recycled fo reuse.
         
         This behavior should really be on TheBoxUIGridView, as a result of 
         a view being dequeued.
         */
        [view setNeedsLayout];        
    }
    
    [self.scrollViewDelegate viewInScrollView:self willAppear:view atIndex:index];
    
	/*
	 * Adding subviews to self places them side by side which
	 * causes scrollers to appear and disappear as if overlapping.
	 * Thus another scrollview is used as an mediator.
	 */	
	[self.contentView addSubview:view];
    
    NSLog(@"added %@ as subview to %@", view, self);
return view;
}

-(void)didTapOnScrollView:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer*)sender;
    CGPoint tapPoint = [tapGestureRecognizer locationInView:self];
    NSUInteger index = [self indexOf:tapPoint];
    NSLog(@"%u", index);
    
    NSUInteger numberOfViews = [self.datasource numberOfViewsInScrollView:self];
    
    if(index >= numberOfViews){
        return;
    }
    
    [self.scrollViewDelegate didSelectView:self atIndex:index];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self.dimension moveCloserToWhole:targetContentOffset];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.scrollViewDelegate scrollView:scrollView willStopAt:[self indexOf:scrollView.bounds.origin]];
}

@end
