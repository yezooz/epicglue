#import <StoreKit/StoreKit.h>
#import <FHSTwitterEngine/FHSTwitterEngine.h>
#import "UserClient.h"

#import "RefreshProfileResponse.h"
#import "RegisterByDeviceIdResponse.h"
#import "Payload.h"
#import "APIError.h"
#import "Plan.h"
#import "Settings.h"
#import "HUDNotification.h"
#import "ARAnalytics.h"

@implementation UserClient

+ (instancetype)instance
{
    static UserClient *_instance = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        _instance = [[self alloc] init];
    });

    return _instance;
}

- (void)me
{
    [self GET:[self getURLWithSuffix:@"me"]
    onSuccess:^(JSONResponse *json) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ENRefreshedProfile object:[RefreshProfileResponse fromJSON:json]];
    }
    onFailure:^(APIError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ENRefreshedProfile object:error];
    }];
}

- (void)registerDeviceId:(NSString *)deviceId
{
    Payload *payload = [Payload withDictionary:@{@"device_id": [[NSUUID UUID] UUIDString]}];

    [self POST:[self getURLWithSuffix:@"register/device"]
   withPayload:payload
     onSuccess:^(JSONResponse *json) {
         [[NSNotificationCenter defaultCenter] postNotificationName:ENRegisteredDevice object:[RegisterByDeviceIdResponse fromJSON:json]];
     }
     onFailure:^(APIError *error) {
         [[NSNotificationCenter defaultCenter] postNotificationName:ENRegisteredDevice object:error];
     }];
}

- (void)payForPlan:(Plan *)plan usingTransaction:(SKPaymentTransaction *)transaction
{
    NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];

    [self POST:[self getURLWithSuffix:@"payment/pay"]
   withPayload:[Payload withDictionary:@{@"receipt": receiptData.base64Encode}]
     onSuccess:^(JSONResponse *json) {
         // Refresh profile
         [[UserClient instance] me];

         [[NSNotificationCenter defaultCenter] postNotificationName:ENPaymentsAcknowledged object:nil];
     }
     onFailure:^(APIError *error) {
         DDLogError(@"Payment failed %@", error.localizedDescription);
     }];

    // Analytics
    [ARAnalytics event:EVPurchase withProperties:@{
            @"value": plan.pricePerMonth,
            @"productId": plan.productId,
    }];

//    AMPRevenue *revenue = [[AMPRevenue revenue] setProductIdentifier:plan.productId];
//    [revenue setQuantity:1];
//    [revenue setPrice:plan.price];
//    [revenue setReceipt:receiptData];
//    [[Amplitude instance] logRevenueV2:revenue];
}

- (void)submitFeedback:(NSString *)message
{
    Payload *payload = [Payload withDictionary:@{@"feedback": message}];

    [self POST:[self getURLWithSuffix:@"feedback"]
   withPayload:payload
     onSuccess:^(JSONResponse *json) {
         [ARAnalytics event:EVFeedback];

         DDLogInfo(@"Feedback sent: %@", message);

         [[HUDNotification instance] displayNotificationMessage:@"Thank you!"];
     }
     onFailure:^(APIError *error) {
         DDLogError(@"Failed to send feedback: %@", message);
     }];
}

@end