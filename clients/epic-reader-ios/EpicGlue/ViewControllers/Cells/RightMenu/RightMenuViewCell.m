//
//  RightMenuViewCell.m
//  EpicGlue
//
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "RightMenuViewCell.h"

@implementation RightMenuViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.colorView.layer.cornerRadius = self.colorView.frame.size.height / 2;
    self.colorViewOnDescription.layer.cornerRadius = self.colorViewOnDescription.frame.size.height / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
