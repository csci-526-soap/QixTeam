#import "QXSceneManager.h"
#import "QXLevel1Layer.h"
#import "CCParticleEffectGenerator.h"
#import "CCShake.h"
#import "CDAudioManager.h"
#import "AppDelegate.h"
@implementation QXlayer_x

// initialize mosnters (this method is called after the player is initilized)


/*****************************/
static int timerStartLv3 = 0;
static int timerStartCountLv3 = 0;
/*****************************/

- (void) initArmors
{
    timerStartLv3 = timerStart;
    timerStartCountLv3 = timerStartCount;
    
    
    frozenArmor = [CCSprite spriteWithFile:@"iceberg.png"];
    frozenArmor.scale = 0.7;
    frozenArmor.anchorPoint = ccp(0.5, 0);
    //    projectile1 = [CCSprite spriteWithSpriteFrameName:@"battery0.png"];
    //projectile1.position = ccp(mapWidth/2-projectile1.contentSize.width -80, mapHeight-projectile1.contentSize.height - 100);
    //projectile2.position = ccp(mapWidth/2-projectile2.contentSize.width +200, mapHeight-projectile2.contentSize.height*2 - 200);
    [frozenArmor runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCRotateTo actionWithDuration:1 angle:30] two:[CCRotateTo actionWithDuration:1 angle:-30]]]];
    
    [self addChild:frozenArmor];
    
    
    //    projectile1 = [CCSprite spriteWithSpriteFrameName:@"battery0.png"];
    frozenArmor.position = ccp(mapWidth/2-frozenArmor.contentSize.width +200, mapHeight-frozenArmor.contentSize.height*2 -50);}

- (void) initMonsters
{
    [super initMonsters];
    [self initArmors];
    
    levelId = LEVEL_2;
    
    qix = [[QXLaserQix alloc] init];
    [qix setUp:self physicalWorld:_world userData:BODY_LASER_QIX :self];
    
    guardQix1 = [[QXSurrander alloc] init];
    [guardQix1 setup:ccp(260, 160) layer:self physicalWorld:_world userData:BODY_GUARD_1 Qixall:qix type:1];
    
    guardQix2 = [[QXSurrander alloc] init];
    [guardQix2 setup:ccp(220, 160) layer:self physicalWorld:_world userData:BODY_GUARD_2 Qixall:qix type:2];
    
    guardQix3 = [[QXSurrander alloc] init];
    [guardQix3 setup:ccp(240, 180) layer:self physicalWorld:_world userData:BODY_GUARD_3 Qixall:qix type:3];
}

// monster take actions (this method is called once per frame after moving the player)
- (void) monsterTakeActions:(ccTime) frameDuration
{
    [super monsterTakeActions:frameDuration];
    if ([qix isActive]) {
        [qix takeAction:frameDuration spawnMissile:^(bool isSpawning, bool start, int tag) {
            if (start) {
                [[qix armor] spawnArmor:[qix qixSprite].position];
            }
            [qix fire:frameDuration];
        }];
        CGPoint target = [[QXPlayers sharedPlayers] mainPlayerPosition];
        [guardQix1 takeAction:target];
        [guardQix2 takeAction:target];
        [guardQix3 takeAction:target];
    }

}

-(void)update:(ccTime)delta
{
    [super update:delta];
    
    if(timerStartLv3==1){
        timerStartCountLv3 = timerStartCountLv3 + 1;
        if(timerStartCountLv3<151&&timerStartCountLv3%30==0){
            [qix qixOpacityChange];
        }else if(timerStartCountLv3==151){
            // [Snake hitByGlacierFrozenThenShaking];
        }else if(timerStartCountLv3>=300){
            timerStartLv3 = 0;
            timerStartCountLv3 = 0;
            [qix hitByGlacierFrozenEnd:self];
        }
    }
    
}


/*************************************************************************/
- (NSString *)backgroundImagePath
{
    return @"scene1.png";
}

// the revealed image path
- (NSString *) revealedImagePath
{
    return [super revealedImagePath];
}

// the position of the Qix (this method is called when the game needs to decide which area is claimed by the player)
- (CGPoint) qixPosition
{
    return [qix position];    // QXLaser QIX should have this method
}

// move player by using joysticks with direction (this method is called once per frame, subclass which overrides this method should call [super onPlayerMovingState])
- (void) onPlayerMovingState:(int) direction frameDuration:(ccTime)frameDuration
{
    if(direction != NODIR){
  //   [[QXPlayers sharedPlayers] fire:frameDuration dir:prevDirection];
    }
    [super onPlayerMovingState:direction frameDuration:frameDuration];
}

// player claim area state (this method is called when the player claims an area, subclass which overrides this method should call [super onClaimAreaState])
- (void) onClaimAreaState
{
    [super onClaimAreaState];
}


- (void) getArmor{
    
    // [super getArmor];
    
    if ((withArm1 == NO) && [[QXMap sharedMap] isFill:CGPointMake(frozenArmor.position.x, frozenArmor.position.y)]) {
        NSLog(@"武器1 Level3 被围住！！");
        [frozenArmor removeFromParentAndCleanup:YES];
        withArm = YES;
        withArm1 = YES;
        [[QXPlayers sharedPlayers] fireFrozenMissile:self qixPosition:[qix qixSprite].position qixSize:[qix qixSprite].contentSize];
        //    [qix hitByArmor:GuidedMissile from:[QXPlayers sharedPlayers].mainPlayerPosition time:0];
    }
}



// ensure position consistency between cocos2d sprites and box2d b2Bodies. (this method is called once per frame for each b2Body in the physical world)
- (void) onCocosAndBoxPositionUpdate:(b2Body *)body
{
    [super onCocosAndBoxPositionUpdate:body];
    
    NSString *value = (NSString *)body->GetUserData();
    NSString *missilePrefix = @"";
    NSString *quickAutoMissileTag = @"";
    
    if( value.length > BODY_FIRE_ARMOR.length){
        quickAutoMissileTag = [value substringToIndex:BODY_FIRE_ARMOR.length];
    }
    
    if (value.length > BODY_SCATTERED_MISSILE_TAG.length) {
        missilePrefix = [value substringToIndex:BODY_SCATTERED_MISSILE_TAG.length];
    }
    
    if([value isEqualToString:BODY_QIX]) {
        CGPoint point = [qix qixSprite].position;
        b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO, point.y/PTM_RATIO);
        float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([qix qixSprite].rotation);
        // Update the Box2D position/rotation to match the Cocos2D position/rotation
        body->SetTransform(b2Position, b2Angle);
        
    } else if ([value isEqualToString:BODY_GUARD_1]) {
        if ([guardQix1 isActive]) {
            CGPoint point = [guardQix1 qixSprite].position;
            
            b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                       point.y/PTM_RATIO);
            float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([guardQix1 qixSprite].rotation);
            
            body->SetTransform(b2Position, b2Angle);
        }
    } else if ([value isEqualToString:BODY_GUARD_2]) {
        if ([guardQix2 isActive]) {
            CGPoint point = [guardQix2 qixSprite].position;
            
            b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                       point.y/PTM_RATIO);
            float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([guardQix2 qixSprite].rotation);
            body->SetTransform(b2Position, b2Angle);
        }
    } else if ([value isEqualToString:BODY_GUARD_3]) {
        if ([guardQix3 isActive]) {
            CGPoint point = [guardQix3 qixSprite].position;
            b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO,
                                       point.y/PTM_RATIO);
            float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([guardQix3 qixSprite].rotation);
            
            body->SetTransform(b2Position, b2Angle);
        }
    } else if ([value isEqualToString:BODY_BEAM_ARMOR]) {
        if ([qix isSpawningFire]) {
            CGPoint point = [[qix armor] armorSprite].position;
            b2Vec2 b2Position = b2Vec2(point.x/PTM_RATIO, point.y/PTM_RATIO);
            float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS([[qix armor] armorSprite].rotation);
            body->SetTransform(b2Position, b2Angle);
        }
    }
}





// detect object collisions (this method is called once per frame for every two objects that has collision)
- (bool) onBox2dCollisionDetection:(b2Body *)bodyA body2:(b2Body *)bodyB toDestroy:(std::vector<b2Body *>)toDestroy
{
    [super onBox2dCollisionDetection:bodyA body2:bodyB toDestroy:toDestroy];
    
    NSString *valueA = (NSString *) bodyA->GetUserData();
    NSString *valueB = (NSString *) bodyB->GetUserData();
    
    if (([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_QIX]) || ([valueA isEqualToString:BODY_QIX] && [valueB isEqualToString:BODY_PLAYER])) {
        NSLog(@"player collide with qix");
        playerCollideWithQix = true;
        return false;
    } else if (([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_GUARD_1]) || ([valueA isEqualToString:BODY_GUARD_1] && [valueB isEqualToString:BODY_PLAYER])) {
        NSLog(@"player collide with guard 1");
        playerCollideWithGuard1 = true;
        return false;
    } else if (([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_GUARD_2]) || ([valueA isEqualToString:BODY_GUARD_2] && [valueB isEqualToString:BODY_PLAYER])) {
        NSLog(@"player collide with guard 2");
        playerCollideWithGuard2 = true;
        return false;
    } else if (([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_GUARD_3]) || ([valueA isEqualToString:BODY_GUARD_3] && [valueB isEqualToString:BODY_PLAYER])) {
        NSLog(@"player collide with guard 3");
        playerCollideWithGuard3 = true;
        return false;
    } else if (([valueA isEqualToString:BODY_WORLD] && [valueB isEqualToString:BODY_QIX]) || ([valueA isEqualToString:BODY_QIX] && [valueB isEqualToString:BODY_WORLD])) {
        NSLog(@"qix collide with world");
        qixCollideWithWorld = true;
    } else if (([valueA isEqualToString:BODY_BEAM_ARMOR] && [valueB isEqualToString:BODY_PLAYER]) || ([valueA isEqualToString:BODY_PLAYER] && [valueB isEqualToString:BODY_BEAM_ARMOR])) {
        NSLog(@"player collide with beam");
        playerCollideWithLaser =  true;
        return false;
    }
    return false;
}


// subclass should override this method to do follow-up actions if collisions are detected
- (void) afterBox2dCollisionDetetion
{
    [super afterBox2dCollisionDetetion];

    if (qixCollideWithWorld) {
        
    }
    
    if ( playerCollideWithGuard1 || playerCollideWithGuard2 || playerCollideWithGuard3 || playerCollideWithQix || playerCollideWithWalkerNW || playerCollideWithWalkerNS || playerCollideWithLaser) {
        if (playerCollideWithLaser) {
            [[QXMedalSystem sharedMedalSystem] invokeOnHitByLaser:^(enum QXMedalType, QXMedal *medal) {
                [medal displayMedal:self];
            }];
        }
        [self lose];
    }
    if(playerQuickAutoMissileGuard1){
        [guardQix1 collideWithExplosion];
    } else if(playerQuickAutoMissileGuard2){
        [guardQix2 collideWithExplosion];
    } else if(playerQuickAutoMissileGuard3){
        [guardQix3 collideWithExplosion];
    }
    
    [self resetCollisionDetectionVariables];
}




- (void) resetCollisionDetectionVariables
{
    playerCollideWithWalkerNW = false;
    playerCollideWithGuard1 = false;
    playerCollideWithGuard2 = false;
    playerCollideWithGuard3 = false;
    playerCollideWithLaser = false;
    playerCollideWithQix = false;
    playerCollideWithWalkerNS = false;
    
    playerQuickAutoMissileGuard1 = false;
    playerQuickAutoMissileGuard2 = false;
    playerQuickAutoMissileGuard3 = false;

    qixCollideWithWorld = false;
    oneTimeCollisionListen = 0;
}




/*************** sender is from QXPlayers.mm function ****************/

-(void)removeGlacierFrozen:(id)sender
{
    
    [self generateUnderDust];
    [self runShakeScreenEffect];
    [qix hitByGlacierFrozen];
    NSLog(@"timer START!");
    timerStartLv3 = 1;
    
    if([qix isActive]){
        NSLog(@"QIX is active");
    }else{
        NSLog(@"QIX is not active");
    }
    
    
}
- (void) runShakeScreenEffect
{
    [self runAction:[CCShake actionWithDuration:2.0f
                                      amplitude:ccp(5 + CCRANDOM_0_1() * 5, 5 + CCRANDOM_0_1() * 5)
                                      dampening:YES]];
}

- (void) generateUnderDust
{
    
    
    
    [[CDAudioManager sharedManager].soundEngine playSound:SND_DRP
                                            sourceGroupId:CGROUP_EFFECTS
                                                    pitch:1.0f
                                                      pan:0.0f
                                                     gain:1.0f
                                                     loop:NO];
    //*******************underDust*********************
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"dustUnder.plist"];
    
    CCSprite *dustUnder = [CCSprite spriteWithSpriteFrameName:@"dust0.png"];
    
    dustUnder.anchorPoint = ccp(0.1,0.2);
    
    dustUnder.position = ccpAdd([qix qixSprite].position, ccp(-40, -20));
    
    CCSpriteBatchNode * batchNodeDustUnder = [CCSpriteBatchNode batchNodeWithFile:@"dustUnder.png"];
    
    [batchNodeDustUnder addChild:dustUnder];
    
    [self addChild:batchNodeDustUnder];
    
    NSMutableArray * animFrames = [NSMutableArray array];
    
    for(int i =0; i < 11; i++) {
        
        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"dust%d.png", i]];
        
        [animFrames addObject:frame];
        
        
        
    }
    
    CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
    
    [dustUnder runAction:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation] times:1]];
    
    CCCallFunc* vanishAction = [CCCallFuncN actionWithTarget:self selector:@selector(removeDustUnder:)];
    
    CCSequence* sequence = [CCSequence actions:[CCFadeOut actionWithDuration:0.8f],vanishAction,nil];
    
    [dustUnder runAction:sequence];
    
}

-(void)removeDustUnder:(id)sender

{
    
    CCSprite *bgSprite = (CCSprite *)sender;
    
    [bgSprite removeFromParentAndCleanup:YES];
    
}




// dealloc (this method is called when the layer class is destroyed, subclass which overrides this method should call [super onDealloc])
- (void) onDealloc
{
    [super onDealloc];
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeUnusedSpriteFrames];
}



/*************************************************************************/
@end