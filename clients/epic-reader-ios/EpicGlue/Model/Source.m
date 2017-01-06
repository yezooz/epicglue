//
// Created by Marek Mikuliszyn on 22/06/15.
// Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "KWValue.h"
#import "Source.h"
#import "Subscription.h"
#import "Counter.h"


@implementation Source

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    _sourceId = [json[@"id"] integerValue];
    _name = json[@"name"];
    _sourceDescription = json[@"description"];
    _icon = json[@"icon"];
    _value = json[@"value"];
    _valueAllowed = [json[@"value_allowed"] boolValue];
//    _valueHint = json[@"value_hint"];
    _valueHint = @"value_hint";
    _isLocked = [json[@"is_locked"] boolValue];

    _counter = [[Counter alloc] initWithValue:0];

    NSMutableArray *subs = [[NSMutableArray alloc] init];
    for (NSDictionary *subDict in json[@"subscriptions"]) {
        Subscription *s = [Subscription fromJSON:subDict];

        [s.counter addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];

        s.counter.value = [subDict[@"count"] integerValue];
        [subs addObject:s];
    }
    _subscriptions = subs;

    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"value"]) {
//        DDLogInfo(@"source|changed to %@", change[NSKeyValueChangeNewKey]);

        self.counter.value = [change[NSKeyValueChangeNewKey] integerValue];
    }
}

@end