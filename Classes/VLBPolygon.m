//
//  Copyright 2013 TheBox
//  All rights reserved.
//
//  This file is part of thebox
//
//  Created by Markos Charatzas on 31/05/2013.
//
//

#import "VLBPolygon.h"
#import "VLBMacros.h"

@interface VLBPolygon ()
@property(nonatomic, assign) NSUInteger numberOfAngles;
@property(nonatomic, assign) CGPoint center;
@property(nonatomic, assign) float angleInRadians;
@property(nonatomic, assign) float exteriorAngleInRadians;
@end

/**
 There are chances that angleInRadians and exteriorAngleInRadians will be initialised more than once depending on
 thread interleaving. This is by design.
*/
@implementation VLBPolygon

+(instancetype)hexagonAt:(CGPoint)center {
return [self of:6 at:center];
}

+(instancetype)squareAt:(CGPoint)center {
    return [self of:4 at:center];
}

+(instancetype)triangleAt:(CGPoint)center {
    return [self of:3 at:center];
}

+(instancetype)of:(NSUInteger)numberOfAngles at:(CGPoint)center
{
    DDLogVerbose(@"numberOfAngles: %@", @(numberOfAngles));
    DDLogVerbose(@"center: %@", NSStringFromCGPoint(center));
    
return [[VLBPolygon alloc] initWithNumberOfAngles:numberOfAngles center:center];
}

-(id)initWithNumberOfAngles:(NSUInteger)numberOfAngles center:(CGPoint)center
{
    VLB_INIT_OR_RETURN_NIL()
    
    self.numberOfAngles = numberOfAngles;
    self.center = center;
    
return self;
}

-(float)angleInRadians
{
    if(_angleInRadians == 0.0){
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _angleInRadians = (2.0 * M_PI) / self.numberOfAngles;
            DDLogVerbose(@"angle: %f", _angleInRadians);
        });
    }
    
return _angleInRadians;
}

-(float)exteriorAngleInRadians
{
    if(_exteriorAngleInRadians == 0.0){
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _exteriorAngleInRadians = M_PI - self.angleInRadians;
        DDLogVerbose(@"exterior angle: %f", _exteriorAngleInRadians);
        });
    }

return _exteriorAngleInRadians;
}

-(void)rotateAt:(float)zeroToOne collect:(VLBPolygonAngleCollector)angleCollector
{
    float rotation = self.angleInRadians - (zeroToOne * self.exteriorAngleInRadians);
    DDLogVerbose(@"rotation: %f", rotation);

    float scale = 1.0;
    float distance = scale * self.center.x;
    DDLogVerbose(@"distance: %f", distance);
    
    for(int index = 0; index < self.numberOfAngles; index++)
    {
        float rotatedAngle = (self.angleInRadians * index) - rotation;
        
        float x = distance * cos(rotatedAngle);
        float y = distance * sin(rotatedAngle);
        
        CGPoint p =  CGPointMake(self.center.x + x, self.center.y + y);        
        DDLogVerbose(@"rotatedAngle %f: %@", rotatedAngle , NSStringFromCGPoint(p));
        angleCollector(index, p);
    }
}

-(NSUInteger)hash
{
    NSUInteger hash = 17;
    hash = 31 * hash + self.numberOfAngles;
    hash = 31 * hash + self.center.x;
    hash = 31 * hash + self.center.y;
    
return hash;
}

-(BOOL)isEqual:(id)that
{
    if (self == that) {
        return YES;
    }
    
    if(![that isKindOfClass:[VLBPolygon class]]){
        return NO;
    }
    
    VLBPolygon *polygon = that;
    
return self.numberOfAngles == polygon.numberOfAngles && CGPointEqualToPoint(self.center, polygon.center);
}
@end
