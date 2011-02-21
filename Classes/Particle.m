//
//  Particle.m
//  SpringParticles
//
//  Created by Aitor Fernández on 21/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Particle.h"

#import "Utils.h"


@implementation Particle

+ (id) particleWithPositionAndVelocity: (CGPoint)aPos vel: (CGPoint)aVel
{
  return [[[self alloc] initWithPositionAndVelocity: aPos vel: aVel] autorelease];
}

- (id) initWithPositionAndVelocity: (CGPoint)aPos vel: (CGPoint)aVel
{
  if (!(self = [super init]))
    return nil;
  
  
  // Init values
  mtPos = aPos;
  mtVel = aVel;
  
  mtDamping = CCRANDOM_0_1();
    
  mtSprite = [CCSprite spriteWithFile: @"Icon-Small-50.png"];
  
  mtSprite.position = spRandomScreen();
  
  [self addChild: mtSprite];
  
  // Sprite size
  mtSprite.scale = spRandomBetween(0.5f, 1.0f);
    
  
  return self;
}

- (void) resetForce
{
  // We reset the forces every frame
  mtAcc = CGPointZero;
}

- (void) dealloc
{
  [mtSprite release];
  
  [super dealloc];
}

@end
