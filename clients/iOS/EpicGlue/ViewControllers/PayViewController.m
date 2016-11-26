//
//  PayViewController.m
//  EpicGlue
//
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "PayViewController.h"

@interface PayViewController ()
{
    IBOutlet UIButton *buttonClose;

    IBOutlet UIView *borderView;
    IBOutlet UIView *planView;
    IBOutlet UILabel *labelMessage;
}
@end

@implementation PayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    buttonClose.hidden = YES;
    borderView.layer.cornerRadius = 5;
    borderView.layer.masksToBounds = YES;
    borderView.layer.borderWidth = 2;
    borderView.layer.borderColor = [UIColor darkGrayColor].CGColor;

    // Buttons
    [buttonClose.layer setShadowOffset:CGSizeMake(5, 5)];
    [buttonClose.layer setShadowColor:[[UIColor colorWithWhite:0.330 alpha:1.000] CGColor]];
    [buttonClose.layer setShadowOpacity:0.5];
}

#pragma mark- Buttons Actions

- (IBAction)buttonDismiss:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buttonPlanA:(UIButton *)sender
{
    [self hideView];
}

- (IBAction)buttonPlanB:(UIButton *)sender
{
    [self hideView];
}

- (IBAction)buttonPlanC:(UIButton *)sender
{
    [self hideView];
}

- (IBAction)buttonClose:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideView
{
    labelMessage.text = @"Thank You";
    labelMessage.textAlignment = NSTextAlignmentCenter;
    buttonClose.hidden = NO;

    [UIView transitionWithView:planView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        planView.hidden = YES;
    }               completion:nil];
}
@end
