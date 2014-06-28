//
//  QXMedal.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/22/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXMedal.h"

@implementation QXMedal

- (void) setup:(CCSprite *)medal description:(NSString *)description type:(enum QXMedalType)type isActive:(bool)isActive
{
    _medal = medal;
    _description = description;
    _type = type;
    _isActive = isActive;
    _lockedMedal = [CCSprite spriteWithFile:@"medbw.png"];
}

+ (QXMedal *) getMedalByType:(enum QXMedalType)type
{
    QXMedal *medal = [[QXMedal alloc] init];
    CCSprite *sprite;
    NSString *description;
    bool isActive = false;
    
    NSUserDefaults *user = [[NSUserDefaults alloc] init];
    int lostLivesTotalCnt = [[user objectForKey:KEY_MEDAL_LOST_LIVES_TOTAL_CNT] intValue];
    int hitByLaserTotalCnt = [[user objectForKey:KEY_MEDAL_HIT_BY_LASER_TOTAL_CNT] intValue];
    int hitByMissileTotalCnt = [[user objectForKey:KEY_MEDAL_HIT_BY_MISSILE_TOTAL_CNT] intValue];
    
    switch (type) {
        case MEDAL_DIE:
            sprite = [CCSprite spriteWithFile:@"med0.png"];
            description = KEY_MEDAL_LOST_LIVES_DESCRIPTION;
            if (lostLivesTotalCnt > 50) {
                isActive = true;
                NSLog(@"lost lives %d", lostLivesTotalCnt);
            }
            break;
        case MEDAL_KILLED_BY_LASER:
            sprite = [CCSprite spriteWithFile:@"med1.png"];
            description = KEY_MEDAL_HIT_BY_LASER_DESCRIPTION;
            if (hitByLaserTotalCnt > 50) {
                isActive = true;
            }
            break;
        case MEDAL_KILLED_BY_MISSILE:
            sprite = [CCSprite spriteWithFile:@"med2.png"];
            description = KEY_MEDAL_HIT_BY_MISSILE_DESCRIPTION;
            if (hitByMissileTotalCnt > 50) {
                isActive = true;
            }
            break;
        case MEDAL_NULL:
            sprite = [CCSprite spriteWithFile:@""];
            description = @"";
            break;
        case MEDAL_WIN:
            sprite = [CCSprite spriteWithFile:@""];
            description = @"";
            break;
        case MEDAL_CLAIM_50:
            sprite = [CCSprite spriteWithFile:@""];
            description = @"";
            break;
        case MEDAL_WALKER_DIED:
            sprite = [CCSprite spriteWithFile:@""];
            description = @"";
            break;
        default:
            break;
    }
    [medal setup:sprite description:description type:type isActive:isActive];
    return medal;
}

- (void) displayMedal:(CCLayer *)layer
{
    CCSprite *sprite;
    switch (_type) {
        case MEDAL_WIN: {
            sprite = [CCSprite spriteWithFile:@""];
        }
            break;
        case MEDAL_NULL:
            break;
        case MEDAL_DIE:{
            sprite = [CCSprite spriteWithFile:@"die50.png"];
        }
            break;
        case MEDAL_KILLED_BY_LASER:{
            sprite = [CCSprite spriteWithFile:@"killbl.png"];
        }
            break;
        case MEDAL_KILLED_BY_MISSILE:{
            sprite = [CCSprite spriteWithFile:@"killbm.png"];
        }
            break;
        case MEDAL_CLAIM_50: {
            sprite = [CCSprite spriteWithFile:@"claim50.png"];
        }
            break;
        case MEDAL_WALKER_DIED: {
            sprite = [CCSprite spriteWithFile:@"walkerd.png"];
        }
            break;
        default:
            break;
    }
    id scaleL = [CCScaleTo actionWithDuration:1.0f scale:1.5f];
    id fadeOut = [CCFadeOut actionWithDuration:1.2f];
    id vanishAction = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    sprite.anchorPoint = ccp(0.5, 0.5);
    sprite.position = ccp(winSize.width/2, winSize.height/2);
    [layer addChild:sprite];
    [sprite runAction:scaleL];
    [sprite runAction:[CCSequence actions:fadeOut, vanishAction, nil]];
}

-(void) removeSprite:(id) sender
{
    CCSprite *sprite = (CCSprite *)sender;
    [sprite removeFromParentAndCleanup:YES];
}

- (bool) isActive
{
    return _isActive;
}

- (CCSprite *)medal
{
    if (_isActive) {
        return _medal;
    } else {
        return _lockedMedal;
    }
}

- (NSString *)description
{
    return _description;
}

@end
