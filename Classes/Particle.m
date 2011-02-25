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

- (void) addDampingForce
{
  mtAcc = ccpMult(ccpSub(mtAcc, mtVel), mtDamping);
}

- (void) addForce: (CGPoint)aForce
{
  mtAcc = ccpAdd(mtAcc, aForce);
}

- (void) addRepulsionForce: (Particle *)apParticle radius: (CGFloat)aRadius scale: (CGFloat)aScale
{
  // Make a vector of where this particle apParticle is
  
  CGPoint posOfForce = [apParticle position];
	
	// Calculate the difference & length 
	
  CGPoint diff = ccpSub(mtPos, posOfForce);
  CGFloat length = ccpLengthSQ(diff);
	
	// Check close enough
	
	BOOL bAmCloseEnough = YES;
  
  if (aRadius > 0)
  {
    if (length > aRadius)
    {
      bAmCloseEnough = NO;
    }
  }
	
	// If so, update force
  
	if (bAmCloseEnough == true)
  {
    // Stronger on the inside
		CGFloat pct = 1 - (length / aRadius);
    
    diff = ccpNormalize(diff);
    
    mtAcc = ccpMult(ccpMult(ccpAdd(mtAcc, diff), aScale), pct);
    
    apParticle->mtAcc = ccpMult(ccpMult(ccpAdd(apParticle->mtAcc, diff), aScale), pct);
  }
}

- (void) update
{
  mtVel = ccpAdd(mtVel, mtAcc);
  mtPos = ccpAdd(mtPos, ccpMult(mtVel, 5.0f));
  
  // Wrap
  if (mtPos.x < 0)
    mtPos.x = CC_WINSIZE().width;

  if (mtPos.x > CC_WINSIZE().width)
    mtPos.x = 0;

  if (mtPos.y < 0)
    mtPos.y = CC_WINSIZE().height;

  if (mtPos.y > CC_WINSIZE().height)
    mtPos.y = 0;
  
  
  // Update sprite
  mtSprite.position = mtPos;
}


- (void) dealloc
{
  [mtSprite release];
  
  [super dealloc];
}

@end
