//
//  PlanListCollectionViewController.m
//  EpicGlue
//
//  Created by InfoEnum01 on 07/03/16.
//  Copyright © 2016 Only Epic Apps. All rights reserved.
//

#import "PlanListCollectionViewController.h"
#import "PlanCollectionViewCell.h"
#import "UserManager.h"
#import "Plan.h"

#import "ARAnalytics.h"


@implementation PlanListCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PlanCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([PlanCollectionViewCell class])];

    [ARAnalytics event:EVPurchaseOpen];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[UserManager instance] getPlans] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlanCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PlanCollectionViewCell class]) forIndexPath:indexPath];

    Plan *plan = [[UserManager instance] getPlans][(NSUInteger) indexPath.row];
    cell.labelPlan.text = plan.name;
    cell.buttonChooseMonth.titleLabel.text = [plan pricePerMonthString];
    cell.buttonChooseYear.titleLabel.text = [plan pricePerYearString];

    if ([plan isPurchasable]) {
        cell.viewPrices.hidden = YES;
    } else {
        cell.viewPrices.hidden = NO;
    }
    cell.tag = indexPath.row;

    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"CircleSmall.png"];

    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];

    NSMutableString *benefitsString;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@" "];

    for (NSString *string in [plan benefits]) {
        [attributedString appendAttributedString:attrStringWithImage];
        benefitsString = [NSMutableString stringWithFormat:@"   %@ \n ", string];

        NSMutableAttributedString *attributedStringTest = [[NSMutableAttributedString alloc] initWithString:benefitsString];
        [attributedString appendAttributedString:attributedStringTest];
    }

    cell.labelPlanDetail.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
    cell.labelPlanDetail.attributedText = attributedString;
    cell.buttonChooseMonth.tag = indexPath.row;
    cell.buttonChooseYear.tag = indexPath.row;

    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableString *stringMutable;
    NSDictionary *planDict = [[UserManager instance] getPlans][(NSUInteger) indexPath.row];
    NSArray *stringArray = [planDict valueForKey:@"benefits"];
    for (NSString *string in stringArray) {
        [stringMutable appendFormat:@"    %@ \n", string];
    }
    CGSize itemCellSize = CGSizeMake(self.view.frame.size.width, 210 + 35 * [stringArray count]); //210 fix height and
    return itemCellSize;
}

- (IBAction)backButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
