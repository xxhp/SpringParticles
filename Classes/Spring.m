//
//  Spring.m
//  SpringParticles
//
//  Created by Aitor Fernández on 26/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Spring.h"


@implementation Spring

@synthesize particleA = mtpParticleA, particleB = mtpParticleB, distance = mtDistance, springiness = mtSpringiness;


- (id) init
{
  if (!(self = [super init]))
    return nil;
  
  mtpParticleA = NULL;
  mtpParticleB = NULL;
  
  
  return self;
}

- (void) update
{
  if ((mtpParticleA == NULL) || (mtpParticleB == NULL))
    return;
  
  
  CGPoint pPosA = [mtpParticleA pos];
  CGPoint pPosB = [mtpParticleB pos];
  
  CGFloat theirDistance = ccpLength(ccpSub(pPosA, pPosB));
	CGFloat springForce = (mtSpringiness * (mtDistance - theirDistance));
  
  CGPoint frcToAdd = ccpMult(ccpNormalize(ccpSub(pPosA, pPosB)), springForce);
  
  [mtpParticleA addForce: frcToAdd];
  [mtpParticleB addForce: ccpNeg(frcToAdd)];
}

- (void) draw
{
  if ((mtpParticleA == NULL) || (mtpParticleB == NULL))
    return;
  
  
  glEnable(GL_LINE_SMOOTH);
  glLineWidth(0.5f);
  
  ccDrawLine([mtpParticleA pos], [mtpParticleB pos]);
}


- (void) dealloc
{
  [mtpParticleA release];
  [mtpParticleB release];
  
  [super dealloc];
}

@end
