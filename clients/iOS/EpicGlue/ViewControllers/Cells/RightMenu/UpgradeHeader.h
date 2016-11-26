//
// Created by Marek Mikuliszyn on 18/07/16.
// Copyright (c) 2016 Only Epic Apps. All rights reserved.
//




@protocol HeaderUpgradeTableViewDelegate <NSObject>

@end

@interface UpgradeHeader : UITableViewHeaderFooterView

@property(strong, nonatomic) IBOutlet UILabel *planName;
@property(strong, nonatomic) IBOutlet UIButton *upgradeBtn;

@property(unsafe_unretained) id <HeaderUpgradeTableViewDelegate> delegate;

@end