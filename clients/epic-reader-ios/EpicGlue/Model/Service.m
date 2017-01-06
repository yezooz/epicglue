//
// Created by Marek Mikuliszyn on 22/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "Service.h"
#import "Source.h"
#import "Counter.h"


@implementation Service

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    _category = [ServiceCategory fromJSON:json[@"category"]];
    _serviceId = [json[@"id"] integerValue];
    _shortName = json[@"short_name"];
    _name = json[@"name"];
    _serviceDescription = json[@"description"];
    _icon = json[@"icon"];
    _isLocked = [json[@"is_locked"] boolValue];
    _isLockedOriginally = [json[@"is_locked_original"] boolValue];
    _unlockURL = json[@"unlock_url"];

    if (json[@"user_id"] != nil) {
        _userId = json[@"user_id"];
    }
    if (json[@"username"] != nil) {
        _username = json[@"username"];
    }

    _counter = [[Counter alloc] initWithValue:0];

    NSMutableArray *sources = [NSMutableArray array];
    for (NSDictionary *serviceJSON in json[@"sources"]) {
        Source *source = [Source fromJSON:serviceJSON];
        [source.counter addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

        [sources addObject:source];
    }
    _sources = sources;

    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"value"]) {
        NSInteger old = 0;
        if (change[NSKeyValueChangeOldKey] != [NSNull null]) {
            old = [change[NSKeyValueChangeOldKey] integerValue];
        }
        NSInteger new = [change[NSKeyValueChangeNewKey] integerValue];

        if (old == new) {
            return;
        }

//        DDLogInfo(@"service|changed from %@ to %@", change[NSKeyValueChangeOldKey], change[NSKeyValueChangeNewKey]);

        if (self.counter.value == 0) {
//            DDLogInfo(@"%@.value = %ld", self.shortName, [new longValue]);
            self.counter.value = new;
        } else {
//            DDLogInfo(@"%@.value = %ld + (%ld - %ld)", self.shortName, [self.counter.value longValue], [new longValue], [old longValue]);
            self.counter.value = self.counter.value + (new - old);
        }
    }
}

@end