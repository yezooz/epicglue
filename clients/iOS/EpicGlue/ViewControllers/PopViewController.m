//
//  PopViewController.m
//  EpicGlue
//
//  Copyright (c) 2015-16 OnlyEpicApps. All rights reserved.
//

#import "PopViewController.h"
//#import "CopyableCell.h"

@interface PopViewController ()

@end

@implementation PopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.labelUrl.text = self.popOverUrl;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CopyableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = self.tableData[(NSUInteger) indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tablePop selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

    [UIPasteboard generalPasteboard].string = self.tableData[(NSUInteger) indexPath.row];
    if (self.delegate != Nil && [self.delegate respondsToSelector:@selector(popViewController)]) {
        [self.delegate popViewController];
    }
}

@end
