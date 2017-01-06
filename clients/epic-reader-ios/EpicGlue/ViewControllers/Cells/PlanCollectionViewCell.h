//
//  PlanCollectionViewCell.h
//  EpicGlue
//
//  Created by InfoEnum01 on 02/03/16.
//  Copyright © 2016 Only Epic Apps. All rights reserved.
//


#import "TTTAttributedLabel.h"

@interface PlanCollectionViewCell : UICollectionViewCell


@property(strong, nonatomic) IBOutlet UILabel *labelPlan;
@property(strong, nonatomic) IBOutlet UILabel *labelPlanDetail;
@property(strong, nonatomic) IBOutlet UIView *viewBasePlan;
@property(strong, nonatomic) IBOutlet UIView *viewPrices;
@property(strong, nonatomic) IBOutlet UIButton *buttonChooseMonth;
@property(strong, nonatomic) IBOutlet UIButton *buttonChooseYear;
@end


