//
//  HelloWorldLayer.h
//  SpringParticles
//
//  Created by Aitor Fernández on 21/02/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import "Particle.h"
#import "Spring.h"


// HelloWorld Layer
@interface MainScene : CCLayer
{
  NSMutableArray *mtpParticlesArray;
  NSMutableArray *mtpSpringsArray;
  
  CCSprite *mtpWindSprite;
  
  CGFloat mtWindMove;
}

// Returns a Scene that contains the HelloWorld as the only child
+ (id) scene;

@end
