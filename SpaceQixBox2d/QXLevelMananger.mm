//
//  QXLevelMananger.m
//  SpaceQix
//
//  Created by Haoyu Huang on 4/7/14.
//  Copyright (c) 2014 HaoyuHuang. All rights reserved.
//

#import "QXLevelMananger.h"

@implementation QXLevelMananger

static dispatch_once_t QXLevelManagerPredicate;
static QXLevelMananger *sharedLevelManager = nil;

+ (QXLevelMananger *) sharedLevelManager {
    dispatch_once(&QXLevelManagerPredicate, ^{
        sharedLevelManager = [[QXLevelMananger alloc] init];
    });
    return sharedLevelManager;
}

- (void) setup:(QXArmorConfig *)armorConfig playerConfig:(QXPlayerConfig *)playerConfig monsterConfig:(QXMonsterConfig *)monsterConfig
{
    _armorConfig = armorConfig;
    _playerConfig = playerConfig;
    _monsterConfig = monsterConfig;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"level"
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
}

- (QXLevel *) activeLevel
{
    return activeLevel;
}

- (QXLevel *) findLevelById:(int) Id
{
    for (int i = 0; i < [levels count]; i++) {
        QXLevel *level = [levels objectAtIndex:i];
        if ([level levelId] == Id) {
            return level;
        }
    }
    return nil;
}

- (QXBaseAttribute *) findMonsterById:(int) Id withType:(enum QXQixType) type
{
    switch (type) {
        case Qix:
            return [_monsterConfig findQixById:Id];
        case Snake:
            
        case Guard:
            return [_monsterConfig findGuardById:Id];
        case Walker:
            return [_monsterConfig findWalkerById:Id];
        default:
            break;
    }
}

- (QXBaseAttribute *) findPlayerById:(int) Id withType:(enum QXPlayerType) type
{
    return [_playerConfig findPlayerById:Id];
}

- (QXBaseAttribute *) findArmorById:(int) Id withType:(enum QXArmorType) type
{
    return [_armorConfig findArmorById:Id];
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"game"]) {
        
    } else if([elementName isEqualToString:KEY_LEVELS]) {
        
    } else if([elementName isEqualToString:KEY_LEVEL]) {
        _level = [[QXLevel alloc] init];
        [_level build:attributeDict];
    } else if([elementName isEqualToString:KEY_ARMORS]) {
        
    } else if([elementName isEqualToString:KEY_ARMOR]) {
        _armor = [[QXBaseAttribute alloc] init];
        [_armor build:attributeDict];
        currentObject = KEY_ARMOR;
    } else if ([elementName isEqualToString:KEY_PLAYER]) {
        _player = [[QXBaseAttribute alloc] init];
        [_player build:attributeDict];
        currentObject = KEY_PLAYER;
    } else if([elementName isEqualToString:KEY_QIXS]) {
        
    } else if([elementName isEqualToString:KEY_QIX]) {
        _qix = [[QXBaseAttribute alloc] init];
        [_qix build:attributeDict];
        currentObject = KEY_QIX;
    } else if ([elementName isEqualToString:KEY_POSITION]) {
        if ([currentObject isEqualToString:KEY_ARMOR]) {
            [_armor buildPosition:attributeDict];
        } else if ([currentObject isEqualToString:KEY_PLAYER]) {
            [_player buildPosition:attributeDict];
        } else if ([currentObject isEqualToString:KEY_QIX]) {
            [_qix buildPosition:attributeDict];
        }
    }
    
//    NSLog(@"start element: %@", elementName);
//    for (id key in attributeDict) {
//        NSLog(@"attribute: %@ value: %@", key, [attributeDict objectForKey:key]);
//    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
//    NSLog(@"found string %@", string);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:KEY_LEVEL]) {
        [levels addObject:_level];
    } else if ([elementName isEqualToString:KEY_QIX]) {
        if (_level) {
            [_level addQix:_qix];
        }
    } else if ([elementName isEqualToString:KEY_PLAYER]) {
        if (_level) {
            [_level addPlayer:_player];
        }
    } else if ([elementName isEqualToString:KEY_ARMOR]) {
        if (_level) {
            [_level addArmor:_armor];
        }
    }
//    NSLog(@"end element %@", elementName);
}

@end
