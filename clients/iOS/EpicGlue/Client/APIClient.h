// Main API connectivity client
//
// Created by Marek Mikuliszyn on 16/08/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//



@class APIError;
@class Payload;
@protocol Response;
@protocol Notification;
@class JSONResponse;
@class AFHTTPRequestOperationManager;
@class AMPDeviceInfo;


@interface APIClient : NSObject

@property(atomic) AFHTTPRequestOperationManager *manager;
@property(atomic) AMPDeviceInfo *deviceInfo;
@property(atomic) int inFlight;

+ (instancetype)instance;

- (NSURL *)getURLWithSuffix:(NSString *)suffix;

- (NSString *)buildGETQueryFromURL:(NSURL *)url;

- (AFHTTPRequestOperationManager *)newManager;

- (void)GET:(NSURL *)url
  onSuccess:(void (^)(JSONResponse *json))success
  onFailure:(void (^)(APIError *error))failure;

- (void)GET:(NSURL *)url
  onSuccess:(void (^)(JSONResponse *json))success
  onFailure:(void (^)(APIError *error))failure
     notify:(id <Notification>)notification;

- (void)POST:(NSURL *)url
 withPayload:(Payload *)payload
   onSuccess:(void (^)(JSONResponse *json))success
   onFailure:(void (^)(APIError *error))failure;

- (void)POST:(NSURL *)url
 withPayload:(Payload *)payload
   onSuccess:(void (^)(JSONResponse *json))success
   onFailure:(void (^)(APIError *error))failure
      notify:(id <Notification>)notification;

- (void)PUT:(NSURL *)url
withPayload:(Payload *)payload
  onSuccess:(void (^)(JSONResponse *json))success
  onFailure:(void (^)(APIError *error))failure;

- (void)PUT:(NSURL *)url
withPayload:(Payload *)payload
  onSuccess:(void (^)(JSONResponse *json))success
  onFailure:(void (^)(APIError *error))failure
     notify:(id <Notification>)notification;

- (void)DELETE:(NSURL *)url
   withPayload:(Payload *)payload
     onSuccess:(void (^)(JSONResponse *json))success
     onFailure:(void (^)(APIError *error))failure;

- (void)DELETE:(NSURL *)url
   withPayload:(Payload *)payload
     onSuccess:(void (^)(JSONResponse *json))success
     onFailure:(void (^)(APIError *error))failure
        notify:(id <Notification>)notification;

@end