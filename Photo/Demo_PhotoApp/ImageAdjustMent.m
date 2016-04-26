//
//  ImageAdjustMent.m
//  Demo_PhotoApp
//
//  Created by Apple on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageAdjustMent.h"

@implementation ImageAdjustMent
@synthesize arrayMyalbum;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark
#pragma mark TableView Delegate Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayMyalbum count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifire = @"Cell0";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifire];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifire];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *btnDownload = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnDownload.frame = CGRectMake(120, 14, 150, 38);
        [btnDownload setTitle:@"Image Adjustment" forState:UIControlStateNormal];
        
        [cell addSubview:btnDownload];
        
    }
    cell.imageView.image = [arrayMyalbum objectAtIndex:indexPath.row];          
    //       cell.textLabel.text = 
//    cell.textLabel.text = [arrayMyalbum objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" Delete Tapped");
    [arrayMyalbum removeObjectAtIndex:indexPath.row];
    [tableView reloadData];
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSLog(@"Move Perform");
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    tblAdjusment.editing = YES;
    self.navigationItem.title = @"Image Adjustment";
    [arrayMyalbum retain];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTapped:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStyleDone target:self action:@selector(CreateTapped:)];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
 
-(void)CreateTapped:(id)sender
{
    UIAlertView* alertAddTestName = [[UIAlertView alloc] init];
    alertAddTestName.tag=1;
    [alertAddTestName setDelegate:self];
    [alertAddTestName setTitle:@"Enter Album Name"];
    [alertAddTestName setMessage:@" "];
    [alertAddTestName addButtonWithTitle:@"Cancel"];
    [alertAddTestName addButtonWithTitle:@"OK"];
    
    
    txtEmailID = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    [txtEmailID setBackgroundColor:[UIColor whiteColor]];
    
    [alertAddTestName addSubview:txtEmailID];
    
    //[txtAddTestNameL setBackgroundColor:[UIColor whiteColor]];
    //[alertAddTestName addSubview:txtAddTestNameL];
    [alertAddTestName show];
    [alertAddTestName release];
    [txtEmailID release];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSLog(@"Cancle Tapped :");
    }
    else if(buttonIndex == 1)
    {
        NSLog(@"OK Tapped :");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)viewDidUnload
{
    [tblAdjusment release];
    tblAdjusment = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [tblAdjusment release];
    [super dealloc];
}
- (IBAction)goToImageFacebookPage:(id)sender {
    
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
    
}
@end
