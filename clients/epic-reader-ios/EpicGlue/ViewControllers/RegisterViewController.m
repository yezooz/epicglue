//
//  RegisterViewController.m
//  EpicGlue
//
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "RegisterViewController.h"
#import "ECSlidingViewController.h"
#import "ItemCollectionViewController.h"
#import "RightMenuViewController.h"
#import "AppDelegate.h"
#import "UIColor+EG.h"

@interface RegisterViewController () <UITextFieldDelegate>
{
    IBOutlet UITextField *textFieldEmail;
    IBOutlet UITextField *textFieldPassword;
    IBOutlet UITextField *textFieldConfirmPass;
    IBOutlet NSLayoutConstraint *scrollVIewConstraint;
    IBOutlet NSLayoutConstraint *viewConstraint;
}

@property(strong, nonatomic) IBOutlet UIButton *buttonAlreadyAccount;
@property(strong, nonatomic) IBOutlet UIButton *buttonRegister;

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    textFieldConfirmPass.delegate = self;
    textFieldEmail.delegate = self;
    textFieldPassword.delegate = self;

    _buttonAlreadyAccount.enabled = YES;
    _buttonRegister.enabled = YES;
    [textFieldEmail becomeFirstResponder];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardWillHideNotification object:nil];

    [self setNotifications];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGFloat height = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationOption = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;

    [UIView animateWithDuration:animationDuration delay:0 options:(UIViewAnimationOptions) animationOption animations:^{
        viewConstraint.constant = height - 49;
        [textFieldEmail setNeedsLayout];
        [textFieldEmail layoutIfNeeded];
        [textFieldPassword setNeedsLayout];
        [textFieldPassword layoutIfNeeded];
        [textFieldConfirmPass setNeedsLayout];
        [textFieldConfirmPass layoutIfNeeded];
    }                completion:^(BOOL finished) {
    }];
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
    CGFloat animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationOption = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;

    [UIView animateWithDuration:animationDuration delay:0 options:(UIViewAnimationOptions) animationOption animations:^{
        viewConstraint.constant = 0;
        [textFieldEmail setNeedsLayout];
        [textFieldEmail layoutIfNeeded];
        [textFieldPassword setNeedsLayout];
        [textFieldPassword layoutIfNeeded];
        [textFieldConfirmPass setNeedsLayout];
        [textFieldConfirmPass layoutIfNeeded];
    }                completion:^(BOOL finished) {
    }];
}

- (void)dismissKeyboard
{
    [textFieldEmail resignFirstResponder];
    [textFieldPassword resignFirstResponder];
    [textFieldConfirmPass resignFirstResponder];
}

#pragma mark - Button Actions

- (IBAction)buttonRegister:(UIButton *)sender
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSString *messageAlert;
    if ([textFieldEmail.text isEqualToString:@""]) {
        messageAlert = @"Email field is required ! ";
    } else if (![emailPredicate evaluateWithObject:textFieldEmail.text]) {
        messageAlert = @"Email not valid !";
    } else if ([textFieldPassword.text isEqualToString:@""]) {
        messageAlert = @"Password field is required !";
    } else if ([textFieldPassword.text length] < 8) {
        messageAlert = @"Password must be 8 characters";

    } else if (![textFieldPassword.text isEqualToString:textFieldConfirmPass.text]) {
        messageAlert = @"Password not matched !";
    }

    if (messageAlert) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:messageAlert
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil,
                                                                    nil];
        [alertView show];
    } else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:ENRegisterByEmailRequest object:[RegisterByEmailRequest fromJSON:@{
//                @"email" : textFieldEmail.text,
//                @"password" : textFieldPassword.text
//        }]];
    }


}

- (IBAction)buttonAlreadyAccount:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textFieldEmail resignFirstResponder];
    [textFieldPassword resignFirstResponder];
    [textFieldConfirmPass resignFirstResponder];

    return YES;
}

- (void)setNotifications
{
//    [[NSNotificationCenter defaultCenter] addObserverForName:ENRegisterByEmailSuccess
//                                                      object:nil
//                                                       queue:nil
//                                                  usingBlock:^(NSNotification *notification) {
//                                                      DDLogVerbose(@"%@", notification.name);
//
//                                                      [self transition];
//                                                  }];
//
//    [[NSNotificationCenter defaultCenter] addObserverForName:ENRegisterByEmailFailure
//                                                      object:nil
//                                                       queue:nil
//                                                  usingBlock:^(NSNotification *notification) {
//                                                      DDLogVerbose(@"%@", notification.name);
//
//                                                      APIError *err = notification.object;
//
//                                                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:err.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                                      [alertView show];
//                                                  }];
}

- (void)transition
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    // Check iPad and iPhone
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"ItemCollectionViewController"];
    NSArray *viewControllers = rootViewController.viewControllers;

    ItemCollectionViewController *itemVewController = [viewControllers firstObject];
    RightMenuViewController *rightViewController = [storyboard instantiateViewControllerWithIdentifier:@"RightMenuViewController"];

    CGRect screenRect = [[UIScreen mainScreen] bounds];

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        // For iPad Only...

        UISplitViewController *_splitController = [[UISplitViewController alloc] init];
        _splitController.viewControllers = @[rootViewController, rightViewController];

        if ([_splitController respondsToSelector:@selector(setPreferredDisplayMode:)]) {
            _splitController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;

            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
                if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
                    // portrait
                    _splitController.preferredPrimaryColumnWidthFraction = 0.65;
                    _splitController.maximumPrimaryColumnWidth = _splitController.view.frame.size.width;
                } else {
                    // landscape
                    _splitController.preferredPrimaryColumnWidthFraction = 0.74;
                    _splitController.maximumPrimaryColumnWidth = _splitController.view.frame.size.width;
                }
                _splitController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:_splitController animated:YES completion:nil];
            }
        }
    } else {
        // For iphone Only..
        appDelegate.slidingController = [ECSlidingViewController slidingWithTopViewController:rootViewController];
        appDelegate.slidingController.underRightViewController = appDelegate.rightViewController;

        rootViewController.view.layer.shadowOpacity = 1.0f;
        rootViewController.view.layer.shadowRadius = 10.0f;
        rootViewController.view.layer.shadowColor = [UIColor menuDarkFont].CGColor;

        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
            appDelegate.slidingController.anchorLeftRevealAmount = appDelegate.slidingController.view.frame.size.width - (appDelegate.slidingController.view.frame.size.width / 4);
        } else {
            appDelegate.slidingController.anchorLeftRevealAmount = appDelegate.slidingController.view.frame.size.width - (appDelegate.slidingController.view.frame.size.width / 4);
        }

        [rootViewController.view addGestureRecognizer:appDelegate.slidingController.panGesture];
        appDelegate.slidingController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:appDelegate.slidingController animated:YES completion:nil];
    }
}

@end
