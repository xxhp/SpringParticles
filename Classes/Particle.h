//
//  Particle.h
//  SpringParticles
//
//  Created by Aitor Fernández on 21/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Particle : CCNode
{
  CGPoint mtPos;
  CGPoint mtVel;
  CGPoint mtAcc;
  
  CGFloat mtDamping;
  
  CCSprite *mtSprite;
}

+ (id) particleWithPositionAndVelocity: (CGPoint)aPos vel: (CGPoint)aVel;
- (id) initWithPositionAndVelocity: (CGPoint)aPos vel: (CGPoint)aVel;

- (void) resetForce;

- (void) addDampingForce;
- (void) addForce: (CGPoint)aForce;


@end
