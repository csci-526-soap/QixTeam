#import "CCParticleEffectGenerator.h"
#import "CCParticleEffect.h"

@implementation CCParticleEffectGenerator


#pragma mark - Single emitter particle effect
+(CCEmitterNode *) getFlareEffectEmitter {
    CCNode *effectEmitter = [CCNode node];
    
    CCParticleBurningFlare * burningFlareEmitter = [CCParticleBurningFlare node];
    
    burningFlareEmitter.autoRemoveOnFinish = YES;
    
    burningFlareEmitter.position = CGPointZero;
    
    [effectEmitter addChild:burningFlareEmitter z:1];
    
    return effectEmitter;
}

/*
+(CCEmitterNode *) getChaoticFlareEffectEmitter {
    CCNode *effectEmitter = [CCNode node];
    CCParticleChaoticFlare *chaoticFlareEmitter = [CCParticleChaoticFlare node];
    chaoticFlareEmitter.autoRemoveOnFinish = YES;
    chaoticFlareEmitter.position = CGPointZero;
    [effectEmitter addChild:chaoticFlareEmitter z:1];
    return effectEmitter; 
}

#pragma mark - Multiple emitter particle effect
+(CCEmitterNode *) getBurstFlareEffectEmitter {
    CCNode *effectEmitter = [CCNode node];
    CCParticleImplodingFlare *implodingFlareEmitter = [CCParticleImplodingFlare node];
    implodingFlareEmitter.autoRemoveOnFinish = YES;
    implodingFlareEmitter.position = CGPointZero;
    [effectEmitter addChild:implodingFlareEmitter z:1];

    CCParticleBurstFlare *burstFlareEmitter = [CCParticleBurstFlare node];
    burstFlareEmitter.autoRemoveOnFinish = YES;
    burstFlareEmitter.position = CGPointZero;
    [effectEmitter addChild:burstFlareEmitter z:1];
    
    return effectEmitter;
}


#pragma mark - Multiple emitter particle effect
+(CCEmitterNode *) getGroudExplodeEffectEmitter {
    CCNode *effectEmitter = [CCNode node];
    CCParticleDustFlare *dustFlareGrayEmitter = [CCParticleDustFlare node];
    dustFlareGrayEmitter.autoRemoveOnFinish = YES;
    dustFlareGrayEmitter.position = CGPointZero;
    [effectEmitter addChild:dustFlareGrayEmitter z:2];
    
    CCParticleDustFlare *dustFlareEmitter = [CCParticleDustFlare node];
    dustFlareEmitter.startColor = ccc4f(1.0f, 0.5f, 0.3f, 1.0f);
    dustFlareEmitter.endColor = ccc4f(1.0f, 0.5f, 0.3f, 1.0f);
    dustFlareEmitter.autoRemoveOnFinish = YES;
    dustFlareEmitter.position = CGPointZero;
    [effectEmitter addChild:dustFlareEmitter z:1];
    
    CCParticleDustBurst *dustBurstEmitter = [CCParticleDustBurst node];
    dustBurstEmitter.autoRemoveOnFinish = YES;
    dustBurstEmitter.position = CGPointZero;
    [effectEmitter addChild:dustBurstEmitter z:3];
    
    CCParticleDustRise *dustRiseEmitter = [CCParticleDustRise node];
    dustRiseEmitter.autoRemoveOnFinish = YES;
    dustRiseEmitter.position = CGPointZero;
    [effectEmitter addChild:dustRiseEmitter z:4];
    
    return effectEmitter;
}

+(CCEmitterNode *) getArmExplodeEffectEmitter {
    CCNode *effectEmitter = [CCNode node];
    CCParticleArmCloud *armCloudEmitter = [CCParticleArmCloud node];
    armCloudEmitter.autoRemoveOnFinish = YES;
    armCloudEmitter.position = CGPointZero;
    [effectEmitter addChild:armCloudEmitter z:2];
    
    CCParticleToonCloud *toonCloudEmitter = [CCParticleToonCloud node];
    toonCloudEmitter.autoRemoveOnFinish = YES;
    toonCloudEmitter.position = CGPointZero;
    [effectEmitter addChild:toonCloudEmitter z:1];
    
    CCParticlePangFlare *pangFlareEmitter = [CCParticlePangFlare node];
    pangFlareEmitter.autoRemoveOnFinish = YES;
    pangFlareEmitter.position = CGPointZero;
    [effectEmitter addChild:pangFlareEmitter z:3];
    
    return effectEmitter;
}

+(CCEmitterNode *) getCartoonExplodeEffectEmitter {
    CCNode *effectEmitter = [CCNode node];
    CCParticleCandleFlare *candleFlareEmitter = [CCParticleCandleFlare node];
    candleFlareEmitter.autoRemoveOnFinish = YES;
    candleFlareEmitter.position = CGPointZero;
    [effectEmitter addChild:candleFlareEmitter z:1];
    
    CCParticleToonCloud *toonCloudEmitter = [CCParticleToonCloud node];
    toonCloudEmitter.autoRemoveOnFinish = YES;
    toonCloudEmitter.position = CGPointZero;
    toonCloudEmitter.startColor = ccc4f(1.0f, 0.5f, 0.3f, 1.0f);
    toonCloudEmitter.endColor = ccc4f(0.8f, 0.3f, 0.1f, 0.5f);
    [effectEmitter addChild:toonCloudEmitter z:2];
    
    return effectEmitter;
}

+(CCEmitterNode *) getAreaBangEffectEmitter {
    CCNode *effectEmitter = [CCNode node];
    CCParticleBlastWave *blastWaveEmitter = [CCParticleBlastWave node];
    blastWaveEmitter.autoRemoveOnFinish = YES;
    blastWaveEmitter.position = CGPointZero;
    [effectEmitter addChild:blastWaveEmitter z:1];
    
    CCParticleGrowingFlare *growingFlareEmitter = [CCParticleGrowingFlare node];
    growingFlareEmitter.autoRemoveOnFinish = YES;
    growingFlareEmitter.position = CGPointZero;
    [effectEmitter addChild:growingFlareEmitter z:1];
    
    CCParticleSparkFlare *sparkFlareEmitter = [CCParticleSparkFlare node];
    sparkFlareEmitter.autoRemoveOnFinish = YES;
    sparkFlareEmitter.position = CGPointZero;
    [effectEmitter addChild:sparkFlareEmitter z:1];
    
    return effectEmitter;
}

+(CCEmitterNode *) getBigBangEffectEmitter {
    CCNode *effectEmitter = [CCNode node];
    CCParticleCircleGlow *circleGlowEmitter = [CCParticleCircleGlow node];
    circleGlowEmitter.autoRemoveOnFinish = YES;
    circleGlowEmitter.position = CGPointZero;
    [effectEmitter addChild:circleGlowEmitter z:1];
    
    CCParticleStarGlow *starGlowEmitter = [CCParticleStarGlow node];
    starGlowEmitter.autoRemoveOnFinish = YES;
    starGlowEmitter.position = CGPointZero;
    starGlowEmitter.startSize = 300.0f;
    [effectEmitter addChild:starGlowEmitter z:1];
    
    CCParticleFlatGlow *flatGlowEmitter = [CCParticleFlatGlow node];
    flatGlowEmitter.autoRemoveOnFinish = YES;
    flatGlowEmitter.position = CGPointZero;
    [effectEmitter addChild:flatGlowEmitter z:1];
    
    CCParticleImplodingGlow *implodingGlowEmitter = [CCParticleImplodingGlow node];
    implodingGlowEmitter.autoRemoveOnFinish = YES;
    implodingGlowEmitter.position = CGPointZero;
    [effectEmitter addChild:implodingGlowEmitter z:1];
    
    return effectEmitter;
}
*/


#pragma mark - Test emitter particle effect

+(CCEmitterNode *) getExperimentEffectEmitter {
    CCNode *effectEmitter = [CCNode node];
    CCParticleExperiment *experimentEmitter = [CCParticleExperiment node];
    experimentEmitter.autoRemoveOnFinish = YES;
    experimentEmitter.position = CGPointZero;
    [effectEmitter addChild:experimentEmitter z:1];
    return effectEmitter;
}

@end