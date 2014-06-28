//
//  QXGamePlay.m
//  SpaceQixBox2d
//
//  Created by Haoyu Huang on 4/4/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXGamePlay.h"

@implementation QXGamePlay

static dispatch_once_t QXGamePlayPredicate;
static QXGamePlay *sharedGamePlay = nil;

+ (QXGamePlay *)sharedGamePlay {
    dispatch_once(&QXGamePlayPredicate, ^{
        sharedGamePlay = [[QXGamePlay alloc] init];
    });
    return sharedGamePlay;
}

- (id) init
{
    id s = [super init];
    configured = false;
    return s;
}


- (void) setup
{
    isWin = 0;
    isPlaying = 1;
    isLose = 0;
    CGSize size = [[CCDirector sharedDirector] winSize];
    [[QXMap sharedMap] setupInitialState:size.width height:size.height startPoint:[[QXMap sharedMap] generateStartPoint]];
    if (!configured) {
        [self readConfig];
    }
}

- (void) readConfig
{
    if (configured) {
        return;
    }
    playerConfig = [[QXPlayerConfig alloc] init];
    monsterConfig = [[QXMonsterConfig alloc] init];
    armorConfig = [[QXArmorConfig alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"config"
                                                     ofType:@"xml"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    bool success = [parser parse];
    if(success){
        NSLog(@"Success reading game configuration file");
    }
    else{
        NSLog(@"Fail to read game configuration file");
    }
    NSUserDefaults *user = [[NSUserDefaults alloc] init];
    int temp = [user integerForKey:KEY_GAME_UNLOCKED_LEVEL];
    if (temp != 0) {
        unlockedLevel = temp;
        NSLog(@"unlocked level in user default: %d", temp);
    }
    
    [[QXLevelMananger sharedLevelManager] setup:armorConfig playerConfig:playerConfig monsterConfig:monsterConfig];
    configured = true;
    NSLog(@"life: %d", life);
    NSLog(@"unlocked level: %d", unlockedLevel);
}

- (void) win
{
    int claimed = [[QXMap sharedMap] filledArea];
    if(claimed > 150000) {
        isWin = 1;
        isLose = 0;
        isPlaying = 0;
        [self unlockNextLevel];
    }
}

- (void) lose:(void (^)(bool, int))callback
{
    if (![[QXPlayers sharedPlayers] isInvincible]) {
        [self loseLife];
        if (life == 0) {
            isWin = 0;
            isLose = 1;
            isPlaying = 0;
            [[QXMap sharedMap] gameOver];
            if (callback) {
                callback(true, life);
            }
        } else {
            if (callback) {
                callback(false, life);
            }
        }   
    }
}

- (void) reset
{
    life = 3;
    reset = true;
    CGSize size = [[CCDirector sharedDirector] winSize];
    [[QXMap sharedMap] setupInitialState:size.width height:size.height startPoint:[[QXMap sharedMap] generateStartPoint]];
}

- (bool) isWin
{
    if (isWin == 0) {
        return false;
    } else {
        return true;
    }
}

- (bool) isLose
{
    if (isLose == 0) {
        return false;
    } else {
        return true;
    }
}

- (bool) isPlaying
{
    if (isPlaying == 0) {
        return false;
    } else {
        return true;
    }
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"game"]) {
        NSLog(@"game");
        for (id key in attributeDict.allKeys) {
            if ([key isEqualToString:KEY_GAME_LIFE]) {
                life = [[attributeDict objectForKey:key] intValue];
            } else if ([key isEqualToString:KEY_GAME_TOTAL_LEVEL]) {
                totalLevel = [[attributeDict objectForKey:KEY_GAME_TOTAL_LEVEL] intValue];
            } else if ([key isEqualToString:KEY_GAME_UNLOCKED_LEVEL]) {
                unlockedLevel = [[attributeDict objectForKey:KEY_GAME_UNLOCKED_LEVEL] intValue];
            }
        }
    } else if([elementName isEqualToString:@"armors"]) {
        
    } else if([elementName isEqualToString:@"armor"]) {
        QXBaseAttribute *attr = [[QXBaseAttribute alloc] init];
        [attr build:attributeDict];
    } else if([elementName isEqualToString:@"players"]) {
        
    } else if ([elementName isEqualToString:@"player"]) {
        [playerConfig addPlayer:attributeDict];
    } else if([elementName isEqualToString:@"qixs"]) {
        
    } else if([elementName isEqualToString:@"qix"]) {
        [monsterConfig addMonster:attributeDict];
    }
    
//    NSLog(@"start element: %@ qualifiedName: %@", elementName, qualifiedName);
//    for (id key in attributeDict) {
//        NSLog(@"attribute: %@ value: %@", key, [attributeDict objectForKey:key]);
//    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    NSLog(@"found string %@", string);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"game"]) {
        
    } else if([elementName isEqualToString:@"armors"]) {
        
    } else if([elementName isEqualToString:@"armor"]) {
        
    } else if([elementName isEqualToString:@"players"]) {
        
    } else if ([elementName isEqualToString:@"player"]) {
        
    } else if([elementName isEqualToString:@"qixs"]) {
        
    } else if([elementName isEqualToString:@"qix"]) {
        
    }
//    NSLog(@"end element %@ qualifiedName: %@", elementName, qName);
}

- (int) remainingLife
{
    return life;
}

- (void) loseLife
{
    life--;
    NSLog(@"lose life, left life: %d", life);
    [[QXPlayers sharedPlayers] waitingForRespawn];
}

- (void) winLife
{
    life++;
    NSLog(@"get life, left life: %d", life);
}

- (int) unlockedLevel
{
    return unlockedLevel;
}

- (int) totalLevel
{
    return totalLevel;
}

- (void) unlockNextLevel
{
    if (unlockedLevel == totalLevel + 1) {
        return;
    }
    unlockedLevel++;
    NSUserDefaults *user = [[NSUserDefaults alloc] init];
    [user setInteger:unlockedLevel forKey:KEY_GAME_UNLOCKED_LEVEL];
}
@end
