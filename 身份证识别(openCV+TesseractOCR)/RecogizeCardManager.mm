//
//  RecogizeCardManager.m
//  身份证识别(openCV+TesseractOCR)
//
//  Created by Orangels on 16/11/25.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "RecogizeCardManager.h"

#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#import <TesseractOCR/TesseractOCR.h>

@implementation RecogizeCardManager
/**
 *  单例
 *
 *  @return 单例
 */
+ (instancetype)shardRecogizeCardManager{
    static RecogizeCardManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RecogizeCardManager alloc] init];
    });
    return manager;
}
/**
 *  识别照片方法
 *
 *  @param image 身份证照片
 *  @param block 识别完成的回调
 */
- (void)recogizeCardWithImage:(UIImage *)image compleate:(compleateBlock)block{
    UIImage* numImage = [self openCVScanCard:image];
    if (!numImage) {
        block(nil);
    }
    [self tesseractRecognizeImage:numImage compleate:block];
}

#if 1

/**
 *  灰度化处理,二值化,腐蚀,轮廓检测,定位号码区域并返回
 *
 *  @param image 身份证图片
 *
 *  @return 处理后的 号码区域图片
 */
- (UIImage*)openCVScanCard:(UIImage*)image{
    
    //uiimage 转换成 Mat
    cv::Mat resultImage;
    UIImageToMat(image, resultImage);
    
    //转成灰度图
    cvtColor(resultImage, resultImage, cv::COLOR_BGR2GRAY);
    
    
    //二值化
    cv::threshold(resultImage, resultImage, 100, 255, CV_THRESH_BINARY);
    
    //腐蚀,填充
    cv::Mat erodeElement = getStructuringElement(cv::MORPH_RECT, cv::Size(26,26));
    cv::erode(resultImage, resultImage, erodeElement);
    
    //轮廓检测
    std::vector<std::vector<cv::Point>> contours;//定义一个容器来存储所有检测到的轮廓
    cv::findContours(resultImage, contours, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, cvPoint(0, 0));
    
    //取出身份证号码区域
    std::vector<cv::Rect> rects;
    cv::Rect numberRect = cv::Rect(0,0,0,0);
    std::vector<std::vector<cv::Point>>::const_iterator itContours = contours.begin();
    for (; itContours != contours.end(); ++itContours) {
        cv::Rect rect = cv::boundingRect(*itContours);
        rects.push_back(rect);
        //算法
        if (rect.width > numberRect.width && rect.width > rect.height*5) {
            numberRect = rect;
        }
    }
    //定位失败
    if (numberRect.width == 0 || numberRect.height == 0) {
        return nil;
    }
    //定位成功,去原图截取身份证号码区域,并转成灰度图,进行二值化处理
    cv::Mat matImage;
    UIImageToMat(image, matImage);
    resultImage = matImage(numberRect);
    cvtColor(resultImage,resultImage,cv::COLOR_BGR2GRAY);
    cv::threshold(resultImage, resultImage, 80, 255, CV_THRESH_BINARY);
    //mat 转话 uiimage
    UIImage* numImage = MatToUIImage(resultImage);
    
    return numImage;
}
/**
 *  利用 tesseract 识别数字
 *
 *  @param image 处理后的号码区域图片
 *  @param block 识别后的回调
 */
- (void)tesseractRecognizeImage:(UIImage*)image compleate:(compleateBlock)block{
   
    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
    tesseract.image = [image g8_blackAndWhite];
    //这里可能是语言包的问题,会报错,选择不了engineMode
//    tesseract.engineMode = G8OCREngineModeCubeOnly;
    tesseract.pageSegmentationMode = G8PageSegmentationModeAuto;
//    tesseract.image = image;
    //开始识别
    [tesseract recognize];
    NSLog(@"%@",tesseract.recognizedText);
    block(tesseract.recognizedText);
    
}
#endif



@end















































