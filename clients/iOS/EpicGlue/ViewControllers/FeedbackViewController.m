//
//  FeedbackViewController.m
//  EpicGlue
//
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UIColor+RGB.h"
#import "UserClient.h"

static NSString *const kTextViewKey = @"Write here.";

@interface FeedbackViewController () <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>
{

    __weak IBOutlet UIButton *buttonUpDown;
    __weak IBOutlet UITableView *tableViewText;
    IBOutlet UIBarButtonItem *submitButton;
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet NSLayoutConstraint *bottomConstraint;

    IBOutlet UILabel *labelMessage;

    IBOutlet UIView *borderView;
    IBOutlet UITextView *textViewFeedback;
    BOOL isTableViewHidden;
    NSArray *arrayTableData;
//    IBOutlet UIButton *buttonSubmit;
}
@end

@implementation FeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    isTableViewHidden = YES;
    tableViewText.hidden = YES;
    tableViewText.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewText.layer.cornerRadius = 5;
    tableViewText.layer.masksToBounds = YES;
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    arrayTableData = @[NSLocalizedString(@"Suggest changes", nil), NSLocalizedString(@"Business Proposal", nil), NSLocalizedString(@"Just say Hi!", nil)];

    borderView.layer.cornerRadius = 10;
    borderView.layer.masksToBounds = YES;

    submitButton.enabled = ![textViewFeedback.text isEqualToString:@""];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];  // end //
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];

    [textViewFeedback becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayTableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = arrayTableData[(NSUInteger) indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];

    // TODO: use helper
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor fromIntegerRed:49 Green:57 Blue:60];
    } else {
        cell.backgroundColor = [UIColor fromIntegerRed:42 Green:49 Blue:51];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableViewHidden:YES];
    labelMessage.text = arrayTableData[(NSUInteger) indexPath.row];
}

- (void)tableViewHidden:(BOOL)enable
{
    [UIView animateWithDuration:0.5 animations:^{
        tableViewText.hidden = enable;
        isTableViewHidden = enable;

        if (enable) {
            [buttonUpDown setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
        } else {
            [buttonUpDown setImage:[UIImage imageNamed:@"upArrow"] forState:UIControlStateNormal];

        }
        [tableViewText reloadData];
    }];
}

#pragma mark - Button Actions

- (IBAction)buttonUpDownArrow:(UIButton *)sender
{
    [textViewFeedback resignFirstResponder];
    [self tableViewHidden:!isTableViewHidden];
}

- (IBAction)buttonSubmitFeedBack:(id)sender
{
    [textViewFeedback resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];

    [[UserClient instance] submitFeedback:[NSString stringWithFormat:@"%@\n\n%@", labelMessage.text, textViewFeedback.text]];
}

- (IBAction)buttonDismiss:(id)sender
{
    [textViewFeedback resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -  TextView Delegate method

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    submitButton.enabled = ![textViewFeedback.text isEqualToString:@""];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    submitButton.enabled = ![textViewFeedback.text isEqualToString:@""];
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    submitButton.enabled = range.location > 0;
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)note
{
    [self tableViewHidden:YES];
    NSDictionary *userInfo = [note userInfo];
    CGSize kbSize = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    [UIView animateWithDuration:0.3 animations:^{
        bottomConstraint.constant = kbSize.height + 20;
        [self.view setNeedsLayout];
        [borderView setNeedsLayout];
        [self.view layoutIfNeeded];
        [borderView layoutIfNeeded];
    }];
}

- (void)keyboardDidHide:(NSNotification *)note
{
    [self tableViewHidden:YES];
    [UIView animateWithDuration:0.3 animations:^{
        bottomConstraint.constant = 30;
        [self.view setNeedsLayout];
        [borderView setNeedsLayout];
        [self.view layoutIfNeeded];
        [borderView layoutIfNeeded];
    }];
}
@end
