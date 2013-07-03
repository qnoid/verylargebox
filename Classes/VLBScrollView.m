//
//  Copyright 2010 The Box
//  All rights reserved.
//
//  This file is part of TheBox
//
//  Created by Markos Charatzas on 07/02/10.
//
//

#import "VLBScrollView.h"
#import "VLBRecycleStrategy.h"
#import "VLBVisibleStrategy.h"
#import "VLBSize.h"
#import <QuartzCore/QuartzCore.h>
#import "DDLog.h"
#import "VLBMacros.h"

CGFloat const DEFAULT_HEIGHT = 196;

@interface VLBScrollView ()
@property(nonatomic, assign) BOOL needsLayout;
@property(nonatomic, strong) VLBRecycleStrategy *recycleStrategy;
@property(nonatomic, strong) id<VLBVisibleStrategy> visibleStrategy;
/* Apparently a UIScrollView needs another view as its content view else it messes up the scrollers.
 * Interface Builder uses a private _contentView instead.
 */
@property(nonatomic, strong) UIView *contentView;

@property(nonatomic, strong) NSObject<VLBSize> *theBoxSize;
@property(nonatomic, strong) NSObject<VLBDimension> *dimension;
-(id)initWithFrame:(CGRect) frame size:(NSObject<VLBSize>*)size dimension:(NSObject<VLBDimension>*)dimension;
-(void)didTapOnScrollView:(id)sender;
@end

VLBScrollViewConfig const VLBUIScrollViewConfigEmpty = ^(VLBScrollView *scrollView, BOOL cancelsTouchesInView){};

VLBScrollViewConfig const VLBScrollViewAllowSelection = ^(VLBScrollView *scrollView, BOOL cancelsTouchesInView)
{
    UITapGestureRecognizer *tapGestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:scrollView action:@selector(didTapOnScrollView:)];
    
    tapGestureRecognizer.cancelsTouchesInView = cancelsTouchesInView;
    [scrollView addGestureRecognizer:tapGestureRecognizer];
};

@implementation VLBScrollView

+(VLBScrollView *) newScrollView:(CGRect)aFrame recycleStrategy:(VLBRecycleStrategy *)aRecycleStrategy visibleStrategy:(id<VLBVisibleStrategy>) aVisibleStrategy size:(NSObject<VLBSize>*)size dimension:(NSObject<VLBDimension>*)dimension
{
	VLBScrollView *scrollView = [[VLBScrollView alloc] initWithFrame:aFrame size:size dimension:dimension];
	scrollView.recycleStrategy = aRecycleStrategy;
	scrollView.visibleStrategy = aVisibleStrategy;	
	scrollView.visibleStrategy.delegate = scrollView;
    scrollView.scrollsToTop = NO;
    
return scrollView;
}

@synthesize contentView;

+(VLBScrollView *) newVerticalScrollView:(CGRect)frame viewsOf:(CGFloat)height
{
	VLBVisibleStrategy *visibleStrategy =
        [VLBVisibleStrategy newVisibleStrategyOnHeight:height];
	
	VLBRecycleStrategy *recycleStrategy =
		[[VLBRecycleStrategy alloc] init];

	VLBScrollView *scrollView =
		[VLBScrollView
			newScrollView:frame
			recycleStrategy:recycleStrategy 
			visibleStrategy:visibleStrategy
            size:[[VLBSizeInHeight alloc] initWithSize:frame.size]
            dimension:[VLBHeight newHeight:height]];

return scrollView;
}

+(VLBScrollView *) newHorizontalScrollView:(CGRect)frame viewsOf:(CGFloat)width
{
	VLBVisibleStrategy *visibleStrategy =
        [VLBVisibleStrategy newVisibleStrategyOnWidth:width];
	
	VLBRecycleStrategy *recycleStrategy =
        [[VLBRecycleStrategy alloc] init];
	
	VLBScrollView *scrollView =
		[VLBScrollView
		 newScrollView:frame
		 recycleStrategy:recycleStrategy 
		 visibleStrategy:visibleStrategy
         size:[[VLBSizeInWidth alloc] initWithSize:frame.size]
         dimension:[VLBWidth newWidth:width]];
	
return scrollView;
}

#pragma mark private fields

-(id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    VLBScrollView * scrollView = [VLBScrollView newHorizontalScrollView:self.frame viewsOf:DEFAULT_HEIGHT];
    scrollView.scrollsToTop = YES;
    
return scrollView;
}

-(void)awakeFromNib
{
    DDLogVerbose(@"%@", self);
    self.datasource = _datasource;
    self.scrollViewDelegate = _scrollViewDelegate;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnScrollView:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (id) initWithFrame:(CGRect) frame size:(NSObject<VLBSize>*)size dimension:(NSObject<VLBDimension>*)dimension
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

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    VLB_IF_NOT_SELF_RETURN_NIL();
    VLB_LOAD_VIEW();

    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(CGPointZero.x, CGPointZero.y, self.frame.size.width, self.frame.size.height)];
    self.delegate = self;
    [self addSubview:self.contentView];

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
 * The Visible strategy uses VLBDimension which will ceilf the bounds as to catch any partially visible cells.
 * However, reaching at the edge of the scrollview, will cause the bounds to include the "bouncing" part of the view which 
 * shouldn't be taken into account as something partially visible. Therefore need to keep the width at a maximum.
 *
 * Visible bounds should be at maximum the original width and height
 *
 * @see VLBDimension#maximumVisible:
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
	
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
	DDLogVerbose(@"frame %@", NSStringFromCGRect(self.frame));	
	DDLogVerbose(@"contentSize %@", NSStringFromCGSize(self.contentSize));	

    CGRect bounds = [self bounds];
    DDLogVerbose(@"layoutSubviews on bounds %@", NSStringFromCGRect(bounds));
    
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

    VLBVisibleStrategy *aVisibleStrategy =
        [VLBVisibleStrategy newVisibleStrategyFrom:self.visibleStrategy];
	
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
        /* This is really required due to VLBGridView design and not mandated by UIKit.
         VLBGridView currently uses VLBScrollView for its rows, hence when a view
         is dequeued it needs to have its subviews removed and recycled fo reuse.
         
         This behavior should really be on VLBGridView, as a result of
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
    
    DDLogVerbose(@"added %@ as subview to %@", view, self);
return view;
}

-(void)didTapOnScrollView:(id)sender
{
    DDLogVerbose(@"%s", __PRETTY_FUNCTION__);
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer*)sender;
    CGPoint locationInView = [tapGestureRecognizer locationInView:self];
    NSUInteger index = [self indexOf:locationInView];
    DDLogVerbose(@"%u", index);
    
    NSUInteger numberOfViews = [self.datasource numberOfViewsInScrollView:self];
    
    if(index >= numberOfViews){
        return;
    }
    
    CGPoint point = [self.dimension pointOf:index offset:self.contentInset];
        
    [self.scrollViewDelegate didSelectView:self atIndex:index point:point];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if(!self.isSeekingEnabled){
        return;
    }

    [self.dimension moveCloserToWhole:targetContentOffset offset:self.contentInset];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = CGPointMake(scrollView.bounds.origin.x + self.contentInset.left,
                                scrollView.bounds.origin.y + self.contentInset.top);
    
    [self.scrollViewDelegate scrollView:scrollView willStopAt:[self indexOf:point]];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGPoint point = CGPointMake(scrollView.bounds.origin.x + self.contentInset.left,
                                scrollView.bounds.origin.y + self.contentInset.top);
    

    [self.scrollViewDelegate scrollView:scrollView willStopAt:[self indexOf:point]];
}

@end

@interface VLBScrollViewBuilder ()
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGFloat dimension;
@property (nonatomic, assign) BOOL enableSelection;
@property (nonatomic, assign) BOOL cancelContentTouches;
@end

@implementation VLBScrollViewBuilder

- (id)initWith:(CGRect)frame viewsOf:(CGFloat)dimension
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.frame = frame;
    self.dimension = dimension;

return self;
}

-(VLBScrollViewBuilder *)allowSelection
{
    self.enableSelection = YES;
    
return self;
}

-(VLBScrollViewBuilder *)canCancelContentTouches
{
    self.cancelContentTouches = YES;
    
    return self;
}

-(VLBScrollView *) newVerticalScrollView
{
    VLBScrollView * scrollView =
        [VLBScrollView newVerticalScrollView:self.frame viewsOf:self.dimension];
    
    if(self.enableSelection){
        VLBScrollViewAllowSelection(scrollView, self.cancelContentTouches);
    }
    
    scrollView.canCancelContentTouches = self.cancelContentTouches;
    
return scrollView;
}

-(VLBScrollView *) newHorizontalScrollView
{
    VLBScrollView * scrollView =
        [VLBScrollView newHorizontalScrollView:self.frame viewsOf:self.dimension];

    if(self.enableSelection){
        VLBScrollViewAllowSelection(scrollView, self.cancelContentTouches);
    }
    
    scrollView.canCancelContentTouches = self.cancelContentTouches;
    
return scrollView;
}

@end

