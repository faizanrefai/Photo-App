//
//  ViewController.m
//  Demo_PhotoApp
//
//  Created by Apple on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "SBJSON.h"
#import "PhotoCategory.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDeleg =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.title = @"Create Album";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select Source" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Take Picture",@"Choose from Album",@"Choose from Facebook", nil];
    
    
    [alert show];
    [alert release];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSLog(@"Button index 1");
    }
    else if(buttonIndex == 2)
    {
        NSLog(@"Button index 2");
        if(!objPhoto)
        {
            objPhoto = nil;
            [objPhoto release];
            
        } 
        objPhoto = [[PhotoCategory alloc] initWithNibName:@"PhotoCategory" bundle:nil];
        [self.navigationController pushViewController:objPhoto animated:YES];

    }
    else if(buttonIndex == 3)
    {
        
         NSLog(@"Button index 3");
        if(!appDeleg.fbGraph.accessToken)
        {
            
            [appDeleg.fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(callBackFB:) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins,friends_photos"];
        }

    }
}

-(void)callBackFB:(id)sender
{
    NSLog(@"Success") ;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
//    fbResponce = [fbGraph doGraphGet:@"me/photos" withGetVars:nil];
//
//    SBJSON *parser = [[SBJSON alloc] init];
//    NSDictionary *facebook_response = [parser objectWithString:fbResponce.htmlResponse error:nil];   
//    [parser release];

//    NSLog(@"Array Album Data :: %@",(NSMutableArray *) [facebook_response objectForKey:@"data"]);

        if(!objPhoto)
        {
            objPhoto = nil;
            [objPhoto release];
        } 
        objPhoto = [[PhotoCategory alloc] initWithNibName:@"PhotoCategory" bundle:nil];
        [self.navigationController pushViewController:objPhoto animated:YES];
}

-(IBAction)pushView:(id)sender
{
    if(!objPhoto)
    {
        objPhoto = nil;
        [objPhoto release];
    } 
    objPhoto = [[PhotoCategory alloc] initWithNibName:@"PhotoCategory" bundle:nil];
    [self.navigationController pushViewController:objPhoto animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
