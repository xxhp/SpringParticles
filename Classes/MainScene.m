//
//  HelloWorldLayer.m
//  SpringParticles
//
//  Created by Aitor Fernández on 21/02/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "MainScene.h"

#import "Utils.h"

// HelloWorld implementation
@implementation MainScene

+ (id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainScene *layer = [MainScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
- (id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if (!(self = [super init]))
    return nil;
  
  
  mtpParticlesArray = [[NSMutableArray alloc] init];
  
  for (int i = 0; i < 10; i++)
  {
    Particle *p = [Particle particleWithPositionAndVelocity: spRandomScreen() vel: CGPointZero];
    
    [mtpParticlesArray addObject: p];
    
    [self addChild: p];
  }
  
  [self scheduleUpdate];
  
  
	return self;
}

//
// Loop
//

- (void) update: (ccTime)dt
{

}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
  [mtpParticlesArray release];  
  
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
