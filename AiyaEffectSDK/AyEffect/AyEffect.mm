//
//  AyEffect.m
//  AyEffect
//
//  Created by 汪洋 on 2017/11/28.
//  Copyright © 2017年 深圳市哎吖科技有限公司. All rights reserved.
//

#import "AyEffect.h"
#import "RenderSticker.h"
#include "AYEffectConstants.h"

void funcAyEffectMessage(int type, int ret, const char *info){
    [[NSNotificationCenter defaultCenter] postNotificationName:AiyaMessageNotification object:nil userInfo:@{AiyaMessageNotificationUserInfoKey:[NSString stringWithUTF8String:info]}];
}

@interface AyEffect (){
    std::shared_ptr<AiyaRender::RenderSticker> render;
    
    BOOL updateEffectPath;
    BOOL updateFaceData;
    BOOL updateVFlip;
}
@end

@implementation AyEffect

- (void)initGLResource{
    render = std::make_shared<AiyaRender::RenderSticker>();
    render->message = funcAyEffectMessage;
}

- (void)releaseGLtContext{
    render->release();
}

- (void)setEffectPath:(NSString *)effectPath{
    _effectPath = effectPath;
    
    updateEffectPath = YES;
}

- (void)setFaceData:(void *)faceData{
    _faceData = faceData;
    
    updateFaceData = YES;
}

- (void)setEnalbeVFilp:(BOOL)enalbeVFilp{
    _enalbeVFilp = enalbeVFilp;
    
    updateVFlip = YES;
}

- (void)processWithTexture:(GLuint)texture width:(GLuint)width height:(GLuint)height{
    if (updateEffectPath) {
        std::string path(self.effectPath.UTF8String);
        render->setParam("StickerType", (void *)path.c_str());
        
        updateEffectPath = NO;
    }
    
    if (updateFaceData) {
        render->setParam("FaceData", _faceData);
        
        updateFaceData = NO;
    }else {
        render->setParam("FaceData", NULL);
    }
    
    if (updateVFlip) {
        int enable = self.enalbeVFilp;
        render->setParam("EnableVFlip",&enable);
    }
    
    render->draw(texture, width, height, NULL);
    
}

- (void)pauseProcess{
    int defaultValue = 1;
    render->setParam("Pause", &defaultValue);
}

- (void)resumeProcess{
    int defaultValue = 1;
    render->setParam("Resume", &defaultValue);
}

@end
