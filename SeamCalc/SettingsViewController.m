//
//  SettingsViewController.m
//  SeamCalc
//
//  Created by Purbo Mohamad on 1/13/14.
//  Copyright (c) 2014 Purbo Mohamad. All rights reserved.
//

#import "SettingsViewController.h"
#import "Settings.h"
#import <TOWebViewController/TOWebViewController.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"SettingsTitle", @"Settings");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [(UITableView *)self.view reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else {
        return 3;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    } else {
        return @"Copyright ©2014 by";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellCopyrightIdentifier = @"CellCopyright";
    UITableViewCell *cell = nil;

    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"SettingsThemeTitle", @"Theme");
            if ([[Settings getTheme] isEqualToString:MMP_VALUE_THEME_MORNING]) {
                cell.detailTextLabel.text = NSLocalizedString(@"SettingsTheme0", @"Morning");
            } else {
                cell.detailTextLabel.text = NSLocalizedString(@"SettingsTheme1", @"Dusk");
            }
        } else {
            cell.textLabel.text = NSLocalizedString(@"SettingsOrientationTitle", @"Orientation");
            if ([Settings getOrientation] == MMPSAOrientationMmOnTop) {
                cell.detailTextLabel.text = NSLocalizedString(@"SettingsOrientation0", @"mm on top");
            } else {
                cell.detailTextLabel.text = NSLocalizedString(@"SettingsOrientation1", @"inch on top");
            }
        }
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellCopyrightIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"verypurpleperson";
            cell.detailTextLabel.text = @"www.verypurpleperson.com";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Fuwawa Sensei";
            cell.detailTextLabel.text = @"www.fuwawasensei.com";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Mamad Purbo";
            cell.detailTextLabel.text = @"mamad.purbo.org";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"settingsToThemes" sender:self];
        } else {
            [self performSegueWithIdentifier:@"settingsToOrientations" sender:self];
        }
    } else if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSURL *url = nil;
        
        if (indexPath.row == 0) {
            url = [NSURL URLWithString:@"www.verypurpleperson.com"];
        } else if (indexPath.row == 1) {
            url = [NSURL URLWithString:@"www.fuwawasensei.com"];
        } else if (indexPath.row == 2) {
            url = [NSURL URLWithString:@"mamad.purbo.org"];
        }
        
        TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
