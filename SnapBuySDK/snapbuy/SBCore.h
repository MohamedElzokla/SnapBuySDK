//
//  SBCore.h
//  snapBuyTest
//
//  Created by mohamed ahmed on 5/3/17.
//  Copyright © 2017 mohamed.elzokla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBApplication.h"
#import "SBIndexedImage.h"
@interface SBCore : NSObject

+(instancetype)initWithApiKey:(NSString * )apiKey;

+(void)createApplication:(NSString *)name onComplete:(void (^)(SBApplication * app,BOOL success,NSString * errorMessage))completionHandler;

+(void)deleteApplication:(NSNumber*)appId onComplete:(void (^)(BOOL success,NSString * errorMessage))completionHandler;

+(void)getApplicationInfo:(NSNumber*)appId onComplete:(void (^)(SBApplication * app,BOOL success,NSString * errorMessage))completionHandler;

+(void)getMyApplicationsOnComplete:(void (^)(NSArray <SBApplication *>* ,BOOL success,NSString * errorMessage))completionHandler;

+(void)changeAppName:(NSNumber*)appId name:(NSString * )name onComplete:(void (^)(BOOL success,NSString * errorMessage))completionHandler;


///////////////////////// Image API ////////////////////////////

//+(void)indexImage:(SBIndexedImage*)image appId:(NSNumber*)appId onComplete:(void (^)(BOOL success,NSString * errorMessage))completionHandler;
//
//+(void)checkIfImageIndexed:(SBIndexedImage*)image appId:(NSNumber*)appId onComplete:(void (^)(BOOL success,NSString * errorMessage))completionHandler;


@end
