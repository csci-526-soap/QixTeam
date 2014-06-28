#import "CCParticleExperiment.h"
#import "CCMath.h"

@implementation CCParticleExperiment
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
