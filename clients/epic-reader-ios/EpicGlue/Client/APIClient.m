//
// Created by Marek Mikuliszyn on 16/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "APIClient.h"
#import "APIError.h"
#import "Payload.h"
#import "Notification.h"
#import "JSONResponse.h"
#import "Settings.h"
#import "UserManager.h"
#import "AMPDeviceInfo.h"


@implementation APIClient

+ (instancetype)instance
{
    static APIClient *_instance = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        _instance = [[self alloc] init];
        _instance.inFlight = 0;

        [_instance addObserver:(NSObject *) self forKeyPath:@"inFlight" options:NSKeyValueObservingOptionNew context:nil];
    });

    return _instance;
}

- (AFHTTPRequestOperationManager *)newManager
{
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    _manager.requestSerializer.timeoutInterval = 30;
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", nil];
    if ([[UserManager instance] token] != nil) {
        [_manager.requestSerializer setValue:[[UserManager instance] token] forHTTPHeaderField:@"Token"];
    }

    return _manager;
}

- (NSURL *)getURLWithSuffix:(NSString *)suffix
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", ApiServer, ApiVersion, suffix]];
}

- (NSString *)buildGETQueryFromURL:(NSURL *)url
{
    NSString *joinKey = @"&";
    if ([[url absoluteString] rangeOfString:@"?"].location == NSNotFound) {
        joinKey = @"?";
    }

    if (_deviceInfo == nil) {
        _deviceInfo = [[AMPDeviceInfo alloc] init];
    }

    NSDictionary *values = @{
            @"device_id": [[NSUUID UUID] UUIDString],
            @"platform": @"ios",
            @"os_name": [_deviceInfo osName],
            @"os_version": [_deviceInfo osVersion],
            @"app_version": [_deviceInfo appVersion],
            @"device_model": [_deviceInfo model],
            @"device_manufacturer": [_deviceInfo manufacturer],
            @"country": [_deviceInfo country],
            @"language": [_deviceInfo language],
    };

    NSString *strUrl = @"";
    for (NSString *key in values) {
        strUrl = [NSString stringWithFormat:@"%@%@=%@&", strUrl, key, values[key]];
    }

    if ([_deviceInfo carrier] != nil) {
        strUrl = [NSString stringWithFormat:@"%@%@=%@&", strUrl, @"carrier", [_deviceInfo carrier]];
    }

    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    return [NSString stringWithFormat:@"%@%@%@", [url absoluteString], joinKey, strUrl];
}

- (void)GET:(NSURL *)url
  onSuccess:(void (^)(JSONResponse *json))success
  onFailure:(void (^)(APIError *error))failure
{
    [self GET:url onSuccess:success onFailure:failure notify:nil];
}

- (void)GET:(NSURL *)url
  onSuccess:(void (^)(JSONResponse *json))success
  onFailure:(void (^)(APIError *error))failure
     notify:(id <Notification>)notification
{

    if (notification != nil) {
        [notification display];
    }

    DDLogInfo(@"GET %@", url);

    self.inFlight++;

    [self newManager];
    [self.manager GET:[self buildGETQueryFromURL:url] parameters:nil success:^(AFHTTPRequestOperation *operation, id json) {
        if (success != nil) {
            success([JSONResponse fromJSON:json]);
        }

        if (notification != nil) {
            [notification hide];
        }

        self.inFlight--;
    }         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure != nil) {
            failure((APIError *) error);
        }

        if (notification != nil) {
            [notification hide];
        }

        self.inFlight--;
    }];
}

- (void)POST:(NSURL *)url
 withPayload:(Payload *)payload
   onSuccess:(void (^)(JSONResponse *json))success
   onFailure:(void (^)(APIError *error))failure
{
    [self POST:url withPayload:payload onSuccess:success onFailure:failure notify:nil];
}

- (void)POST:(NSURL *)url
 withPayload:(Payload *)payload
   onSuccess:(void (^)(JSONResponse *json))success
   onFailure:(void (^)(APIError *error))failure
      notify:(id <Notification>)notification
{

    if (notification != nil) {
        [notification display];
    }

    DDLogInfo(@"POST %@", [url absoluteString]);

    [self newManager];

    NSDictionary *dictPayload = nil;
    if (payload != nil) {
        dictPayload = payload.dict;
    }

    self.inFlight++;

    [self.manager POST:[url absoluteString]
            parameters:dictPayload
               success:^(AFHTTPRequestOperation *operation, id json) {
                   if (success != nil) {
                       success([JSONResponse fromJSON:json]);
                   }

                   if (notification != nil) {
                       [notification hide];
                   }
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   if (failure != nil && operation.responseObject != nil) {
                       APIError *err = [APIError errorWithDomain:@"com.onlyepicapps.epicglue.api" code:operation.response.statusCode userInfo:@{NSLocalizedDescriptionKey: [operation.responseObject objectForKey:@"error"]}];
                       failure(err);
                   } else if (failure != nil) {
                       failure((APIError *) error);
                   }

                   if (notification != nil) {
                       [notification hide];
                   }
               }];
}

- (void)PUT:(NSURL *)url
withPayload:(Payload *)payload
  onSuccess:(void (^)(JSONResponse *json))success
  onFailure:(void (^)(APIError *error))failure
{
    [self PUT:url withPayload:payload onSuccess:success onFailure:failure notify:nil];
}

- (void)PUT:(NSURL *)url
withPayload:(Payload *)payload
  onSuccess:(void (^)(JSONResponse *json))success
  onFailure:(void (^)(APIError *error))failure
     notify:(id <Notification>)notification
{
    if (notification != nil) {
        [notification display];
    }

    DDLogInfo(@"POST %@", [url absoluteString]);

    [self newManager];

    NSDictionary *dictPayload = nil;
    if (payload != nil) {
        dictPayload = payload.dict;
    }

    self.inFlight++;

    [self.manager
            PUT:[url absoluteString]
     parameters:dictPayload
        success:^(AFHTTPRequestOperation *operation, id json) {
            if (success != nil) {
                success([JSONResponse fromJSON:json]);
            }

            if (notification != nil) {
                [notification hide];
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure != nil && operation.responseObject != nil) {
                APIError *err = [APIError errorWithDomain:@"com.onlyepicapps.epicglue.api" code:operation.response.statusCode userInfo:@{NSLocalizedDescriptionKey: [operation.responseObject objectForKey:@"error"]}];
                failure(err);
            } else if (failure != nil) {
                failure((APIError *) error);
            }

            if (notification != nil) {
                [notification hide];
            }
        }];
}

- (void)DELETE:(NSURL *)url
   withPayload:(Payload *)payload
     onSuccess:(void (^)(JSONResponse *json))success
     onFailure:(void (^)(APIError *error))failure
{
    [self DELETE:url withPayload:payload onSuccess:success onFailure:failure notify:nil];
}

- (void)DELETE:(NSURL *)url
   withPayload:(Payload *)payload
     onSuccess:(void (^)(JSONResponse *json))success
     onFailure:(void (^)(APIError *error))failure
        notify:(id <Notification>)notification
{

    if (notification != nil) {
        [notification display];
    }

    DDLogInfo(@"DELETE %@", [url absoluteString]);

    [self newManager];

    NSDictionary *dictPayload = nil;
    if (payload != nil) {
        dictPayload = payload.dict;
    }

    self.inFlight++;

    [self.manager DELETE:[url absoluteString] parameters:dictPayload success:^(AFHTTPRequestOperation *operation, id json) {
        if (success != nil) {
            success(json);
        }

        if (notification != nil) {
            [notification hide];
        }

        self.inFlight--;
    }            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogInfo(@"Error: %@", error);

        if (failure != nil) {
            failure((APIError *) error);
        }

        if (notification != nil) {
            [notification hide];
        }

        self.inFlight--;
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"inFlight"]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(int) change[NSKeyValueChangeNewKey] > 0];
    }
}

@end