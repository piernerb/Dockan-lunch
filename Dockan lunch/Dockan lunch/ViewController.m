//
//  TableViewController.m
//  qwe
//
//  Created by Pierre Nerbring on 6/8-14.
//  Copyright (c) 2014 Pierre Nerbring. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *restaurantArray;
@property (strong, nonatomic) NSMutableArray *menuArray;
@property (strong, nonatomic) NSString *weekdayString;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.restaurantArray = [[NSMutableArray alloc] init];
    self.menuArray = [[NSMutableArray alloc] init];
    
	NSData *menuData = [[NSData alloc] initWithContentsOfURL:
                        [NSURL URLWithString:@"http://pigvj.com/restaurant/food.php?groupby=day"]];
    NSError *error;
    NSMutableDictionary *weekMenu = [NSJSONSerialization
                                     JSONObjectWithData:menuData
                                     options:NSJSONReadingMutableContainers
                                     error:&error];
    if( error )
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    else {
        
        NSDateComponents *comps = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
        
        self.weekdayString = [[NSString alloc] init];
        
        switch ([comps weekday]) {
            case 1:
                self.weekdayString = @"sunday";
                break;
            case 2:
                self.weekdayString = @"monday";
                break;
            case 3:
                self.weekdayString = @"tuesday";
                break;
            case 4:
                self.weekdayString = @"wednesday";
                break;
            case 5:
                self.weekdayString = @"thursday";
                break;
            case 6:
                self.weekdayString = @"friday";
                break;
            case 7:
                self.weekdayString = @"saturday";
                break;
                
            default:
                break;
        }

        int weekDayInt = [comps weekday]-1;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSArray *weekDaysArray = [dateFormatter weekdaySymbols];
        NSString *weekDayString = [weekDaysArray[weekDayInt] lowercaseString];
        
        for ( NSDictionary *todaysMenu in weekMenu[self.weekdayString] )
        {
            [self.restaurantArray addObject:todaysMenu[@"restaurant"]];
            [self.menuArray addObject:todaysMenu[@"menu"]];
            
            NSLog(@"Menu: %@%@", todaysMenu[@"restaurant"], todaysMenu[@"menu"] );
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.restaurantArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *dateCell = [tableView dequeueReusableCellWithIdentifier:@"DateCell" forIndexPath:indexPath];
        UILabel *dateLabel = (UILabel *)[dateCell viewWithTag:1];
        dateLabel.text = self.weekdayString;
        return dateCell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
        
        UILabel *restaurantLabel = (UILabel *)[cell viewWithTag:1];
        
        if ([[self.restaurantArray objectAtIndex:indexPath.row-1] isEqualToString:@"P2"]) {
            UIImageView *logo = (UIImageView *)[cell viewWithTag:3];
            [logo setImage:[UIImage imageNamed:@"p2"]];
        }
        else if ([[self.restaurantArray objectAtIndex:indexPath.row-1] isEqualToString:@"Årstiderna"]) {
            UIImageView *logo = (UIImageView *)[cell viewWithTag:3];
            [logo setImage:[UIImage imageNamed:@"arstiderna"]];
        }
        else if ([[self.restaurantArray objectAtIndex:indexPath.row-1] isEqualToString:@"M.E.C.K"]) {
            UIImageView *logo = (UIImageView *)[cell viewWithTag:3];
            [logo setImage:[UIImage imageNamed:@"meck"]];
        }
        else if ([[self.restaurantArray objectAtIndex:indexPath.row-1] isEqualToString:@"Stereo"]) {
            UIImageView *logo = (UIImageView *)[cell viewWithTag:3];
            [logo setImage:[UIImage imageNamed:@"stereo"]];
        }
        else if ([[self.restaurantArray objectAtIndex:indexPath.row-1] isEqualToString:@"Glasklart"]) {
            UIImageView *logo = (UIImageView *)[cell viewWithTag:3];
            [logo setImage:[UIImage imageNamed:@"glasklart"]];
        }
        else if ([[self.restaurantArray objectAtIndex:indexPath.row-1] isEqualToString:@"Akvariet"]) {
            UIImageView *logo = (UIImageView *)[cell viewWithTag:3];
            [logo setImage:[UIImage imageNamed:@"akvariet"]];
        }
        else {
            restaurantLabel.text = [_restaurantArray objectAtIndex:indexPath.row];
        }
        
        UITextView *menuTextView = (UITextView *)[cell viewWithTag:2];
        menuTextView.text = [[self.menuArray objectAtIndex:indexPath.row-1] componentsJoinedByString:@"\n"];
        
        return cell;
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
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

@end
