//
//  NavigationBar.m
//  EpicGlue
//
//  Created by InfoEnum01 on 08/02/16.
//  Copyright © 2016 Only Epic Apps. All rights reserved.
//

#import "NavigationBar.h"

@implementation NavigationBar

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize sizeThatFits = [super sizeThatFits:size];

    sizeThatFits.height = 60;

    return sizeThatFits;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    Class UINavigationButtonClass = NSClassFromString(@"UINavigationButton");

    for (UIView *view in self.subviews) {
        if ([view isMemberOfClass:[UIView class]] ||
                [view isMemberOfClass:UINavigationButtonClass]) {
            CGRect frame = view.frame;

            frame.origin.y = (self.frame.size.height - view.frame.size.height) / 2;
            view.frame = frame;
        }
    }
}

@end
