//
//  SBCore.m
//  snapBuyTest
//
//  Created by mohamed ahmed on 5/3/17.
//  Copyright © 2017 mohamed.elzokla. All rights reserved.
//

#import "SBCore.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "SBIndexedImage+private.h"
#define REQUEST_TYPE_GET 1
#define REQUEST_TYPE_POST 2
#define REQUEST_TYPE_DELETE 3
#define kBaseUrl @"http://api.snapbuyapp.com"

#define CONSTRUCT_URL(url) [NSString stringWithFormat:@"%@/%@",kBaseUrl,url]

@interface SBCore()

@property NSString * apiKey;

@end

@implementation SBCore

+(instancetype)initWithApiKey:(NSString * )apiKey{
    SBCore * sharedCore = [SBCore sharedCore];
    if (!sharedCore.apiKey) {
        sharedCore.apiKey = apiKey;
    }
    return  sharedCore;
}

+(instancetype)sharedCore{
    static SBCore *sharedObj = nil;
    @synchronized(self) {
        if (sharedObj == nil)
            sharedObj = [[self alloc] init];
    }
    return sharedObj;
}


+(void)createApplication:(NSString *)name onComplete:(void (^)(SBApplication * app,BOOL success,NSString * errorMessage))completionHandler{
    [SBCore baseRequest:CONSTRUCT_URL(@"applications") type:REQUEST_TYPE_POST params:@{@"name":name} OnComplete:^(NSDictionary *dict, BOOL success) {
        if (success && [dict objectForKey:@"applicationID"]) {
            SBApplication * app =[SBApplication new];
            app.appId = [dict objectForKey:@"applicationID"];
            app.appName = name;
            completionHandler(app,YES,nil);
        }
        else{
            completionHandler(nil,NO,[dict objectForKey:@"errorMessage"]);
        }
    }];
}


+(void)deleteApplication:(NSNumber*)appId onComplete:(void (^)(BOOL success,NSString * errorMessage))completionHandler{
    [SBCore baseRequest:CONSTRUCT_URL(@"applications") type:REQUEST_TYPE_DELETE params:@{@"id":appId} OnComplete:^(NSDictionary *dict, BOOL success) {
        if (success ) {
            completionHandler(YES,nil);
        }
        else{
            completionHandler(NO,[dict objectForKey:@"errorMessage"]);
        }
    }];
}

+(void)getApplicationInfo:(NSNumber*)appId onComplete:(void (^)(SBApplication * app,BOOL success,NSString * errorMessage))completionHandler{
    NSString * url = [NSString stringWithFormat:@"applications/%@",appId];
    [SBCore baseRequest:CONSTRUCT_URL(url) type:REQUEST_TYPE_GET params:nil OnComplete:^(NSDictionary *dict, BOOL success) {
        if (success ) {
            SBApplication * appInfo =[SBApplication new];
            appInfo.appId = [dict objectForKey:@"appID"];
            appInfo.subscriptionId = [dict objectForKey:@"subscriptionID"];
            appInfo.appName = [dict objectForKey:@"name"];

            completionHandler(appInfo,YES,nil);
        }
        else{
            completionHandler(nil,NO,[dict objectForKey:@"errorMessage"]);
        }
    }];
}
+(void)getMyApplicationsOnComplete:(void (^)(NSArray <SBApplication *>* ,BOOL success,NSString * errorMessage))completionHandler{

    [SBCore baseRequest:CONSTRUCT_URL(@"applications") type:REQUEST_TYPE_GET params:nil OnComplete:^(NSDictionary *dict, BOOL success) {
        if (success ) {
            NSMutableArray <SBApplication*>* result = [NSMutableArray new];
            for (NSDictionary * oneApp in [dict objectForKey:@"applications"]) {
                SBApplication * appInfo =[SBApplication new];
                appInfo.appId = [oneApp objectForKey:@"appID"];
                appInfo.subscriptionId = [oneApp objectForKey:@"subscriptionID"];
                appInfo.appName = [oneApp objectForKey:@"name"];
                [result addObject:appInfo];
            }
            
            completionHandler(result,YES,nil);
        }
        else{
            completionHandler(nil,NO,[dict objectForKey:@"errorMessage"]);
        }
    }];
}



+(void)changeAppName:(NSNumber*)appId name:(NSString * )name onComplete:(void (^)(BOOL success,NSString * errorMessage))completionHandler{


    [SBCore baseRequest:CONSTRUCT_URL(@"applications/update") type:REQUEST_TYPE_POST params:@{@"id":appId,@"name":name} OnComplete:^(NSDictionary *dict, BOOL success) {
        if (success ) {
            completionHandler(YES,nil);
        }
        else{
            completionHandler(NO,[dict objectForKey:@"errorMessage"]);
        }
    }];

}


/////////////////////////////IMAGE API ////////////////////
#pragma  mark - IMAGE API
+(void)indexImage:(SBIndexedImage*)image appId:(NSNumber*)appId onComplete:(void (^)(BOOL success,NSString * errorMessage))completionHandler{

    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:[image convertToDict]];
    [params setObject:appId forKey:@"appid"];
    
    
    
    SBCore * this = [SBCore sharedCore];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:this.apiKey forHTTPHeaderField:@"x-api-key"];
    [manager POST:CONSTRUCT_URL(@"images/index") parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        [formData appendPartWithFileData:[params objectForKey:@"image"] name:@"image" fileName:@"imagefilename.jpeg" mimeType:@"image/jpeg"];

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        
                    completionHandler(YES,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *dict = operation.responseObject;
        if ([dict objectForKey:@"error"] || [dict objectForKey:@"errorMessage"]) {
            completionHandler(NO,nil);
        }else{
            completionHandler(NO,@{@"errorMessage":error.description});
        }
        
    }];

}

+(void)checkIfImageIndexed:(SBIndexedImage*)image appId:(NSNumber*)appId onComplete:(void (^)(BOOL success,NSString * errorMessage))completionHandler{

    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:[image convertToDict]];
    [params setObject:appId forKey:@"appid"];
        [SBCore baseRequest:CONSTRUCT_URL(@"images/check") type:REQUEST_TYPE_POST params:params OnComplete:^(NSDictionary *dict, BOOL success) {
            if (success ) {
                completionHandler(YES,nil);
            }
            else{
                completionHandler(NO,[dict objectForKey:@"errorMessage"]);
            }
        }];

}







+(void)baseRequest:(NSString *)url type:(int)requestType params:(NSDictionary*)params OnComplete:(void (^)(NSDictionary * dict,BOOL success))completionHandler{
    SBCore * this = [SBCore sharedCore];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:this.apiKey forHTTPHeaderField:@"x-api-key"];

    
    switch (requestType) {
        case REQUEST_TYPE_POST:
        {
            [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dict = (NSDictionary *)responseObject;

                completionHandler(dict,YES);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSDictionary *dict = operation.responseObject;
                if ([dict objectForKey:@"error"] || [dict objectForKey:@"errorMessage"]) {
                    completionHandler(dict,NO);
                }else{
                    completionHandler(@{@"errorMessage":error.description},NO);
                }
                
            }];
            break;
        }
        case REQUEST_TYPE_GET:
        {
            [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *dict = (NSDictionary *)responseObject;
                completionHandler(dict,YES);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSDictionary *dict = operation.responseObject;
                if ([dict objectForKey:@"error"] || [dict objectForKey:@"errorMessage"]) {
                    completionHandler(dict,NO);
                }else{
                    completionHandler(@{@"errorMessage":error.description},NO);
                }
                
            }];
            break;
        }
        case REQUEST_TYPE_DELETE:
        {
            
            [manager DELETE:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dict = (NSDictionary *)responseObject;
                
                completionHandler(dict,YES);

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSDictionary *dict = operation.responseObject;
                if ([dict objectForKey:@"error"] || [dict objectForKey:@"errorMessage"]) {
                    completionHandler(dict,NO);
                }else{
                    completionHandler(@{@"errorMessage":error.description},NO);
                }

            }];
            
        
            break;
        }
        default:
            break;
    }
    
   
  
    
    
    
    
}
@end
