//
//  RecogizeCardManager.h
//  身份证识别(openCV+TesseractOCR)
//
//  Created by Orangels on 16/11/25.
//  Copyright © 2016年 ls. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
typedef void(^compleateBlock)(NSString* text);

@interface RecogizeCardManager : NSObject

+ (instancetype)shardRecogizeCardManager;

- (void)recogizeCardWithImage:(UIImage *)image compleate:(compleateBlock)block;

@end
