//
//  PlanCollectionViewCell.m
//  EpicGlue
//
//  Created by InfoEnum01 on 02/03/16.
//  Copyright © 2016 Only Epic Apps. All rights reserved.
//

#import "PlanCollectionViewCell.h"
#import "UserManager.h"
#import "Plan.h"

#import "Settings.h"
#import "ARAnalytics.h"

@implementation PlanCollectionViewCell

- (void)awakeFromNib
{
    self.buttonChooseMonth.layer.masksToBounds = YES;
    self.buttonChooseMonth.layer.cornerRadius = self.buttonChooseMonth.frame.size.height / 2;
    self.buttonChooseYear.layer.masksToBounds = YES;
    self.buttonChooseYear.layer.cornerRadius = self.buttonChooseYear.frame.size.height / 2;

    self.viewBasePlan.layer.masksToBounds = YES;
    self.viewBasePlan.layer.cornerRadius = 15;
}

- (IBAction)buttonChooseMonthAction:(UIButton *)sender
{
    Plan *plan = [[UserManager instance] getPlans][(NSUInteger) self.buttonChooseMonth.tag];

    [ARAnalytics event:EVPurchaseStart];
    DDLogInfo(@"Pay for plan %@", plan.name);

    [[UserManager instance] payForPlan:plan];
}

- (IBAction)buttonChooseYearAction:(UIButton *)sender
{
    Plan *plan = [[UserManager instance] getPlans][(NSUInteger) self.buttonChooseMonth.tag];

    [ARAnalytics event:EVPurchaseStart];
    DDLogInfo(@"Pay for plan %@", plan.name);
    
    [[UserManager instance] payForPlan:plan];
}

@end
