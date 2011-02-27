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
  
  
  // Background
  CCSprite *bg = [CCSprite spriteWithFile: @"springParticlesBg.png"];
  
  bg.position = ccp(240, 160);
  
  // [self addChild: bg];
  
  
  mtpParticlesArray = [[NSMutableArray alloc] init];
  
  NSUInteger i;
  
  for (i = 0; i < 50; i++)
  {
    Particle *p = [Particle particleWithPositionAndVelocity: spRandomScreen() vel: CGPointZero];
    
    [mtpParticlesArray addObject: p];
    
    [self addChild: p];
  }
  
  // Tree trunks
  // 1
  [[mtpParticlesArray objectAtIndex: 0] setFixed: YES];
  [[mtpParticlesArray objectAtIndex: 0] setPos: ccp(240, 0)];
  
  // 2
  [[mtpParticlesArray objectAtIndex: 10] setFixed: YES];
  [[mtpParticlesArray objectAtIndex: 10] setPos: ccp(100, 0)];
  
  // 3
  [[mtpParticlesArray objectAtIndex: 20] setFixed: YES];
  [[mtpParticlesArray objectAtIndex: 20] setPos: ccp(50, 0)];
  
  // 4
  [[mtpParticlesArray objectAtIndex: 40] setFixed: YES];
  [[mtpParticlesArray objectAtIndex: 40] setPos: ccp(350, 0)];

  
  mtpSpringsArray = [[NSMutableArray alloc] init];
  
  for (i = 0; i < 50; i++)
  {
    Spring *s = [[[Spring alloc] init] autorelease];
    
    // 1
    if (i < 5)
    {
      [s setDistance: 50.0f];
      [s setSpringiness: 0.1f];
      
      [[mtpParticlesArray objectAtIndex: i] setSpring: YES];
      
      [s setParticleA: [mtpParticlesArray objectAtIndex: i]];
      [s setParticleB: [mtpParticlesArray objectAtIndex: ((i + 1) % [mtpParticlesArray count])]];
    }
    // 2
    else if (i > 9 && i <  15)
    {
      [s setDistance: 30.0f];
      [s setSpringiness: 0.08f];
      
      [[mtpParticlesArray objectAtIndex: i] setSpring: YES];
      
      [s setParticleA: [mtpParticlesArray objectAtIndex: i]];
      [s setParticleB: [mtpParticlesArray objectAtIndex: i+1]];
    }
    // 3
    else if (i > 19 && i <  23)
    {
      [s setDistance: 60.0f];
      [s setSpringiness: 0.01f];
      
      [[mtpParticlesArray objectAtIndex: i] setSpring: YES];
      
      [s setParticleA: [mtpParticlesArray objectAtIndex: i]];
      [s setParticleB: [mtpParticlesArray objectAtIndex: i+1]];
    }
    // 4
    else if (i > 39 && i <  45)
    {
      [s setDistance: 50.0f];
      [s setSpringiness: 0.05f];
      
      [[mtpParticlesArray objectAtIndex: i] setSpring: YES];
      
      [s setParticleA: [mtpParticlesArray objectAtIndex: i]];
      [s setParticleB: [mtpParticlesArray objectAtIndex: i+1]];
    }
    
    [mtpSpringsArray addObject: s];
    
    [self addChild: s];   
  }
  
  
  // Wind elements
  mtpWindSprite = [CCSprite spriteWithFile: @"circle1.png"];
  
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
    // [[mtpParticlesArray objectAtIndex: i] addForce: ccp((0.2f * cos(mtpWindSprite.position.x * 0.5f)), 0.05f)];
    
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
