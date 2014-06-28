//
//  CCRenderTexture+Percentage.m
//  Scratch
//
//  Created by Christopher Wilson on 30/04/2012.
//  Copyright (c) 2012 abitofcode ltd. All rights reserved.
//

#import "CCRenderTexture.h"
#import "CCRenderTexture+Percentage.h"

@implementation CCRenderTexture (Percentage)

-(float)getPercentageTransparent
{
    NSAssert(_pixelFormat == kCCTexture2DPixelFormat_RGBA8888,@"only RGBA8888 can be saved as image");
	
	CGSize s = [_texture contentSizeInPixels];
	int tx = s.width;
	int ty = s.height;
	
    int bitsPerPixel                = 4 * 8;
    int bytesPerPixel               = bitsPerPixel / 8;
	int bytesPerRow					= bytesPerPixel * tx;
	NSInteger myDataLength			= bytesPerRow * ty;
    
    int numberOfPixels              = tx * ty;
    float numberOfTransparent       = 0;
	
	GLubyte *buffer	= malloc(sizeof(GLubyte)*myDataLength);
	
	if( ! (buffer) ) {
		CCLOG(@"cocos2d: CCRenderTexture#getUIImageFromBuffer: not enough memory");
        free(buffer);
		return -1.0f;
	}
	
	[self begin];
    glReadPixels(0,0,tx,ty,GL_RGBA,GL_UNSIGNED_BYTE, buffer);
	[self end];
    
    
    int x,y;
	for(y = 0; y < ty; y++) {  
        // just want the last byte (alpha) for each pixel
		for(x = 0; x < tx; x++) {
            GLubyte alpha = buffer[(y * 4 * tx + ((x * 4)+3))];
            if(alpha == 0) {
                numberOfTransparent++;   
            }
		}
	}    
    
    free(buffer);
    
    return (numberOfTransparent/numberOfPixels)*100;
}

@end
