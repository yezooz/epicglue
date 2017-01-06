//
//  EmptyViewCell.m
//  EpicGlue
//
//  Copyright © 2016 Only Epic Apps. All rights reserved.
//

#import "EmptyViewCell.h"
#import "CurrentSession.h"

@implementation EmptyViewCell
{
    __weak IBOutlet UILabel *labelName;
    __weak IBOutlet UILabel *labelSubscription;
}

- (void)awakeFromNib
{
    self.buttonAdd.layer.cornerRadius = self.buttonAdd.frame.size.width / 2;
    self.buttonAdd.layer.masksToBounds = YES;
}

- (void)setViewLabels
{
    if ([[CurrentSession instance] neverHadSubscription]) {
        labelName.text = [NSString stringWithFormat:NSLocalizedString(@"FirstSubscriptionEmptyItemViewTitle", nil)];
        labelSubscription.text = [NSString stringWithFormat:NSLocalizedString(@"FirstSubscriptionEmptyItemViewDescription", nil)];
    } else if ([CurrentSession instance].selectedTopBarOption == SelectedTabUnread) {
        labelName.text = [NSString stringWithFormat:NSLocalizedString(@"UnreadEmptyItemViewTitle", nil)];
        labelSubscription.text = [NSString stringWithFormat:NSLocalizedString(@"UnreadEmptyItemViewDescription", nil)];
    } else if ([CurrentSession instance].selectedTopBarOption == SelectedTabGlued) {
        labelName.text = [NSString stringWithFormat:NSLocalizedString(@"GluedEmptyItemViewTitle", nil)];
        labelSubscription.text = [NSString stringWithFormat:NSLocalizedString(@"GluedEmptyItemViewDescription", nil)];
    } else {
        labelName.text = [NSString stringWithFormat:NSLocalizedString(@"EmptyItemViewTitle", nil)];
        labelSubscription.text = [NSString stringWithFormat:NSLocalizedString(@"EmptyItemViewDescription", nil)];
    }
}

- (IBAction)buttonAddSubscription:(UIButton *)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickedAddSubscription:)]) {
        [self.delegate clickedAddSubscription:self];
    }
}

@end
