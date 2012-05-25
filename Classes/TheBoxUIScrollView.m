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
-(id)initWithFrame:(CGRect) frame size:(NSObject<TheBoxSize>*)size dimension:(NSObject<TheBoxDimension>*)dimension;

@property(nonatomic, strong) TheBoxUIRecycleStrategy *recycleStrategy;
@property(nonatomic, strong) id<VisibleStrategy> visibleStrategy;
/* Apparently a UIScrollView needs another view as its content view else it messes up the scrollers.
 * Interface Builder uses a private _contentView instead.
 */
@property(nonatomic, strong) UIView *contentView;

@property(nonatomic, strong) NSObject<TheBoxSize> *theBoxSize;
@property(nonatomic, strong) NSObject<TheBoxDimension> *dimension;
@end

@implementation TheBoxUIScrollView

+(TheBoxUIScrollView *) newScrollView:(CGRect)aFrame recycleStrategy:(TheBoxUIRecycleStrategy *)aRecycleStrategy visibleStrategy:(id<VisibleStrategy>) aVisibleStrategy size:(NSObject<TheBoxSize>*)size dimension:(NSObject<TheBoxDimension>*)dimension
{
	TheBoxUIScrollView *scrollView = [[TheBoxUIScrollView alloc] initWithFrame:aFrame size:size dimension:dimension];
	scrollView.recycleStrategy = aRecycleStrategy;
	scrollView.visibleStrategy = aVisibleStrategy;	
	scrollView.visibleStrategy.delegate = scrollView;	
	scrollView.clipsToBounds = NO;
    
return scrollView;
}

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

@synthesize datasource;
@synthesize scrollViewDelegate;
@synthesize theBoxSize;
@synthesize dimension = _dimension;
@synthesize contentView;
@synthesize recycleStrategy;
@synthesize visibleStrategy;

#pragma mark private fields

-(id)awakeAfterUsingCoder:(NSCoder *)aDecoder 
{    
    TheBoxUIScrollView* scrollView = [TheBoxUIScrollView newVerticalScrollView:self.frame viewsOf:DEFAULT_HEIGHT];
    
    //http://stackoverflow.com/questions/10264790/what-is-the-new-pattern-for-releasing-self-with-automatic-reference-counting
    CFRelease((__bridge const void*)self);
    
    CFRetain((__bridge const void*)scrollView);

return scrollView;
}

-(void)awakeFromNib
{
    NSLog(@"%@", self);
    self.datasource = datasource;
    self.scrollViewDelegate = scrollViewDelegate;
}

- (id) initWithFrame:(CGRect) frame size:(NSObject<TheBoxSize>*)size dimension:(NSObject<TheBoxDimension>*)dimension
{
	self = [super initWithFrame:frame];
	if (self) 
	{
		self.theBoxSize = size;
        self.dimension = dimension;
		self.contentView = [[UIView alloc] initWithFrame:CGRectMake(CGPointZero.x, CGPointZero.y, frame.size.width, frame.size.height)];
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
}

-(void)setNeedsLayout
{
    [super setNeedsLayout];
    NSArray* subviews = [self.contentView subviews];
    
    [self.recycleStrategy recycle:subviews];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    TheBoxVisibleStrategy *aVisibleStrategy = 
        [TheBoxVisibleStrategy newVisibleStrategyFrom:self.visibleStrategy];
	
	aVisibleStrategy.delegate = self;
	
	self.visibleStrategy = aVisibleStrategy;
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

-(UIView *)shouldBeVisible:(int)index
{
    CGRect frame = [self.dimension frameOf:self.bounds atIndex:index];
    
    UIView* view = [self dequeueReusableView];
    
    if(view == nil){
        view = [self.datasource viewInScrollView:self ofFrame:frame atIndex:index];
    }
    else {
        view.frame = frame;
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

@end
