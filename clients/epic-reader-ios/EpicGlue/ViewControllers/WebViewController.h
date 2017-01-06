//
//  WebViewController.h
//  EpicGlue
//
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//


#import "NJKWebViewProgress.h"

@interface WebViewController : UIViewController <UIWebViewDelegate, NJKWebViewProgressDelegate>
@property(weak, nonatomic) IBOutlet UIWebView *webView;

@property(strong, nonatomic) NSString *strTitle;
@property(strong, nonatomic) NSURL *webUrl;
@property(strong, nonatomic) IBOutlet UIView *navView;

@property(strong, nonatomic) IBOutlet UIBarButtonItem *buttonSave;

@end
