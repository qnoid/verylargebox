/*
 *  Copyright 2010 The Box
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid) on 23/11/10.
 *  Contributor(s): .-
 */
#import "VLBGridViewController.h"

@interface VLBGridViewController ()

@property(nonatomic) id<VLBGridViewDatasource> datasource;
@end

static const CGFloat DEFAULT_ROW_HEIGHT = 196.0;
static const CGFloat DEFAULT_CELL_WIDTH = 160.0;

@implementation VLBGridViewController

@synthesize datasource;
@synthesize rowHeight;
@synthesize cellWidth;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self) 
	{
        self.rowHeight = DEFAULT_ROW_HEIGHT;
        self.cellWidth = DEFAULT_CELL_WIDTH;
	}
    return self;
}

-(UIView*)viewInGridView:(VLBGridView *)gridView didLoad:(UIScrollView *)scrollView atRow:(NSInteger)row {
    return scrollView;   
}

- (UIView *)gridView:(VLBGridView *)gridView viewOf:(UIView *)view ofFrame:(CGRect)frame atRow:(NSUInteger)row atIndex:(NSUInteger)index {
return [[UIView alloc] initWithFrame:frame];
}

-(void)gridView:(VLBGridView *)gridView atIndex:(NSInteger)index willAppear:(UIView *)view{
    
}

-(void)gridView:(VLBGridView *)gridView viewOf:(UIView *)viewOf atRow:(NSInteger)row atIndex:(NSInteger)index willAppear:(UIView*)view
{
}

-(CGSize)marginOf:(VLBScrollView *)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index {
return CGSizeMake(0.0, 0.0);
}

-(void)didSelect:(VLBScrollView *)scrollView atRow:(NSInteger)row atIndex:(NSInteger)index{
    
}

-(NSUInteger)numberOfViewsInGridView:(VLBGridView *)gridView{
    return 0;
}

-(NSUInteger)numberOfViewsInGridView:(VLBGridView *)scrollView atIndex:(NSInteger)index{
    return 0;
}

-(CGFloat)whatRowHeight:(VLBGridView *)gridView{
    return self.rowHeight;
}

-(CGFloat)whatCellWidth:(VLBGridView *)gridView{
    return self.cellWidth;
}

-(UIView *)gridView:(VLBGridView *)gridView headerOf:(UIView *)view atIndex:(NSInteger)index {
    return nil;
}

@end
