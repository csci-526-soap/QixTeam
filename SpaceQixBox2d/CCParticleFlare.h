#import "cocos2d.h"

@interface CCParticleBurningFlare : CCParticleSystemQuad {}
-(id) init;
@end

@interface CCParticleBurstFlare : CCParticleSystemQuad {}
-(id) init;
@end

@interface CCParticleImplodingFlare : CCParticleSystemQuad <CCParticleSystemDelegate> {}
-(id) init;
@end

@interface CCParticleChaoticFlare : CCParticleSystemQuad {}
-(id) init;
@end

@interface CCParticleCandleFlare : CCParticleSystemQuad<CCParticleSystemDelegate> {}
-(id) init;
@end

@interface CCParticlePangFlare : CCParticleSystemQuad<CCParticleSystemDelegate> {}
-(id) init;
@end

@interface CCParticleGrowingFlare : CCParticleSystemQuad<CCParticleSystemDelegate> {}
-(id) init;
@end

@interface CCParticleSparkFlare : CCParticleSystemQuad<CCParticleSystemDelegate> {}
-(id) init;
@end
