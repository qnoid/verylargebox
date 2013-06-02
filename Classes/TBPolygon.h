/*
 *  Copyright 2013 TheBox
 *  All rights reserved.
 *
 *  This file is part of thebox
 *
 *  Created by Markos Charatzas (___twitter___) 31/05/2013.
 *  Contributor(s): .-
 */
 #import <Foundation/Foundation.h>

typedef void(^TBPolygonAngleCollector)(int index, CGPoint angle);

/**

 The polygon will cache both its angleInRadians and exteriorAngleInRadians.
 
 @ThreadSafe
*/
@interface TBPolygon : NSObject

@property(nonatomic, readonly) NSUInteger numberOfAngles;
@property(nonatomic, readonly) CGPoint center;

+(instancetype)hexagonAt:(CGPoint)center;
+(instancetype)squareAt:(CGPoint)center;
+(instancetype)triangleAt:(CGPoint)center;
+(instancetype)of:(NSUInteger)numberOfAngles at:(CGPoint)center;

-(float)angleInRadians;

-(float)exteriorAngleInRadians;

-(void)rotateAt:(float)zeroToOne collect:(TBPolygonAngleCollector)angleCollector;

@end
