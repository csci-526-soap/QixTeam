#import "CCParticleFlare.h"
#import "CCMath.h"

#pragma mark - CCParticleBurningFlare
@implementation CCParticleBurningFlare
-(id) init
{
    if( (self=[self initWithFile:@"burningFlare.plist"]) ) {
	}
	return self;
}
@end

#pragma mark - CCParticleBurstFlare
@implementation CCParticleBurstFlare
-(id) init
{
    if( (self=[self initWithFile:@"burstFlare.plist"]) ) {
	}
	return self;
}
@end

#pragma mark - CCParticleImplodingFlare
@implementation CCParticleImplodingFlare
-(id) init {
    if( (self=[self initWithFile:@"implodingFlare.plist"]) ) {
        self.startHeightScale = 1.5f;
        self.startHeightScaleVar = 1.0f;
        self.endHeightScale = 2.5f;
        self.delegate = self;
    }
    return self;
}

-(void) updateParticleSpeed:(tCCParticle *)p elapsed:(float)e dt:(float)dt {
    p->mode.A.speed = CC_LINEAR(-10, 150, _elapsed);
}

-(void) updateParticleColor:(tCCParticle *)p elapsed:(float)e dt:(float)dt {
    if (_elapsed < 0.5f)
        p->color.a = CC_LINEAR(2, 0, _elapsed);
    else
        p->color.a = CC_LINEAR(-2, 1, _elapsed);
}
@end

#pragma mark - CCParticleChaoticFlare
@implementation CCParticleChaoticFlare
-(id) init
{
    if( (self=[self initWithFile:@"chaoticFlare.plist"]) ) {
        self.startHeightScale = 2.0f;
        self.startHeightScaleVar = 0.5f;
        self.endHeightScale = 1.2f;
        self.startWidthScale = 0.5f;
        self.endWidthScale = 0.3f;
    }
    return self;
}
@end

#pragma mark - CCParticleCandleFlare
@implementation CCParticleCandleFlare
-(id) init {
    if( (self=[self initWithFile:@"candleFlare.plist"]) ) {
        self.delegate = self;
	}
	return self;
}

-(void) updateParticleSize:(tCCParticle *)p elapsed:(float)e dt:(float)dt {
    p->size = p->orgSize * CC_LINEAR(-1, 1.2f, _elapsed);
}

-(void) updateParticleColor:(tCCParticle *)p elapsed:(float)elapse dt:(float)dt {
    if (_elapsed <= 0.1) {
        p->color.a = CC_LINEAR(0.1, 0, _elapsed);
    }
    else {
        p->color.a = 1.0f;
    }
}

-(void) updateParticleSpeed:(tCCParticle *)p elapsed:(float)e dt:(float)dt {
    if (_elapsed <= 0.03) {
        p->mode.A.speed = p->mode.A.orgSpeed * CC_LINEAR(-11, 0.45f, _elapsed);
    }
    else {
        p->mode.A.speed = p->mode.A.orgSpeed * CC_LINEAR(-0.12, 0.12f, _elapsed);
    }
}
@end

#pragma mark - CCParticlePangFlare
@implementation CCParticlePangFlare
-(id) init {
    if( (self=[self initWithFile:@"pangFlare.plist"]) ) {
        self.startWidthScale = 0.0f;
        self.startWidthScaleVar = 0.5f;
        self.endWidthScale = 1.2f;
        
        self.startHeightScale = 1.0f;
        self.endHeightScale = 1.2f;
	}
	return self;
}
@end

#pragma mark - CCParticleGrowingFlare
@implementation CCParticleGrowingFlare
-(id) init
{
    if( (self=[self initWithFile:@"growingFlare.plist"]) ) {
        self.delegate = self;
	}
	return self;
}

-(void) updateParticleSize:(tCCParticle *)p elapsed:(float)e dt:(float)dt {
    if (p->elapsed <= 0.4) {
        p->size = p->orgSize * CC_LINEAR(1.0f, 0.0f, p->elapsed);
    }
    else {
        p->size = p->orgSize * CC_LINEAR(0.67f, 0.13f, p->elapsed);
    }
}

-(void) updateParticleSpeed:(tCCParticle *)p elapsed:(float)e dt:(float)dt {
    if (p->elapsed <= 0.23f) {
        p->mode.A.speed = p->mode.A.orgSpeed * CC_LINEAR(-7.8f, 2.2f, p->elapsed);
    }
    else {
        p->mode.A.speed = p->mode.A.orgSpeed * CC_LINEAR(-0.5f, 0.5f, p->elapsed);
    }
}
@end

#pragma mark - CCParticleSparkFlare
@implementation CCParticleSparkFlare
-(id) init
{
    if( (self=[self initWithFile:@"sparkFlare.plist"]) ) {
        self.startWidthScale = 0.5f;
        self.endWidthScale = 0.5f;
        self.delegate = self;
	}
	return self;
}

-(void) updateParticleSize:(tCCParticle *)p elapsed:(float)e dt:(float)dt {
    p->size = p->orgSize * CC_LINEAR(1.0f, 0.0f, p->elapsed);
}

-(void) updateParticleSpeed:(tCCParticle *)p elapsed:(float)e dt:(float)dt {
    p->mode.A.speed = p->mode.A.orgSpeed * CC_LINEAR(-0.4f, 1.0f, _elapsed);
}
@end

