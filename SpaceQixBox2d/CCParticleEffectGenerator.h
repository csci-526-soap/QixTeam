#import "cocos2d.h"

typedef CCNode CCEmitterNode;

@interface CCParticleEffectGenerator : NSObject {}

/*
 Single emitter particle effect
 */

+(CCEmitterNode *) getFlareEffectEmitter;

/*
+(CCEmitterNode *) getChaoticFlareEffectEmitter;
*/

/*
 Multiple emitter particle effect
 */

+(CCEmitterNode *) getBurstFlareEffectEmitter;
+(CCEmitterNode *) getGroudExplodeEffectEmitter;
+(CCEmitterNode *) getArmExplodeEffectEmitter;
+(CCEmitterNode *) getCartoonExplodeEffectEmitter;
+(CCEmitterNode *) getAreaBangEffectEmitter;
+(CCEmitterNode *) getBigBangEffectEmitter;

/*
 Test emitter particle effect
 */
+(CCEmitterNode *) getExperimentEffectEmitter;

@end