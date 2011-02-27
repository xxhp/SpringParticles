//
//  Utils.h
//  SpringParticles
//
//  Created by Aitor Fernández on 21/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//
// SpringParticles(sp) utils
//

#define CC_WINSIZE() ([[CCDirector sharedDirector] winSize])


static inline CGFloat spRandomBetween(CGFloat x, CGFloat y)
{
	if (x == y)
    return x;
  
  CGFloat max = MAX(x, y);
  CGFloat min = MIN(x, y);
  
  return min + ((max - min) * random()/(RAND_MAX + 1.0f));
}

static inline CGFloat spRandom(CGFloat r)
{
  return spRandomBetween(0, r);
}

static inline CGPoint spRandomScreen()
{
  return ccp(spRandom(CC_WINSIZE().width), spRandom(CC_WINSIZE().height));
}


// http://www.cocos2d-iphone.org/forum/topic/4348/page/3
@interface CCAlphaSprite : CCSprite

- (void) draw;
@end
