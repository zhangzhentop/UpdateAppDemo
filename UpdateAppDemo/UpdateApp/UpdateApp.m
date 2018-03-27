//
//  HSUpdateApp.m
//  HSUpdateAppDemo
//
//  Created by 侯帅 on 2017/5/8.
//  Copyright © 2017年 com.houshuai. All rights reserved.
//

#import "UpdateApp.h"
#import <AFNetworking/AFNetworking.h>
@implementation UpdateApp

+(instancetype)sharedManager{
    static UpdateApp *updateApp = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        updateApp = [[self alloc] init];
    });
    return updateApp;
}

-(AFHTTPSessionManager *)baseHtppRequestWith:(NSString *)url{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:url]];
    [manager.requestSerializer setTimeoutInterval:30];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/octet-stream" ,@"text/json", @"text/javascript", @"text/html",@"text/plain",@"image/jpeg",@"image/png", nil];
    return manager;
}
-(void)getDataWithUrl:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    @try {
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        AFHTTPSessionManager *manager = [self baseHtppRequestWith:url];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        (manager.requestSerializer).timeoutInterval = 10;
        
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary * dict = [self dictionaryWithJsonString:str];
            if ([[dict[@"code"] description] isEqualToString:@"-3"]) {
                successBlock(@{@"data":@"",@"message":@""}, response.statusCode);
            }else{
                if ([[dict[@"code"] description] isEqualToString:@"-2"]) {
                }
                successBlock(dict,response.statusCode);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
            NSString *strErrorMsg;
            if (response.statusCode == 401) {
                strErrorMsg = @"";
            } else if (response.statusCode/100 == 5) {
                strErrorMsg = @"";
            } else if (response.statusCode/100 == 3) {
                strErrorMsg = @"";
            } else {
                strErrorMsg = [error localizedDescription];
            }
            failureBlock(error,response.statusCode,strErrorMsg);
        }];
    }
    @catch (NSException *exception) {
        
    }
}
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    
    if(jsonString == nil){
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(void)updateWithAPPID:(NSString *)appId withBundleId:(NSString *)bundelId block:(UpdateBlock)block{
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    __block NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    NSString *currentVStr = [currentVersion mutableCopy];
    NSString *urlStr = @"";
    
    //应用信息地址
    if (appId != nil) {
        //App ID
        urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",appId];
        NSLog(@"【1】当前为APPID检测，您设置的APPID为:%@  当前版本号为:%@",appId,currentVersion);
    }else if (bundelId != nil){
        //bundleId
        urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@&country=cn",bundelId];
        NSLog(@"【1】当前为BundelId检测，您设置的bundelId为:%@  当前版本号为:%@",bundelId,currentVersion);
    }else{
        NSString *currentBundelId=infoDic[@"CFBundleIdentifier"];
        urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@&country=cn",currentBundelId];
        NSLog(@"【1】当前为自动检测检测,  当前版本号为:%@",currentVersion);
    }
    
    [self getDataWithUrl:urlStr successBlock:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200) {
            NSDictionary *appInfoDic = responseObject[@"results"][0];
            int resultCount = [responseObject[@"resultCount"] intValue];
            if (resultCount == 0) {
                NSLog(@"检测出未上架的APP或者查询不到");
                block(currentVStr,@"",@"",NO,@"");
                return;
            }
            
            //App Store 版本号
            NSString *appStoreVersion = appInfoDic[@"version"];
            
            //当前版本号 三段处理
            NSArray *currentArr = [currentVersion componentsSeparatedByString:@"."];
            if (currentArr.count == 2) {
                currentVersion = [NSString stringWithFormat:@"%@.0",currentVersion];
            }
            
            //App Store 版本号 三段处理
            NSArray *asvArr = [appStoreVersion componentsSeparatedByString:@"."];
            if (asvArr.count == 2) {
                appStoreVersion = [NSString stringWithFormat:@"%@.0",appStoreVersion];
            }
            
            if ([self versions1:currentVersion minForVersion2:appStoreVersion]) {
                block(currentVStr,appInfoDic[@"version"],appInfoDic[@"trackViewUrl"],YES,appInfoDic[@"releaseNotes"]);
            }
        }else{
            
        }
    } failureBlock:^(NSError *e, NSInteger statusCode, NSString *errorMsg) {
        
    }];
}

-(BOOL)versions1:(NSString *)currentVersion minForVersion2:(NSString *)newVersion{

    NSArray *currentArr = [currentVersion componentsSeparatedByString:@"."];
    NSArray *newArr = [newVersion componentsSeparatedByString:@"."];
    
    if ([newArr[0] intValue] > [currentArr[0] intValue]) {
        return YES;
    }

    if([newArr[0] intValue] == [currentArr[0] intValue]){
        if ([newArr[1] intValue] >= [currentArr[1] intValue]) {
            if ([newArr[1] intValue] > [currentArr[1] intValue]){
                return YES;
            }

            if ([newArr[2] intValue] > [currentArr[2] intValue]) {
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}

@end
