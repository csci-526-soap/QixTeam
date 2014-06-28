//
//  QXFireArmor.m
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 3/23/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXFireArmor.h"
#import "GB2ShapeCache.h"
#import "QXExplosion.h"
#import "CDAudioManager.h"
#import "AppDelegate.h"
@implementation QXFireArmor

- (void) setup:(CCLayer *)layer physicalWorld:(b2World *)world
{
    [super setup:layer physicalWorld:world];
    [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"projectileBody.plist"];
    _armors = [[NSMutableArray alloc] init];
    armorUserData = [[NSMutableArray alloc] init];
    armorIndex = 0;
}

- (CCSprite *) spawnArmor:(CGPoint) position
{
    
    [[CDAudioManager sharedManager].soundEngine playSound:SND_PLA
                                            sourceGroupId:CGROUP_EFFECTS
                                                    pitch:1.0f
                                                      pan:0.0f
                                                     gain:1.0f
                                                     loop:NO];
    
    CCSprite *projectile = [CCSprite spriteWithFile:@"fire_player.png"];
    [_layer addChild:projectile z:0];
    projectile.tag = armorIndex++;
    [_armors addObject:projectile];
    return projectile;
}

- (NSMutableArray *)armors
{
    return _armors;
}

- (int) currentArmorIndex
{
    return armorIndex;
}

- (void) fire:(ccTime)delta fromPosition:(CGPoint)position target:(CGPoint)target direction:(int)direction fireStop:(void (^)(int armorIndex)) fireStop
{
   
    CCSprite *projectile = [self spawnArmor:position];
    
    
    if( direction == 0 ){    //up
        projectile.rotation = 90;
        projectile.position = ccpAdd(position, ccp(-7,10));
        
    }else if( direction == 2){ //down
        
        projectile.rotation = -90;
        projectile.position = ccpAdd(position, ccp(7,-20));
        
    }else if( direction == 3){ //left
        
        projectile.rotation = 0;
        projectile.position = ccpAdd(position, ccp(-16,-6));
        
    }else if( direction == 1){ // right
        
        projectile.rotation = 180;
        projectile.position = ccpAdd(position, ccp(16,8));
    }
    

    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(projectile.position.x/PTM_RATIO, projectile.position.y/PTM_RATIO);
    
    NSString *userData = [NSString stringWithFormat:@"%@%d", BODY_FIRE_ARMOR, armorIndex];
    [armorUserData addObject:userData];
    bodyDef.userData = userData;
    
    b2Body  *projectileBody = _world->CreateBody(&bodyDef);
    [[GB2ShapeCache sharedShapeCache]
     addFixturesToBody:projectileBody forShapeName:@"projectileBody"];
    [projectile setAnchorPoint:[
                                [GB2ShapeCache sharedShapeCache]
                                anchorPointForShape:@"projectileBody"]];
    
    id moveact=[CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:2.0 position:target] rate:1];
    id ease = [CCEasePolynomial actionWithAction:moveact];
    [projectile runAction: [CCSequence actions: ease,nil]];
    
    if (fireStop) {
        fireStop(armorIndex);
    }
}

- (CCSprite *) missile:(int)tag
{
    for (int i = 0; i < [_armors count]; i++) {
        CCSprite *sprite = [_armors objectAtIndex:i];
        if (sprite.tag == tag) {
            return sprite;
        }
    }
    return nil;
}

- (void) cleanUpSpecificMissile:(int)tagNum
{
    for (int i = 0; i < [_armors count]; i++) {
        CCSprite *projectile = [_armors objectAtIndex:i];
        if (projectile.tag == tagNum) {
            specificQixMissileLocation = projectile.position;
            [_armors removeObject:projectile];
            [projectile  removeFromParentAndCleanup:YES];
        }
    }

}

- (void) cleanUpMissiles
{
    [_armors removeAllObjects];
    
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            NSString *value = (NSString *)b->GetUserData();
            if( value.length > BODY_FIRE_ARMOR.length){
                NSString *m = [value substringToIndex:BODY_FIRE_ARMOR.length];
                if ([m isEqualToString:BODY_FIRE_ARMOR]) {
                    b->GetWorld()->DestroyBody(b);
                }
            }
        }
    }
}

- (void) cleanUpMissilesOutOfScreen
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    for (int i = 0; i < [_armors count]; i++) {
        CCSprite *projectile = [_armors objectAtIndex:i];
        if (projectile.position.x<0 || projectile.position.x>winSize.width || projectile.position.y<0 || projectile.position.y > winSize.height) {
            
            for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
                if (b->GetUserData() != NULL) {
                    // update the sprite position to be consistency with box body location
                    NSString *value = (NSString *)b->GetUserData();
                    if( value.length > BODY_FIRE_ARMOR.length ) {
                        NSString *m = [value substringToIndex:BODY_FIRE_ARMOR.length];
                        if ([m isEqualToString:BODY_FIRE_ARMOR]) {
                            int tag = [[value substringFromIndex:BODY_FIRE_ARMOR.length] intValue];
                            if (projectile.tag == tag) {
                                b->GetWorld()->DestroyBody(b);
                            }
                        }
                    }
                }
            }
            [_armors removeObjectAtIndex:i];
            i--;
            [projectile  removeFromParentAndCleanup:YES];
            
        }
    }
}

- (void) explode
{
    [[QXExplosion sharedExplosion] explode:EPLAYER_MISSILE_QIX_MISSILE layer:_layer position:specificQixMissileLocation];
}

- (bool) pickup
{
    if (pickedUp) {
        return false;
    }
    if ([[QXMap sharedMap] isFill:pickUpImg.position]) {
        pickedUp = true;
    }
    return true;
}

@end
