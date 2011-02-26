//
//  Spring.h
//  SpringParticles
//
//  Created by Aitor Fernández on 26/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Particle.h"


@interface Spring : CCNode
{
  Particle *mtpParticleA;
  Particle *mtpParticleB;
  
  CGFloat mtDistance;
  
  // Springiness constant
  CGFloat mtSpringiness;
}

@property (retain) Particle *particleA;
@property (retain) Particle *particleB;

@property (readwrite) CGFloat distance;
@property (readwrite) CGFloat springiness;


- (id) init;

- (void) update;
- (void) draw;

@end
