/**
 *  Copyright 2012 TheBox 
 *  All rights reserved.
 *
 *  This file is part of TheBox
 *
 *  Created by Markos Charatzas (@qnoid)  on 16/04/2012.
 *  Contributor(s): .-
 */
#import "CategoriesViewController.h"
#import "TheBoxQueries.h"
#import "AFHTTPRequestOperation.h"

@interface CategoriesViewController ()
-(id)initWithBundle:(NSBundle *)nibBundleOrNil;
@property(nonatomic, strong) NSMutableArray* categories;
@end

@implementation CategoriesViewController

+(CategoriesViewController*)newCategoriesViewController 
{
    CategoriesViewController *categoriesViewController = [[CategoriesViewController alloc] initWithBundle:[NSBundle mainBundle]];
    
    AFHTTPRequestOperation* operation = [TheBoxQueries newCategoriesQuery:categoriesViewController];
    
    [operation start];

return categoriesViewController;
}

@synthesize categoriesTableView;
@synthesize categories = _categories;

-(id)initWithBundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"CategoriesViewController" bundle:nibBundleOrNil];
    
    if (self) {
        self.categories = [NSArray array];   
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark IBActions

- (IBAction)addCategory:(id)sender
{
    NSString* name = [NSString stringWithFormat:@"%d",[self.categories count] + 1];
    AFHTTPRequestOperation* createCategoryOperation = [TheBoxQueries newCreateCategoryQuery:name delegate:self];
    
    [createCategoryOperation start];
}

- (IBAction)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[[self.categories objectAtIndex:indexPath.row] objectForKey:@"category"] objectForKey:@"name"];
    
    return cell;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* category = [ [self.categories objectAtIndex:indexPath.row] objectForKey:@"category"];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:category forKey:@"category"]; 
    
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	
	[center postNotificationName:@"didSelectCategory" object:self userInfo:userInfo];
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark TBCreateCategoryOperationDelegate

-(void)didSucceedWithCategory:(NSDictionary*)category
{
    [_categories addObject:category];
    [self.categoriesTableView reloadData];
}

-(void)didFailOnCreateCategoryWithError:(NSError*)error
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);   
}

#pragma mark TBCategoriesOperationDelegate

-(void)didSucceedWithCategories:(NSArray*)categories
{
    _categories = [categories mutableCopy];
    [self.categoriesTableView reloadData];
}

-(void)didFailOnCategoriesWithError:(NSError*)error
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
}


@end
