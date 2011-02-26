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
  
  
  NSUInteger i;
  
  for (i = 0; i < 20; i++)
  {
    Particle *p = [Particle particleWithPositionAndVelocity: ccp((240+(i*10)), (0+(i*10))) vel: CGPointZero];
    
    [mtpParticlesArray addObject: p];
    
    [self addChild: p];
  }
  
  // Update first particle for tree trunk
  [[mtpParticlesArray objectAtIndex: 0] setFixed: YES];
  [[mtpParticlesArray objectAtIndex: 0] setPos: ccp(240, 0)];
  
  
  mtpSpringsArray = [[NSMutableArray alloc] init];
  
  for (i = 0; i < 20; i++)
  {
    Spring *s = [[[Spring alloc] init] autorelease];
    
    if (i < 3)
    {
      [s setDistance: 40.0f];
      [s setSpringiness: 0.1f];
      
      [s setParticleA: [mtpParticlesArray objectAtIndex: i]];
      [s setParticleB: [mtpParticlesArray objectAtIndex: ((i + 1) % [mtpParticlesArray count])]];
    }
    else if (i > 3 && i <  7)
    {
      [s setDistance: 40.0f];
      [s setSpringiness: 0.08f];
      
      [s setParticleA: [mtpParticlesArray objectAtIndex: i]];
      [s setParticleB: [mtpParticlesArray objectAtIndex: 2]];
    }
    else if (i > 3 && i <  15)
    {
      [s setDistance: 40.0f];
      [s setSpringiness: 0.08f];
      
      [s setParticleA: [mtpParticlesArray objectAtIndex: i]];
      [s setParticleB: [mtpParticlesArray objectAtIndex: 3]];
    }    
    
    
    [mtpSpringsArray addObject: s];
    
    [self addChild: s];   
  }
  
  
  // Wind elements
  mtpWindSprite = [CCSprite spriteWithFile: @"Icon-Small.png"];
  
  mtpWindSprite.position = ccp(0, 0);
  
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
  
  
  // Springs
  for (i = 0; i < [mtpSpringsArray count]; i++)
  {
    [[mtpSpringsArray objectAtIndex: i] update];
	}
  
  
  mtWindMove += 0.02f;
  
  for (i = 0; i < count; i++)
  {
    [[mtpParticlesArray objectAtIndex: i] addForce: ccp((0.2f * cos(mtWindMove * 0.5f)), 0.05f)];
    
    [[mtpParticlesArray objectAtIndex: i] addDampingForce];
    
    [[mtpParticlesArray objectAtIndex: i] update];
	}
  
  
  mtpWindSprite.position = ccp((cos(mtWindMove*0.5f)+1)*(CC_WINSIZE().width/2)+5, 0);
}

- (void) draw
{
  for (int i = 0; i < [mtpSpringsArray count]; i++)
  {
    [[mtpSpringsArray objectAtIndex: i] draw];
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
  // CGPoint touchLocation = [self convertTouchToNodeSpace: touch];
  //    
  // mtpWindSprite.position = ccp(touchLocation.x, 0);
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
  [mtpSpringsArray release];
  
  [mtpWindSprite release];
  
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
