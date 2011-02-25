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
  
  
  self.isTouchEnabled = YES;
  
  
  mtpParticlesArray = [[NSMutableArray alloc] init];
  
  for (int i = 0; i < 10; i++)
  {
    Particle *p = [Particle particleWithPositionAndVelocity: spRandomScreen() vel: CGPointZero];
    
    [mtpParticlesArray addObject: p];
    
    [self addChild: p];
  }
  
  // Wind elements
  mtpWindSprite = [CCSprite spriteWithFile: @"Icon-Small.png"];
  
  mtpWindSprite.position = ccp(CC_WINSIZE().width/2, CC_WINSIZE().height);
  
  [self addChild: mtpWindSprite z: 99];
  
  
  [self scheduleUpdate];
  
  
	return self;
}


//
// Loop
//

- (void) update: (ccTime)dt
{
  NSUInteger i, j, count = [mtpParticlesArray count];
  
  for (i = 0; i < count; i++)
  {
    [[mtpParticlesArray objectAtIndex: i] resetForce];
  }
  
  for (i = 0; i < count; i++)
  {
    for (j = 0; j < i; j++)
    {
      [[mtpParticlesArray objectAtIndex: i] addRepulsionForce: [mtpParticlesArray objectAtIndex: j] 
                                                       radius: 200.0f 
                                                        scale: 0.1f];
    }
  }
  
  for (i = 0; i < count; i++)
  {		
    [[mtpParticlesArray objectAtIndex: i] addForce: ccp((0.2f * cos(mtpWindSprite.position.x * 0.5f)), -0.05f)];
    
    [[mtpParticlesArray objectAtIndex: i] addDampingForce];
    
    [[mtpParticlesArray objectAtIndex: i] update];
	}
}


//
// Touch elements
//

- (BOOL) ccTouchBegan: (UITouch*)touch withEvent: (UIEvent *)event
{
  return YES;
}

- (void) ccTouchMoved: (UITouch*)touch withEvent: (UIEvent *)event
{
  CGPoint touchLocation = [self convertTouchToNodeSpace: touch];
    
  mtpWindSprite.position = ccp(touchLocation.x, CC_WINSIZE().height);
}

- (void) ccTouchEnded: (UITouch *)touch withEvent: (UIEvent *)event
{
}

- (void) ccTouchCancelled: (UITouch *)touch withEvent: (UIEvent *)event
{
	[self ccTouchEnded: touch withEvent: event];
}

-(void) registerWithTouchDispatcher
{
  // add ourselves as a touch delegate so we can receive touch messages
  // we have a monopoly on touches, so priority is meaningless
  // swallowsTouches means that we get the touch event, no one else
  
  [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate: self priority: 0 swallowsTouches: YES];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
  [mtpParticlesArray release];
  
  [mtpWindSprite release];
  
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
