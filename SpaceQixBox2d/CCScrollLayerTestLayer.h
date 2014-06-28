
#import "cocos2d.h"
#import "CCScrollLayer.h"

@interface CCScrollLayerTestLayer : CCLayer <CCScrollLayerDelegate> {
    
    CGSize screenSize;
    int startPage;
    
}

+(CCScene *) scene;

@end
