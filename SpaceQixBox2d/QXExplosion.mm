//
//  QXExplosion.m
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 3/22/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXExplosion.h"
#import "CDAudioManager.h"
#import "AppDelegate.h"

@implementation QXExplosion

static dispatch_once_t QXExplosionPredicate;
static QXExplosion *sharedExplosion = nil;

+ (QXExplosion *)sharedExplosion {
    dispatch_once(&QXExplosionPredicate, ^{
        sharedExplosion = [[QXExplosion alloc] init];
    });
    return sharedExplosion;
}
- (void) setup
{
   
    //[layer addChild:batchNode];
    
    
    
}

- (void) explode:(NSString *)plistName spriteName:(NSString *)spriteName batchNodeName:(NSString *) batchNodeName spriteFrameName:(NSString *) spriteFrameName layer:(CCLayer *)layer position:(CGPoint)position
{

}

- (void) explode:(enum QXExplosionType)explodeType layer:(CCLayer *)layer position:(CGPoint)position
{
    switch (explodeType) {
        case EPLAYER: {
            NSLog(@"player explosion");
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bomb.plist"];
            playerExplosion = [CCSprite spriteWithSpriteFrameName:@"bomb0.png"];
            //sprite.anchorPoint = ccp(0,0);
            playerExplosion.position = position;
            CCSpriteBatchNode * batchNodePlayer = [CCSpriteBatchNode batchNodeWithFile:@"bomb.png"];
            [batchNodePlayer addChild:playerExplosion];
            [layer addChild:batchNodePlayer];
            
            [[CDAudioManager sharedManager].soundEngine playSound:SND_BOMB
                                                    sourceGroupId:CGROUP_EFFECTS
                                                            pitch:1.0f
                                                              pan:0.0f
                                                             gain:1.0f
                                                             loop:NO];
            
            NSMutableArray * animFrames = [NSMutableArray array];
            for(int i =0; i < 19; i++) {
                CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"bomb%d.png", i]];
                [animFrames addObject:frame];
                
            }
            
            CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
            [playerExplosion runAction:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation] times:1]];
            CCCallFunc* vanishAction = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
            CCSequence* sequence = [CCSequence actions:[CCFadeOut actionWithDuration:0.8f],vanishAction,nil];
            [playerExplosion runAction:sequence];
            break;
        }
        case EWALKER:{
            NSLog(@"WalerQix explosion");
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"expl.plist"];
            simpleQixExplosion = [CCSprite spriteWithSpriteFrameName:@"expl0.png"];
            //sprite.anchorPoint = ccp(0,0);
            simpleQixExplosion.position = position;
            CCSpriteBatchNode * batchNodeSimpleQix = [CCSpriteBatchNode batchNodeWithFile:@"expl.png"];
            [batchNodeSimpleQix addChild:simpleQixExplosion];
            [layer addChild:batchNodeSimpleQix];
            
            [[CDAudioManager sharedManager].soundEngine playSound:SND_BOMB
                                                    sourceGroupId:CGROUP_EFFECTS
                                                            pitch:1.0f
                                                              pan:0.0f
                                                             gain:1.0f
                                                             loop:NO];
            
            NSMutableArray * animFrames = [NSMutableArray array];
            for(int i =0; i < 27; i++) {
                CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"expl%d.png", i]];
                [animFrames addObject:frame];
                
            }
            CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
            [simpleQixExplosion runAction:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation] times:1]];
            CCCallFunc* vanishAction = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
            CCSequence* sequence = [CCSequence actions:[CCFadeOut actionWithDuration:0.8f],vanishAction,nil];
            [simpleQixExplosion runAction:sequence];
            break;
        }
        case EGUARD: {
            NSLog(@"GuardQix explosion");
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"expl.plist"];
            simpleQixExplosion = [CCSprite spriteWithSpriteFrameName:@"expl0.png"];
            //sprite.anchorPoint = ccp(0,0);
            simpleQixExplosion.position = position;
            CCSpriteBatchNode * batchNodeSimpleQix = [CCSpriteBatchNode batchNodeWithFile:@"expl.png"];
            [batchNodeSimpleQix addChild:simpleQixExplosion];
            [layer addChild:batchNodeSimpleQix];
            
            [[CDAudioManager sharedManager].soundEngine playSound:SND_BOMB
                                                    sourceGroupId:CGROUP_EFFECTS
                                                            pitch:1.0f
                                                              pan:0.0f
                                                             gain:1.0f
                                                             loop:NO];
            
            NSMutableArray * animFrames = [NSMutableArray array];
            for(int i =0; i < 27; i++) {
                CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"expl%d.png", i]];
                [animFrames addObject:frame];
                
            }
            CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
            [simpleQixExplosion runAction:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation] times:1]];
            CCCallFunc* vanishAction = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
            CCSequence* sequence = [CCSequence actions:[CCFadeOut actionWithDuration:0.8f],vanishAction,nil];
            [simpleQixExplosion runAction:sequence];
            break;
        }
        case EQIX:
            break;
        case EPLAYER_MISSILE_QIX_MISSILE:{
            NSLog(@"player Missile collide with QIX missile explosion");
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"expl.plist"];
            simpleQixExplosion = [CCSprite spriteWithSpriteFrameName:@"expl0.png"];
            simpleQixExplosion.anchorPoint = ccp(0,0);
            simpleQixExplosion.position = position;
            CCSpriteBatchNode * batchNodeSimpleQix = [CCSpriteBatchNode batchNodeWithFile:@"expl.png"];
            [batchNodeSimpleQix addChild:simpleQixExplosion];
            [layer addChild:batchNodeSimpleQix];
            
            [[CDAudioManager sharedManager].soundEngine playSound:SND_BOMB
                                                    sourceGroupId:CGROUP_EFFECTS
                                                            pitch:1.0f
                                                              pan:0.0f
                                                             gain:1.0f
                                                             loop:NO];
            
            NSMutableArray * animFrames = [NSMutableArray array];
            for(int i =0; i < 27; i++) {
                CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"expl%d.png", i]];
                [animFrames addObject:frame];
                
            }
            CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
            [simpleQixExplosion runAction:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation] times:1]];
            CCCallFunc* vanishAction = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
            CCSequence* sequence = [CCSequence actions:[CCFadeOut actionWithDuration:0.8f],vanishAction,nil];
            [simpleQixExplosion runAction:sequence];
            break;
        }
        case ETIME_BOMB:
            NSLog(@"time bomb exploded");
            [self fillPolygon:[[QXMap sharedMap]boundary] layer:layer];
            break;
        default:
            break;
    }
}

- (void) fillPolygon:(NSArray *)poly layer:(CCLayer *)layer
{
    
    NSMutableArray *fillArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *tempFillArray = [[NSMutableArray alloc] init];
    
    CGFloat mapHeight = [[CCDirector sharedDirector] winSize].height;
    NSLog(@"map height: %f", mapHeight);
    // scan line
    for (int h = 0; h <= mapHeight; h++) {
        
        // find intersection points of polygon at line h
        for (int i = 0; i < [poly count]; i++) {
            CGPoint p = [[poly objectAtIndex:i] CGPointValue];
            if (p.y == h) {
                [tempFillArray addObject:[poly objectAtIndex:i]];
            }
        }
        
        // adjust the filled array for polygon
        fillArray = [[QXMap sharedMap] haoyu:fillArray tempFilledSpace:tempFillArray];
        
        // update area
        if (h % 80 == 0) {
            for (int i = 0; i < [fillArray count]; i+=2) {
                CGPoint p = [[fillArray objectAtIndex:i] CGPointValue];
                CGPoint q = [[fillArray objectAtIndex:i+1] CGPointValue];
                p.y = h;
                q.y = h;
                for (int x =p.x + 20; x <= q.x; x += 40) {
                    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"expl.plist"];
                    simpleQixExplosion = [CCSprite spriteWithSpriteFrameName:@"expl0.png"];
                    simpleQixExplosion.position = ccp(x, h+40);
                    CCSpriteBatchNode * batchNodeSimpleQix = [CCSpriteBatchNode batchNodeWithFile:@"expl.png"];
                    [batchNodeSimpleQix addChild:simpleQixExplosion];
                    [layer addChild:batchNodeSimpleQix];
                    
//                    [[CDAudioManager sharedManager].soundEngine playSound:SND_BOMB
//                                                            sourceGroupId:CGROUP_EFFECTS
//                                                                    pitch:1.0f
//                                                                      pan:0.0f
//                                                                     gain:1.0f
//                                                                     loop:NO];
                    
                    NSMutableArray * animFrames = [NSMutableArray array];
                    for(int i =0; i < 27; i++) {
                        CCSpriteFrame * frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"expl%d.png", i]];
                        [animFrames addObject:frame];
                    }
                    CCAnimation * animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
                    [simpleQixExplosion runAction:[CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation] times:1]];
                    CCCallFunc* vanishAction = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
                    CCSequence* sequence = [CCSequence actions:[CCFadeOut actionWithDuration:0.8f],vanishAction,nil];
                    [simpleQixExplosion runAction:sequence];
                }
            }
        }
        // clean
        [tempFillArray removeAllObjects];
    }
    [fillArray removeAllObjects];
    [tempFillArray removeAllObjects];
}

-(void)removeSprite:(id)sender
{
    CCSprite *bgSprite = (CCSprite *)sender;
    [bgSprite removeFromParentAndCleanup:YES];
}

@end
