//
//  ServiceHeader.m
//  EpicGlue
//
//  Created by Marek Mikuliszyn on 12/03/16.
//  Copyright © 2016 Only Epic Apps. All rights reserved.
//

#import "ServiceHeader.h"

@implementation ServiceHeader

- (void)awakeFromNib
{
    [super awakeFromNib];

    _colorView.layer.cornerRadius = _colorView.frame.size.height / 2;
}

@end
