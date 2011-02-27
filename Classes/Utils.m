//
//  Utils.m
//  SpringParticles
//
//  Created by Aitor Fernández on 21/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"

@implementation CCAlphaSprite

- (void) draw
{
  glEnable(GL_ALPHA_TEST);
  glAlphaFunc(GL_GREATER, 0.0f);
  
  [super draw];
  
  glDisable(GL_ALPHA_TEST);
}

@end