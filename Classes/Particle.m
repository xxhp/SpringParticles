//
//  Particle.m
//  SpringParticles
//
//  Created by Aitor Fernández on 21/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Particle.h"


@implementation Particle

@synthesize pos = mtPos, fixed = mtIsFixed, spring = mtIsSpring;


+ (id) particleWithPositionAndVelocity: (CGPoint)aPos vel: (CGPoint)aVel
{
  return [[[self alloc] initWithPositionAndVelocity: aPos vel: aVel] autorelease];
}

- (id) initWithPositionAndVelocity: (CGPoint)aPos vel: (CGPoint)aVel
{
  if (!(self = [super init]))
    return nil;
  
  
  // Init values
  mtIsFixed = NO;
  mtIsSpring = NO;
  
  mtPos = aPos;
  mtVel = aVel;
  
  mtDamping = CCRANDOM_0_1();
  
  
  // Temp values for init particle
  NSString *currentName = [NSString stringWithFormat: @"circle%i", (int)spRandomBetween(1, 4)];
  CGPoint currentPos = spRandomScreen(); 
  CGFloat currentScale = spRandomBetween(0.5f, 1.0f);
  
  // Sprite
  mtSprite = [CCAlphaSprite spriteWithFile: [NSString stringWithFormat: @"%@.png", currentName]];
  
  mtSprite.position = currentPos;
  mtSprite.scale = currentScale;
  
  [self addChild: mtSprite z: 2];
  
  // Sprite glow
  mtSpriteGlow = [CCAlphaSprite spriteWithFile: [NSString stringWithFormat: @"%@glow.png", currentName]];
  
  mtSpriteGlow.position = currentPos;
  mtSpriteGlow.scale = currentScale;
  
  [self addChild: mtSpriteGlow z: 1];
  
  [mtSpriteGlow runAction: [CCRepeatForever actionWithAction: [CCSequence actions: 
                                                               [CCFadeTo actionWithDuration: spRandomBetween(1.25f, 8.0f) opacity: 255],
                                                               [CCFadeTo actionWithDuration: spRandomBetween(1.0f, 5.0f) opacity: 0],
                                                               nil]]];
  
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
  CGFloat length = ccpLength(diff);
	
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
  if (mtIsFixed == YES)
    return;
  
    
  mtVel = ccpAdd(mtVel, mtAcc);
  mtPos = ccpAdd(mtPos, ccpMult(mtVel, 5.0f));
  
  if (mtIsSpring == NO)
  {
    // Wrap
    if (mtPos.x < 0)
      mtPos.x = CC_WINSIZE().width;

    if (mtPos.x > CC_WINSIZE().width)
      mtPos.x = 0;

    if (mtPos.y < 0)
      mtPos.y = CC_WINSIZE().height;
    
    if (mtPos.y > CC_WINSIZE().height)
      mtPos.y = 0;
  }
  
  
  // Update sprite and glow
  mtSpriteGlow.position = mtSprite.position = mtPos;
}


- (void) dealloc
{
  [mtSprite release];
  [mtSpriteGlow release];
  
  [super dealloc];
}

@end
