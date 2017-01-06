//
//  WebViewController.m
//  EpicGlue
//
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "WebViewController.h"
#import "WYPopoverController.h"
#import "PopViewController.h"
#import "MBProgressHUD.h"
#import "ArrowPopViewController.h"
#import "NJKWebViewProgressView.h"
#import "Settings.h"


@interface WebViewController () <WYPopoverControllerDelegate, PopViewControllerDelegate, MBProgressHUDDelegate, ArrowPopViewDelegate>
{
    NSString *urlStr;
    IBOutlet UIView *viewTitle;
    IBOutlet UILabel *labelTitle;
    IBOutlet UILabel *labelTitleUrl;
    WYPopoverController *popover;
    MBProgressHUD *hud;
    PopViewController *popOverView;

    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;

    CGRect rectButton;
}
@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navView.frame = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navView.frame.size.height);

    // Tap Gesture Method
    {
        [labelTitleUrl setUserInteractionEnabled:YES];
        UITapGestureRecognizer *labelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelAction)];
        [labelTitleUrl addGestureRecognizer:labelGesture];
    }

    // WebView
    {
        self.webView.delegate = self;
        urlStr = [_webUrl absoluteString];
        labelTitleUrl.text = urlStr;
//        self.navigationItem.titleView = viewTitle;

        [self.webView sizeToFit];
        self.webView.scalesPageToFit = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;

        [self.webView loadRequest:[NSURLRequest requestWithURL:_webUrl]];
    }

    //NJKWebView ProgressBar
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.progressDelegate = self;
    _progressProxy.webViewProxyDelegate = self;
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    [self.navigationController.navigationBar addSubview:_progressView];


    rectButton = CGRectMake(450, -30, 400, 100);
    [popover presentPopoverFromRect:rectButton
                             inView:self.view
           permittedArrowDirections:WYPopoverArrowDirectionDown | WYPopoverArrowDirectionRight
                           animated:YES
                            options:WYPopoverAnimationOptionFadeWithScale];
}

#pragma mark - UIWebView

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DDLogInfo(@"Failed WebView loading Time ");
}

#pragma mark - NJKWebViewProgressDelegate

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    labelTitle.text = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - PopViewDelegate

- (void)popViewController
{
    [popover dismissPopoverAnimated:YES];
    [popOverView dismissViewControllerAnimated:YES completion:Nil];
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];

    // Custom Mode
    hud.mode = MBProgressHUDModeCustomView;
    hud.delegate = self;
    hud.labelText = @"Copied";
    [hud show:YES];
    [hud hide:YES afterDelay:3];
}

#pragma mark - Orientations Method

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.navView.frame = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navView.frame.size.height);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.navView.frame = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navView.frame.size.height);
}

#pragma mark - Done Actions

- (IBAction)buttonDone:(UIBarButtonItem *)sender
{
    ArrowPopViewController *arrowPopView = [[self storyboard] instantiateViewControllerWithIdentifier:NSStringFromClass([ArrowPopViewController class])];
    arrowPopView.delegate = self;

    arrowPopView.preferredContentSize = CGSizeMake(250, 117);
    WYPopoverTheme *theme = [WYPopoverTheme theme];
    [theme setArrowHeight:10];
    [theme setArrowBase:20];
    [theme setFillTopColor:[UIColor whiteColor]];
    [theme setFillBottomColor:[UIColor whiteColor]];
    [theme setOverlayColor:[UIColor colorWithWhite:0 alpha:0.5]];

    popover = [[WYPopoverController alloc] initWithContentViewController:arrowPopView];
    popover.delegate = self;
    popover.theme = theme;
    popover.popoverLayoutMargins = UIEdgeInsetsMake(5, 5, 5, 5);
    popover.wantsDefaultContentAppearance = NO;

    [popover presentPopoverFromBarButtonItem:self.buttonSave permittedArrowDirections:WYPopoverArrowDirectionDown animated:YES];

}

- (IBAction)buttonCancel:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Label Action

- (void)labelAction
{
    popOverView = [[self storyboard] instantiateViewControllerWithIdentifier:NSStringFromClass([PopViewController class])];

    popOverView.delegate = self;
    popOverView.tableData = [urlStr componentsSeparatedByString:@""];
    popOverView.preferredContentSize = CGSizeMake(300, 44);
    WYPopoverTheme *theme = [WYPopoverTheme theme];
    [theme setArrowHeight:10];
    [theme setArrowBase:20];
    [theme setFillTopColor:[UIColor whiteColor]];
    [theme setFillBottomColor:[UIColor whiteColor]];
    [theme setOverlayColor:[UIColor colorWithWhite:0 alpha:0.5]];

    popover = [[WYPopoverController alloc] initWithContentViewController:popOverView];
    popover.delegate = self;
    popover.theme = theme;
    popover.popoverLayoutMargins = UIEdgeInsetsMake(5, 5, 5, 5);
    popover.wantsDefaultContentAppearance = NO;

    [popover presentPopoverFromRect:labelTitleUrl.bounds
                             inView:viewTitle
           permittedArrowDirections:WYPopoverArrowDirectionUp | WYPopoverArrowDirectionDown
                           animated:YES
                            options:WYPopoverAnimationOptionFadeWithScale];
}

#pragma mark -  ArrowPopViewController Delegate method

- (void)clickedSelectedIndex:(NSInteger)index
{
    switch (index) {
        case 0:
//            DDLogInfo(@"PIN");
            break;

        case 1: {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
            break;
        case 2: {
            NSArray *activityItems = @[urlStr];
            NSArray *excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage, UIActivityTypePostToFacebook, UIActivityTypePostToFlickr];

            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            activityController.excludedActivityTypes = excludeActivities;

            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [self presentViewController:activityController animated:YES completion:nil];
            } else {
                UIPopoverController *popUp = [[UIPopoverController alloc] initWithContentViewController:activityController];
                [popUp presentPopoverFromRect:rectButton inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

//                 [popUp presentPopoverFromBarButtonItem:self.buttonSave permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
            }
        }
        default:
            break;
    }

    [popover dismissPopoverAnimated:YES];
}


@end
